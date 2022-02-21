local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local UserDataPanel = require(ReplicatedStorage.Libraries.UserDataPanel)
local UserData = UserDataPanel.MyData
local FilesPanel = require(PlayerScripts.TacticalLiquidClient.FilesPanel)
local PlayerPanel = require(PlayerScripts.TacticalLiquidClient.PlayerPanel)
local InputPanel = require(PlayerScripts.TacticalLiquidClient.InputPanel)

local FastCast = require(ReplicatedStorage.Libraries.FastCastRedux)
local ParticleFramework = require(ReplicatedStorage.Libraries.ParticleFramework)

local Firing = false

local Camera = PlayerPanel.GetCamera()
local Character, CharacterChanged = PlayerPanel.GetCharacter()
CharacterChanged:Connect(function(NewCharacter)
    Character = NewCharacter
end)
local Tracers = FilesPanel.CreateNewDirectory(Camera, "Tracers")

local MouseButton1 = InputPanel.CreateInputListener(Enum.UserInputType.MouseButton1, true)

local Behaviour = FastCast.newBehavior()

local function Pierce(cast, result, segmentVelocity)
    if result.Instance.Transparency == 1 or result.Instance.Parent == Camera or result.Instance.Parent == Character  or result.Instance.Parent:IsA("Accessory") or result.Instance.Parent.Name == "PlayerClip" then
        return true
    else
        return false
    end
end
	
Behaviour.RaycastParams = nil
Behaviour.Acceleration = Vector3.new()
Behaviour.MaxDistance = 1000
Behaviour.CanPierceFunction = Pierce
Behaviour.HighFidelityBehavior = FastCast.HighFidelityBehavior.Default
Behaviour.HighFidelitySegmentSize = 0.5
Behaviour.CosmeticBulletTemplate = ParticleFramework.GeneratePair()
Behaviour.CosmeticBulletProvider = nil
Behaviour.CosmeticBulletContainer = Tracers
Behaviour.AutoIgnoreContainer = true

local Caster = FastCast.new()

MouseButton1.InputChanged:Connect(function(_, bool)
    Firing = bool
    print(bool)
    if Firing then
        repeat
            Caster:Fire(Camera.CFrame.Position, Camera.CFrame.LookVector, 1000, Behaviour)
            task.wait(0.1)
        until not Firing
    end
end)

Caster.LengthChanged:Connect(function(CasterThatFired, LastPoint, RayDirection, Displacement, SegmentVelocity, CosmeticBulletObject)
    local CurrentPoint = LastPoint + (RayDirection * Displacement)
    local CurrentPointMinusOne = CurrentPoint - (RayDirection.Unit * 25)

    CosmeticBulletObject.Attachment0.WorldPosition = CurrentPoint
    for _, v in pairs(CosmeticBulletObject:GetChildren()) do
        if v:IsA("Beam") then
            v.Width0 = ((Camera.CFrame.Position - CurrentPoint).Magnitude / 10) * 0.1
        end
    end
    CosmeticBulletObject.Attachment1.WorldPosition = CurrentPointMinusOne
    for _, v in pairs(CosmeticBulletObject:GetChildren()) do
        if v:IsA("Beam") then
            v.Width1 = ((Camera.CFrame.Position - CurrentPointMinusOne).Magnitude / 10) * 0.1
        end
    end
end)

Caster.RayPierced:Connect(function(CasterThatFired, RaycastResult, SegmentVelocity, CosmeticBulletObject)
    
end)

Caster.RayHit:Connect(function(CasterThatFired, RaycastResult, SegmentVelocity, CosmeticBulletObject)
    CosmeticBulletObject:Destroy()
end)