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
local HitEffects = require(script.HitEffects)

----EXTERNAL MODULES----

----LIBRARIES----
local UTILITY = require(REPLICATED_STORAGE.Libraries.Utility)

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
    if result.Instance.Transparency == 1 or result.Instance:IsDescendantOf(camera) or result.Instance:IsDescendantOf(character) then
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
            size = graphics_configuration.bullet_size,
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
        bullet.Name = "bullet_" .. tostring(velocity)
        bullet.Size = Vector3.new(0.01, 0.01, 2)
        bullet.Anchored = true
        bullet.CanCollide = true
        bullet.Color = Color3.new(1, 1, 0.8)
        bullet.Material = "Neon"
        bullet.CFrame = CFrame.new(endPoint, endPoint + direction * velocity)
        UTILITY.quickInstance("SpotLight", {
            Color = Color3.fromRGB(255, 180, 73),
            Brightness = 8,
            Range = 16,
            Angle = 60,
            Parent = bullet,
            Face = Enum.NormalId.Back,
            Shadows = true,
        })
        bullet.Parent = tracersFolder
        bullet.Touched:Connect(function(hit)
            if not hit:IsAncestorOf(camera) and not hit:IsDescendantOf(character) then
                bullet:Destroy()
            end
        end)
    end
end

local function SurfaceHit(theCaster, raycastResult: RaycastResult, segmentVelocity, cosmetic)
    local hit = raycastResult.Instance
    print(hit)
    HitEffects.OnHit(raycastResult)
end

----CONNECTED FUNCTIONS----
RUN_SERVICE:BindToRenderStep("STARBLAST_INTERNAL: 1000/STANDARD-TRACER-CASTER_UPDATE", 1000, function(deltaTime)
    for _, bullet in pairs(tracersFolder:GetChildren()) do
        local bulletParams = string.split(bullet.Name, "_")
        local velocity = tonumber(bulletParams[2])
        if not velocity then continue end
        local distanceFromCamera = (bullet.CFrame.Position - camera.CFrame.Position).Magnitude
        local distanceFromCameraUnit = (graphics_configuration.bullet_render_distance - distanceFromCamera) / graphics_configuration.bullet_render_distance
        bullet.CFrame = (bullet.CFrame + (bullet.CFrame.LookVector * (velocity * deltaTime)))
        bullet.CFrame = bullet.CFrame * CFrame.Angles(0, 0, (math.rad(velocity * deltaTime) * graphics_configuration.bullet_rotaion_speed) * distanceFromCameraUnit)
        local toFade = (distanceFromCamera - (graphics_configuration.bullet_render_distance / 2)) / (graphics_configuration.bullet_render_distance / 2)
        bullet.SpotLight.Brightness = 8 - (8 * math.clamp(toFade, 0, 1))
        bullet.Transparency = math.clamp(toFade, 0, 1)
        bullet.Size = Vector3.new(graphics_configuration.bullet_size * (distanceFromCamera / 10), graphics_configuration.bullet_size * (distanceFromCamera / 10), 2)
    end
end)

caster.RayHit:Connect(SurfaceHit)


----====----====----====----====----====----====----====----====----====----====


----PUBLIC----
local PANEL = {}

PANEL.fire = fire

return PANEL