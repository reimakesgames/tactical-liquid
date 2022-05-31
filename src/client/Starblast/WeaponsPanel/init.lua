----DEBUGGER----

----CONFIGURATION----
local Configurations = game:GetService("ReplicatedFirst").Configuration
local GraphicsConfiguration = require(Configurations["graphics.cfg"])


----====----====----====----====----====----====----====----====----====----====


----SERVICES----
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

----DIRECTORIES----
local LocalPlayer = game:GetService("Players").LocalPlayer
-- local PlayerGui = LOCAL_PLAYER:WaitForChild("PlayerGui")
-- local PlayerScripts = LOCAL_PLAYER:WaitForChild("PlayerScripts")
-- local TacticalLiquid = REPLICATED_STORAGE:WaitForChild("TacticalLiquid")

----INTERNAL CLASSES----
----EXTERNAL CLASSES----

----INTERNAL MODULES----
local HitEffects = require(script.HitEffects)
local Standard = require(script.Standard)

----EXTERNAL MODULES----

----LIBRARIES----
local Util = require(ReplicatedStorage.Libraries.Utility)

local FastCast = require(ReplicatedStorage.Libraries.FastCastRedux)
local Tracers = require(ReplicatedStorage.Libraries.Tracers)

----====----====----====----====----====----====----====----====----====----====

----VARIABLES----
local Camera = workspace.CurrentCamera
local TracersFolder = Util.quickInstance("Folder", {
    Name = "Tracers",
    Parent = Camera
})
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
end)
local Behavior = FastCast.newBehavior()
Behavior.RaycastParams = nil
Behavior.Acceleration = Vector3.new()
Behavior.MaxDistance = GraphicsConfiguration.bullet_render_distance
Behavior.CanPierceFunction = function(cast, result, segmentVelocity)
    if result.Instance.Transparency == 1 or result.Instance:IsDescendantOf(Camera) or result.Instance:IsDescendantOf(Character) then
        return true
    end
    return false
end
Behavior.HighFidelityBehavior = FastCast.HighFidelityBehavior.Default
Behavior.HighFidelitySegmentSize = 0.5
Behavior.CosmeticBulletTemplate = nil
Behavior.CosmeticBulletProvider = nil
Behavior.CosmeticBulletContainer = nil
Behavior.AutoIgnoreContainer = true
local caster = FastCast.new()

----FUNCTIONS----
local function Fire(EndPoint, Direction, Velocity)
    local activeCast = caster:Fire(EndPoint, Direction, Velocity, Behavior)
    if GraphicsConfiguration.bullet_renderer == "neo" then
        Tracers.new({
            position = EndPoint,
            velocity = Direction * Velocity,
            visible = true,
            cancollide = true,
            size = GraphicsConfiguration.bullet_size,
            -- brightness = 20 * math.random(),
            brightness = 50,
            color = Color3.new(1, 1, 0.8),
            -- bloom = 0.005 * math.random(),
            bloom = 0,
            life = GraphicsConfiguration.bullet_render_distance / Velocity,
            character = Character
        })
    elseif GraphicsConfiguration.bullet_renderer == "stc" then
        local Tracer = Standard.Cast(EndPoint, Direction, Velocity)
        Tracer.Parent = TracersFolder
    end
end

local function SurfaceHit(Caster, RaycastResult, SegmentVelocity, Cosmetic)
    print(RaycastResult.Instance)
    HitEffects.MakeHitPart(0, RaycastResult)
end

----CONNECTED FUNCTIONS----
caster.RayHit:Connect(SurfaceHit)

----====----====----====----====----====----====----====----====----====----====

----PUBLIC----
local Panel = {}

Panel.Fire = Fire

return Panel