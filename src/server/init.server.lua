local ServerScriptService = game:GetService("ServerScriptService")

local PlayerService = require(ServerScriptService.TacticalLiquidServer.PlayerService)
local DatabaseService = require(ServerScriptService.TacticalLiquidServer.DatabaseService)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

PlayerService.GetPlayerJoinedEvent():Connect(function(player)
    -- local InternalSettings = DatabaseService.GetInitializeSettings(player)
end)

