----DEBUGGER----

----CONFIGURATION----
-- local Configurations = game:GetService("ReplicatedFirst").Configuration
-- local GraphicsConfiguration = require(Configurations["graphics.cfg"])


----====----====----====----====----====----====----====----====----====----====


----SERVICES----
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local RunService = game:GetService("RunService")
-- local Debris = game:GetService("Debris")

----DIRECTORIES----
-- local LocalPlayer = game:GetService("Players").LocalPlayer
-- local PlayerGui = LOCAL_PLAYER:WaitForChild("PlayerGui")
-- local PlayerScripts = LOCAL_PLAYER:WaitForChild("PlayerScripts")
-- local TacticalLiquid = REPLICATED_STORAGE:WaitForChild("TacticalLiquid")

----INTERNAL CLASSES----
----EXTERNAL CLASSES----
----INTERNAL MODULES----

----EXTERNAL MODULES----

----LIBRARIES----
-- local Util = require(ReplicatedStorage.Libraries.Utility)

-- local FastCast = require(ReplicatedStorage.Libraries.FastCastRedux)
-- local Tracers = require(ReplicatedStorage.Libraries.Tracers)

----====----====----====----====----====----====----====----====----====----====

----VARIABLES----
-- local Camera = workspace.CurrentCamera
-- local TracersFolder = Util.quickInstance("Folder", {
--     Name = "Tracers",
--     Parent = Camera
-- })
-- local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
-- LocalPlayer.CharacterAdded:Connect(function(newCharacter)
--     Character = newCharacter
-- end)
local Caster
local Behavior

----FUNCTIONS----
local function Fire(EndPoint, Direction, Velocity)
    return Caster:Fire(EndPoint, Direction, Velocity, Behavior)
end

local function SetObjects(newCaster, newBehavior)
    Caster = newCaster
    Behavior = newBehavior
end

----CONNECTED FUNCTIONS----

----====----====----====----====----====----====----====----====----====----====

----PUBLIC----
local Panel = {}

Panel.Fire = Fire
Panel.SetObjects = SetObjects

return Panel