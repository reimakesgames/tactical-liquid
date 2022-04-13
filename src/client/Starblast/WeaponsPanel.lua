----DEBUGGER----

----CONFIGURATION----
local config_root = game:GetService("ReplicatedFirst").Configuration
local graphics_configuration = require(config_root["graphics.cfg"])


----====----====----====----====----====----====----====----====----====----====


----SERVICES----
local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")
local RUN_SERVICE = game:GetService("RunService")
local DEBRIS = game:GetService("Debris")

----DIRECTORIES----
local LOCAL_PLAYER = game:GetService("Players").LocalPlayer
-- local PLAYER_GUI = LOCAL_PLAYER:WaitForChild("PlayerGui")
-- local PLAYER_SCRIPTS = LOCAL_PLAYER:WaitForChild("PlayerScripts")
-- local TACTICAL_LIQUID = REPLICATED_STORAGE:WaitForChild("TacticalLiquid")

----INTERNAL CLASSES----
----EXTERNAL CLASSES----
----INTERNAL MODULES----
----EXTERNAL MODULES----

----LIBRARIES----
-- local UTILITY = require(REPLICATED_STORAGE.Libraries.Utility)

local fastCast = require(REPLICATED_STORAGE.Libraries.FastCastRedux)
local tracers = require(REPLICATED_STORAGE.Libraries.Tracers)


----====----====----====----====----====----====----====----====----====----====


----VARIABLES----
local camera = workspace.CurrentCamera
local tracersFolder = Instance.new("Folder")
tracersFolder.Name = "Tracers"
tracersFolder.Parent = camera
local character = LOCAL_PLAYER.Character or LOCAL_PLAYER.CharacterAdded:Wait()
LOCAL_PLAYER.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
end)
local BEHAVIOR = fastCast.newBehavior()
BEHAVIOR.RaycastParams = nil
BEHAVIOR.Acceleration = Vector3.new()
BEHAVIOR.MaxDistance = graphics_configuration.bullet_render_distance
BEHAVIOR.CanPierceFunction = function(_--[[cast]], result, _--[[segmentVelocity]])
    if result.Instance.Transparency == 1 or result.Instance.Parent == camera or result.Instance.Parent == character  or result.Instance.Parent:IsA("Accessory") or result.Instance.Parent.Name == "PlayerClip" then
        return true
    end
    return false
end
BEHAVIOR.HighFidelityBehavior = fastCast.HighFidelityBehavior.Default
BEHAVIOR.HighFidelitySegmentSize = 0.5
BEHAVIOR.CosmeticBulletTemplate = nil
BEHAVIOR.CosmeticBulletProvider = nil
BEHAVIOR.CosmeticBulletContainer = nil
BEHAVIOR.AutoIgnoreContainer = true
local caster = fastCast.new()

----FUNCTIONS----
local function fire(endPoint, direction, velocity)
    local _--[[activeCast]] = caster:Fire(endPoint, direction, velocity, BEHAVIOR)
    if graphics_configuration.bullet_renderer == "neo" then
        tracers.new({
            position = endPoint,
            velocity = direction * velocity,
            visible = true,
            cancollide = true,
            size = 0.1,
            -- brightness = 20 * math.random(),
            brightness = 50,
            color = Color3.new(1, 1, 0.8),
            -- bloom = 0.005 * math.random(),
            bloom = 0,
            life = graphics_configuration.bullet_render_distance / velocity,
            character = character
        })
    elseif graphics_configuration.bullet_renderer == "stc" then
        local bullet = Instance.new("Part")
        DEBRIS:AddItem(bullet, graphics_configuration.bullet_render_distance / velocity)
        bullet.Name = "Bullet"
        bullet.Size = Vector3.new(0.01, 0.01, 2)
        bullet.Anchored = true
        bullet.CanCollide = false
        bullet.Color = Color3.new(1, 1, 0.8)
        bullet.Material = "Neon"
        bullet.CFrame = CFrame.new(endPoint, endPoint + direction * velocity)
        bullet.Parent = tracersFolder
        local rs
        bullet.Touched:Connect(function(hit)
            if hit.Parent ~= camera and hit.Parent ~= character then
                rs:Disconnect()
                bullet:Destroy()
            end
        end)
        rs = RUN_SERVICE.RenderStepped:Connect(function(deltaTime)
            if not bullet then
                rs:Disconnect()
            end
            bullet.CFrame = (bullet.CFrame + (bullet.CFrame.LookVector * (velocity * deltaTime)))
            local distanceFromCamera = (bullet.CFrame.Position - camera.CFrame.Position).Magnitude
            local toFade = (distanceFromCamera - 256) / 256
            bullet.Transparency = math.clamp(toFade, 0, 1)
            bullet.Size = Vector3.new(0.1 * (distanceFromCamera / 10), 0.1 * (distanceFromCamera / 10), 2)
        end)
    end
end

----CONNECTED FUNCTIONS----


----====----====----====----====----====----====----====----====----====----====


----PUBLIC----
local PANEL = {}

PANEL.fire = fire

return PANEL