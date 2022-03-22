--services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

--constant directories
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local TacticalLiquid = ReplicatedStorage:WaitForChild("TacticalLiquid")

--client modules
local FilesPanel = require(PlayerScripts.TacticalLiquidClient.FilesPanel)
local PlayerPanel = require(PlayerScripts.TacticalLiquidClient.PlayerPanel)
local InputPanel = require(PlayerScripts.TacticalLiquidClient.InputPanel)

--self modules
local WeaponsPanel = require(script.WeaponsPanel)
local ViewmodelPanel = require(script.ViewmodelPanel)

--shared modules
local UserDataPanel = require(ReplicatedStorage.Libraries.UserDataPanel)
local Tracers = require(ReplicatedStorage.Libraries.Tracers)
local Utility = require(ReplicatedStorage.Libraries.Utility)

--variable directories
local Character, CharacterChanged = PlayerPanel.GetCharacter()
CharacterChanged:Connect(function(NewCharacter)
    Character = NewCharacter
end)

--tables
local UserData = UserDataPanel.MyData

--flags
local Firing = false

--input events
local MouseButton1 = InputPanel.CreateInputListener(Enum.UserInputType.MouseButton1, true)
local OneKeyboard = InputPanel.CreateInputListener(Enum.KeyCode.One, false)

--lambdas
MouseButton1.InputChanged:Connect(function(_, bool)
    if not Character then
        Firing = false
        return
    end

    Firing = bool
    print(bool)
    if Firing then
        repeat
            WeaponsPanel.Fire()
        until not Firing
    end
end)

local Active = false

OneKeyboard.InputChanged:Connect(function(_, bool)
    if not Character then return end
    print(bool)
    if not bool then return end

    if Active then
        Active = false
        ViewmodelPanel.UseViewmodel(nil)
        return
    end

    Active = true

    if not ViewmodelPanel.InactiveViewmodels:FindFirstChild("crappy viewmodel 2") then
        ViewmodelPanel.CreateViewmodelFromModel(TacticalLiquid:WaitForChild("crappy viewmodel 2"))
    end
    ViewmodelPanel.UseViewmodel(ViewmodelPanel.InactiveViewmodels["crappy viewmodel 2"])
end)