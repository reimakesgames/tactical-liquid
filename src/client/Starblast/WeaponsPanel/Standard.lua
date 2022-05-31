local GraphicsConfiguration = require(game:GetService("ReplicatedFirst"):WaitForChild("Configuration"):WaitForChild("graphics.cfg"))
local Util = require(game:GetService("ReplicatedStorage").Libraries.Utility)
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
Players.LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
end)
local Camera = workspace.CurrentCamera

local Standard = { _activeTracers = {} }

function Standard.Cast(Position, Direction, Velocity)
    local _tracer = Instance.new("Part")
    Debris:AddItem(_tracer, GraphicsConfiguration.bullet_render_distance / Velocity)
    _tracer.Name = "bullet_" .. tostring(Velocity)
    _tracer.Size = Vector3.new(0.01, 0.01, 2)
    _tracer.Anchored = true
    _tracer.CanCollide = true
    _tracer.Color = Color3.new(1, 1, 0.8)
    _tracer.Material = "Neon"
    _tracer.CFrame = CFrame.new(Position, Position + Direction * Velocity)
    Util.quickInstance("SpotLight", {
        Name = "Light",
        Color = Color3.fromRGB(255, 180, 73),
        Brightness = 8,
        Range = 16,
        Angle = 60,
        Parent = _tracer,
        Face = Enum.NormalId.Back,
        Shadows = true,
    })
    _tracer.Touched:Connect(function(hit)
        if not hit:IsAncestorOf(Camera) and not hit:IsDescendantOf(Character) then
            _tracer:Destroy()
        end
    end)

    table.insert(Standard._activeTracers, _tracer)
    return _tracer
end

RunService:BindToRenderStep("STARBLAST_INTERNAL: 1000/STANDARD-TRACER-CASTER_UPDATE", 1000, function(DeltaTime)
    for _, tracers in pairs(Standard._activeTracers) do
        if not tracers.Parent then
            table.remove(Standard._activeTracers, _)
            continue
        end
        local bulletParams = string.split(tracers.Name, "_")
        local velocity = tonumber(bulletParams[2])
        if not velocity then continue end
        local distanceFromCamera = (tracers.CFrame.Position - Camera.CFrame.Position).Magnitude
        local distanceFromCameraUnit = (GraphicsConfiguration.bullet_render_distance - distanceFromCamera) / GraphicsConfiguration.bullet_render_distance
        tracers.CFrame = (tracers.CFrame + (tracers.CFrame.LookVector * (velocity * DeltaTime)))
        tracers.CFrame = tracers.CFrame * CFrame.Angles(0, 0, (math.rad(velocity * DeltaTime) * GraphicsConfiguration.bullet_rotaion_speed) * distanceFromCameraUnit)
        local toFade = (distanceFromCamera - (GraphicsConfiguration.bullet_render_distance / 2)) / (GraphicsConfiguration.bullet_render_distance / 2)
        tracers.Light.Brightness = 8 - (8 * math.clamp(toFade, 0, 1))
        tracers.Transparency = math.clamp(toFade, 0, 1)
        tracers.Size = Vector3.new(GraphicsConfiguration.bullet_size * (distanceFromCamera / 10), GraphicsConfiguration.bullet_size * (distanceFromCamera / 10), 2)
    end
end)

return Standard