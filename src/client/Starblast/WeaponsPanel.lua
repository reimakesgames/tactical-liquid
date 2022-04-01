--services
local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")

--constant directories
local LOCAL_PLAYER = game:GetService("Players").LocalPlayer
local PLAYER_GUI = LOCAL_PLAYER:WaitForChild("PlayerGui")
local PLAYER_SCRIPTS = LOCAL_PLAYER:WaitForChild("PlayerScripts")

--client modules
local playerPanel = require(PLAYER_SCRIPTS.TacticalLiquidClient.PlayerPanel)
local filesPanel = require(PLAYER_SCRIPTS.TacticalLiquidClient.FilesPanel)

--shared modules
local fastCast = require(REPLICATED_STORAGE.Libraries.FastCastRedux)
local particleFramework = require(REPLICATED_STORAGE.Libraries.ParticleFramework)
local tracers = require(REPLICATED_STORAGE.Libraries.Tracers)

--variable directories
local Character, CharacterChanged = playerPanel.GetCharacter()
CharacterChanged:Connect(function(NewCharacter)
    Character = NewCharacter
end)
local Camera = playerPanel.getCamera()

--functions
local function Pierce(Cast, Result, SegmentVelocity)
    if Result.Instance.Transparency == 1 or Result.Instance.Parent == Camera or Result.Instance.Parent == Character  or Result.Instance.Parent:IsA("Accessory") or Result.Instance.Parent.Name == "PlayerClip" then
        return true
    else
        return false
    end
end

local BEHAVIOR = fastCast.newBehavior()

BEHAVIOR.RaycastParams = nil
BEHAVIOR.Acceleration = Vector3.new()
BEHAVIOR.MaxDistance = 1000
BEHAVIOR.CanPierceFunction = Pierce
BEHAVIOR.HighFidelityBehavior = fastCast.HighFidelityBehavior.Default
BEHAVIOR.HighFidelitySegmentSize = 0.5
BEHAVIOR.CosmeticBulletTemplate = nil
BEHAVIOR.CosmeticBulletProvider = nil
BEHAVIOR.CosmeticBulletContainer = nil
BEHAVIOR.AutoIgnoreContainer = true

local Caster = fastCast.new()

local Panel = {}

Panel.fire = function()
    local ActiveCast = Caster:Fire(Camera.CFrame.Position, Camera.CFrame.LookVector, 1000, BEHAVIOR)
    tracers.new(
        {
            position = Camera.CFrame.Position,
            velocity = Camera.CFrame.LookVector * 1000,
            visible = true,
            cancollide = true,
            size = 0.2,
            brightness = 20 * math.random(),
            color = Color3.new(1, 1, 0.8),
            bloom = 0.005 * math.random(),
            --life = 1000 / Velocity --0.1
            life = 5
        }
    )
    task.wait(0.1)
end

return Panel