--[[

Fin tool II

by Austin "Q42" Fox

This addon is not for stealing. K THX.

---
#1
---
Edited : 01.10.2017
File: fin2.lua
By : ravo Norway

Changes :
        Added support for viewing settings when hovering over a
        prop with Fin 2 attached to it.
---
#2
---
Edited : 02.10.2017
File: init.lua
By : ravo Norway

Changes :
        Replaced "DotProduct" with "Dot" for future support.
---
#3
---
Edited : 07.02.2017
File: fin2.lua and init.lua
By : ravo Norway

Changes :
        Updated the VGUI. Fixed the "ULib-bug". Fixed pos. and angle, and added another option to that to activate or not in the VGUI.
---
#4
---
Edited : 07.09.2019
File: fin2.lua
By : Phatso

Changes :
        Fixed a small bug where minwind / maxwind were inappropriately nil
]]

fintool = {}
fintool.maxeff = 250

function fintool.initialize_()
	fintool.maxwind = 360
	fintool.minwind = 0
	fintool.wind = Vector(math.Rand(fintool.minwind, fintool.maxwind), math.Rand(fintool.minwind, fintool.maxwind), 0)
end

hook.Add("Initialize", "finitialize_", fintool.initialize_ )

function fintool.think_()
	fintool.nextthink = fintool.nextthink or CurTime()
	if CurTime() > fintool.nextthink then
		local minwind = fintool.minwind or 0
		local maxwind = fintool.maxwind or 360

		fintool.maxdelay = fintool.maxdelay or 120
		fintool.wind = Vector(math.Rand(minwind, maxwind), math.Rand(minwind, maxwind), 0)
		fintool.nextthink = fintool.nextthink + math.Rand(0, fintool.maxdelay)

        fintool.maxeff = fintool.maxeff or 250
	end
end
hook.Add( "Think", "finthink_", fintool.think_ )

-- Server console (NULL player) or an admin
local function canConfigure(player)
	return !IsValid(player) or player:IsAdmin() or player:IsSuperAdmin()
end

-- Min/Max delay
function fintool.setmaxdelay(player, command, arg)
	if canConfigure(player) then fintool.maxdelay = tonumber(arg[1]) or 120 end
end 
concommand.Add("fintool_setmaxwinddelay",fintool.setmaxdelay)

-- Min/Max wind
function fintool.setmaxwind(player, command, arg)
	if canConfigure(player) then fintool.maxwind = tonumber(arg[1]) or 360 end
end 

concommand.Add("fintool_setmaxwind",fintool.setmaxwind)

function fintool.setminwind(player, command, arg)
	if canConfigure(player) then fintool.minwind = tonumber(arg[1]) or 0 end
end 

concommand.Add("fintool_setminwind",fintool.setminwind)

-- Max eff.
function fintool.setmaxeff(player, command, arg)
	if canConfigure(player) then fintool.maxeff = tonumber(arg[1]) or 250 end
end 

concommand.Add("fintool_setmaxeff", fintool.setmaxeff)