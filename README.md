# QuickPerms

QuickPerms is a module which allows users to quickly write requirements to be granted permissions, this module is designed to be used for open source models like GUI kits so that your users can customize their permissions.

[**DevForum Page**](https://devforum.roblox.com/t/quickperms-a-small-module-for-naming-and-checking-requirements-against-players-for-your-open-source-models/1903523)

[**Model Link**](https://www.roblox.com/library/10452609332/QuickPerms)

## Installation
Normal Installation
```lua
local QuickPerms = require(10452609332)
QuickPerms = QuickPerms()
```

Installation with custom Permission Checks.
```lua
local QuickPerms = require(10452609332)

function PermissionCheckA(Player)
	return (math.random(1,2) == 1)
end

function PermissionCheckB(Player, Param)
	return not Param
end

QuickPerms = QuickPerms({
	["CheckA"] = PermissionCheckA;
	["CheckB"] = PermissionCheckB;
})
```
Please view the wiki for documentation.
