local Players = game:GetService("Players")

local PlayerService = {}

--return an event that fires when a new player joins the game
function PlayerService.GetPlayerJoinedEvent()
    return Players.PlayerAdded
end

return PlayerService