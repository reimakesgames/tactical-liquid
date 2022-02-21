local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- long algorithm to get the character
local Character = LocalPlayer.Character
LocalPlayer.CharacterAdded:Connect(function(character)
    Character = character
end)

local Panel = {}

Panel.GetCharacter = function()
    return Character, LocalPlayer.CharacterAdded
end

Panel.GetGui = function()
    return PlayerGui
end

Panel.GetCamera = function()
    return Camera
end

return Panel