AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self.Entity:SetMoveType( MOVETYPE_NONE )                 
end   

function ENT:OnRemove()
	local parent = self.ent
	if !IsValid(parent) then return end

	-- Per-player client setting, read from whoever created the fin
	local deleteDup = true
	if IsValid(self.owner) then
		deleteDup = self.owner:GetInfoNum("fin2_delete_dup_onremove", 1) != 0
	end

	if deleteDup then
		duplicator.ClearEntityModifier(parent, "fin2")
	end
	if parent.Fin2_Ent == self.Entity then
		parent.Fin2_Ent = nil
	end
end

 function ENT:Think()
	if !IsValid(self.ent) then return end
	local physobj = self.ent:GetPhysicsObject()
	if !IsValid(physobj) then return end
	
	local curvel = physobj:GetVelocity()
	local curup = self:GetForward()
	
	local vec1 = curvel
	local vec2 = curup
	vec1 = vec1 - 2*(vec1:Dot(vec2))*vec2
	local sped = vec1:Length()
	
	local finalvec = curvel
	local modf = math.abs(curup:Dot(curvel:GetNormalized()))
	local nvec = (curup:Dot(curvel:GetNormalized()))
	
	if (self.pln == 1) then
		
		if nvec > 0 then
			vec1 = vec1 + (curup * 10)
		else
			vec1 = vec1 + (curup * -10)
		end
		
		finalvec = vec1:GetNormalized() * (math.pow(sped, modf) - 1)
		finalvec = finalvec:GetNormalized()
		-- vec1 is curvel mirrored across the fin plane. Weighting it by more than |curvel| flips the normal
		-- velocity every tick instead of just removing it, so the vehicle vibrates at high efficiency or low speed
		finalvec = (finalvec * math.min(self.efficiency, sped)) + curvel
	end
	
	if (self.lift != "lift_none") then
		if (self.lift == "lift_normal") then
			local liftmul = 1 - math.abs(nvec)
			finalvec = finalvec + (curup * liftmul * curvel:Length() * self.efficiency) / 700
		else
			local liftmul = (nvec >= 0 and 1 or -1) - nvec -- nvec / abs(nvec) is NaN at 0
			finalvec = finalvec + (curup * curvel:Length() * self.efficiency * liftmul) / 700
		end
	end
	
	finalvec = finalvec:GetNormalized()
	finalvec = finalvec * curvel:Length()
	
	if (self.wind == 1) then
		local wind = ((2 * (fintool.wind:Dot(curup)) * curup - fintool.wind)) * (math.abs(fintool.wind:Dot(curup)) / 10000)
		wind = wind * (self.efficiency / 50)
		finalvec = finalvec + wind
	end
	
	if (self.cline == 1) then
		local trace = {
			start = self.ent:GetPos(),
			endpos = self.ent:GetPos() + Vector(0, 0, -1000000),
			mask = 131083
		}
		local trc = util.TraceLine(trace)
		
		local MatType = trc.MatType
		
		if (MatType == 67 || MatType == 77) then
			local heatvec = Vector(0, 0, 100)
			local cline = ((2 * (heatvec:Dot(curup)) * curup - heatvec)) * (math.abs(heatvec:Dot(curup)) / 1000)
			finalvec = finalvec + (cline * (self.efficiency / 50))
		end
		
	end
	
	
	physobj:SetVelocity(finalvec)
	
	
	
	self.Entity:NextThink( CurTime())
	return true 
 end
