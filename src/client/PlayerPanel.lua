local LOCAL_PLAYER = game:GetService("Players").LocalPlayer
local PLAYER_GUI = LOCAL_PLAYER:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- long algorithm to get the character
local Character = LOCAL_PLAYER.Character
LOCAL_PLAYER.CharacterAdded:Connect(function(character)
    Character = character
end)

--create a function to get the camera, if it's not set then return nil
local function getCamera()
    if Camera then
        return Camera
    else
        return nil
    end
end

local PANEL = {}

PANEL.getCharacter = function()
    return Character
end

PANEL.getGui = function()
    return PLAYER_GUI
end

PANEL.getCamera = getCamera

return PANEL