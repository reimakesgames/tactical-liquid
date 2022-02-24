--services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

--constant directories
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")

--client modules
local FilesPanel = require(PlayerScripts.TacticalLiquidClient.FilesPanel)
local PlayerPanel = require(PlayerScripts.TacticalLiquidClient.PlayerPanel)
local InputPanel = require(PlayerScripts.TacticalLiquidClient.InputPanel)
local WeaponsPanel = require(PlayerScripts.TacticalLiquidClient.WeaponsPanel)

--shared modules
local UserDataPanel = require(ReplicatedStorage.Libraries.UserDataPanel)


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
	