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
local Tracers = FilesPanel.CreateNewDirectory(Camera, "Tracers")

local MouseButton1 = InputPanel.CreateInputListener(Enum.UserInputType.MouseButton1, true)

local RaycastParams = RaycastParams.new()
RaycastParams.FilterDescendantsInstances = {Camera}
RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
local Behaviour = FastCast.newBehavior()
Behaviour.CosmeticBulletTemplate = ParticleFramework.GeneratePair()
Behaviour.CosmeticBulletContainer = Tracers
Behaviour.RaycastParams = RaycastParams
local Caster = FastCast.new()

MouseButton1.InputChanged:Connect(function(_, bool)
    Firing = bool
    print(bool)
    if Firing then
        repeat
            Caster:Fire(Camera.CFrame.Position, Camera.CFrame.LookVector, 10, Behaviour)
            task.wait(0.1)
        until not Firing
    end
end)

Caster.LengthChanged:Connect(function(CasterThatFired, LastPoint, RayDirection, Displacement, SegmentVelocity, CosmeticBulletObject)
    local CurrentPoint = LastPoint + (RayDirection * Displacement)
    local CurrentPointMinusOne = CurrentPoint - (RayDirection * 5)

    CosmeticBulletObject.Attachment0.WorldPosition = CurrentPoint
    CosmeticBulletObject.Attachment1.WorldPosition = CurrentPointMinusOne
end)