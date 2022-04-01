--services
local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")
local RUN_SERVICE = game:GetService("RunService")

--constant directories
local LOCAL_PLAYER = game:GetService("Players").LocalPlayer
local PLAYER_GUI = LOCAL_PLAYER:WaitForChild("PlayerGui")
local PLAYER_SCRIPTS = LOCAL_PLAYER:WaitForChild("PlayerScripts")
local TACTICAL_LIQUID = REPLICATED_STORAGE:WaitForChild("TacticalLiquid")

--client modules
local filesPanel = require(PLAYER_SCRIPTS.TacticalLiquidClient.FilesPanel)
local playerPanel = require(PLAYER_SCRIPTS.TacticalLiquidClient.PlayerPanel)
local inputPanel = require(PLAYER_SCRIPTS.TacticalLiquidClient.InputPanel)

--self modules
local weaponsPanel = require(script.WeaponsPanel)
local viewmodelPanel = require(script.ViewmodelPanel)

--shared modules
local userDataPanel = require(REPLICATED_STORAGE.Libraries.UserDataPanel)
local Utility = require(REPLICATED_STORAGE.Libraries.Utility)

--variable directories
local Character, CharacterChanged = playerPanel.GetCharacter()
CharacterChanged:Connect(function(NewCharacter)
    Character = NewCharacter
end)

--tables
local UserData = userDataPanel.__myData

--flags
local Firing = false

--input events
local MouseButton1 = inputPanel.createInputListener(Enum.UserInputType.MouseButton1, true)
local OneKeyboard = inputPanel.createInputListener(Enum.KeyCode.One, false)

--lambdas
MouseButton1.inputChanged:Connect(function(_, bool)
    if not Character then
        Firing = false
        return
    end

    Firing = bool
    if Firing then
        repeat
            weaponsPanel.fire()
        until not Firing
    end
end)

local Active = false
local Viewmodels = {}

OneKeyboard.inputChanged:Connect(function(_, bool)
    if not Character then return end
    if not bool then return end

    if Active then
        Active = false
        viewmodelPanel.clearActiveViewmodel()
        return
    end

    Active = true

    if not Viewmodels["crappy viewmodel 2"] then
        local something = viewmodelPanel.createViewmodel(TACTICAL_LIQUID:FindFirstChild("crappy viewmodel 2"), "crappy viewmodel 2")
        Viewmodels["crappy viewmodel 2"] = something
        print(something)
        print(Viewmodels["crappy viewmodel 2"])
    end
    viewmodelPanel.setViewmodel(Viewmodels["crappy viewmodel 2"])
end)