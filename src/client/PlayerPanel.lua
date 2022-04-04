local LOCAL_PLAYER = game:GetService("Players").LocalPlayer
local PLAYER_GUI = LOCAL_PLAYER:WaitForChild("PlayerGui")
local CAMERA = workspace.CurrentCamera

local PANEL = {}

PANEL.getCharacter = function()
    return LOCAL_PLAYER.Character or LOCAL_PLAYER.CharacterAdded:Wait()
end

PANEL.getCharacterAddedEvent = function()
    return LOCAL_PLAYER.CharacterAdded
end

PANEL.getGui = function()
    return PLAYER_GUI
end

PANEL.getCamera = function()
    if CAMERA then
        return CAMERA
    else
        return nil
    end
end

return PANEL