local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local FilesPanel = require(PlayerScripts.TacticalLiquidClient.FilesPanel)
local PlayerPanel = require(PlayerScripts.TacticalLiquidClient.PlayerPanel)
local InputPanel = require(PlayerScripts.TacticalLiquidClient.InputPanel)

local FastCast = require(ReplicatedStorage.Libraries.FastCastRedux)
local ParticleFramework = require(ReplicatedStorage.Libraries.ParticleFramework)

local Firing = false

local Camera = PlayerPanel.GetCamera()
local Tracers = FilesPanel.CreateNewDirectory(Camera, "Tracers")

local MouseButton1 = InputPanel.CreateInputListener(Enum.UserInputType.MouseButton1, true)

local Behaviour = FastCast.newBehaviour()
Behaviour.CosmeticBulletTemplate = ParticleFramework.GeneratePair()
Behaviour.CosmeticBulletContainer = Tracers
local Caster = FastCast.new()

MouseButton1.InputChanged:Connect(function(InputDown)
    Firing = InputDown
    print(Firing)
    if not Firing then
        repeat
            Caster:Fire(Camera.CFrame.Position, Camera.CFrame.LookVector, 10, Behaviour)
            task.wait(0.1)
        until not Firing
    end
end)
