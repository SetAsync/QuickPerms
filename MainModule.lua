--/ // // // // //
--/ Quick Perms //
--/ // // // // //

--[[
QuickPerms v1.0, SetAsync.

DevForum:

GitHub:

Works with MultiModules:
https://github.com/SetAsync/MultiModules

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of 
the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
IN THE SOFTWARE.
--]]
local QuickPerms, PermissionCheckTypes,PermissionChecks = {}, {}, {}

--// Permission Checks
PermissionChecks["player"] = function(Player, Property, Value)
	return (Player[Property] == Value)
end

PermissionChecks["function"] = function(Player, Function, ...)
	return Function(Player, ...)
end

PermissionChecks["group"] = function(Player, GroupID, minRankID, maxRankID)
	local Rank = Player:GetRankInGroup(GroupID)
	if minRankID then
		if not (Rank >= minRankID) then
			return
		end
	end
	if maxRankID then
		if not (Rank <= maxRankID) then
			return
		end
	end
	return (Rank ~= 0)
end

PermissionChecks["GameCreator"] = function(Player)
	return (Player.UserId == game.CreatorId)
end

PermissionChecks["friends"] = function(Player, FriendID, AllowedValue)
	return (Player:IsFriendsWith(FriendID) == AllowedValue)
end

PermissionChecks["checkpermissions"] = function(Player, Type, Permissions)
	Type = Type:lower()
	return PermissionCheckTypes[Type](Player, Permissions)
end

PermissionChecks["team"] = function(Player, TeamName)
	return ((Player.Team) and (Player.Team.Name == TeamName))
end

PermissionChecks["hdadminrank"] = function(Player, minRankID, maxRankID)
	-- Get HD
	local HDMain = game:GetService("ReplicatedStorage"):WaitForChild("HDAdminSetup")
	if not HDMain then
		return
	end
	HDMain = require(HDMain):GetMain()
	local HD = HDMain:GetModule("API")
	-- Check Rank
	local Rank = HD:GetRank(Player)
	if minRankID then
		if not (Rank >= minRankID) then
			return
		end
	end
	if maxRankID then
		if not (Rank <= maxRankID) then
			return
		end
	end
	return (Rank ~= 0)
end

function PlayerHasPermission(Player, Permission)
	local PermissionCheck = Permission[1]:lower()
	if PermissionChecks[PermissionCheck] then
		table.remove(Permission, 1)
		return PermissionChecks[PermissionCheck](Player, table.unpack(Permission))
	else
		warn("Invalid PermissionCheck:", PermissionCheck)
	end
end


-- // PermissionCheckTypes
function PermissionCheckTypes.all(Player, Permissions)
	for _, v in ipairs(Permissions) do
		if not PlayerHasPermission(Player, v) then
			return false
		end
	end
	return true
end

function PermissionCheckTypes.any(Player, Permissions)
	for _, v in ipairs(Permissions) do
		if PlayerHasPermission(Player, v) then
			return true
		end
	end
	return false	
end

function PermissionCheckTypes.exclusive(Player, Permissions)
	local Granted = false
	for _, v in ipairs(Permissions) do
		if PlayerHasPermission(Player, v) then
			if Granted then
				return false
			end
			Granted = true
		end
	end
	return Granted	
end

function PermissionCheckTypes.none(Player, Permissions)
	for _, v in ipairs(Permissions) do
		if PlayerHasPermission(Player, v) then
			return false
		end
	end
	return true
end

-- // Main
Main = function(Player, Type, Permissions)
	Type = Type:lower()
	if PermissionCheckTypes[Type] then
		return PermissionCheckTypes[Type](Player, Permissions)
	else
		warn("Invalid PermissionCheckType:", Type)
	end
end

return function(...)
	if ... then
		for Name, Function in pairs(...) do
			PermissionChecks[Name:lower()] = Function
		end
	end
	return Main
end
