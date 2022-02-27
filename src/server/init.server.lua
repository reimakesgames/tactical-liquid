local ServerScriptService = game:GetService("ServerScriptService")

local PlayerService = require(ServerScriptService.TacticalLiquidServer.PlayerService)
local DatabaseService = require(ServerScriptService.TacticalLiquidServer.DatabaseService)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Pipes = ReplicatedStorage.Internal.Pipes

PlayerService.GetPlayerJoinedEvent():Connect(function(player)
    -- local InternalSettings = DatabaseService.GetInitializeSettings(player)
end)

Pipes.Functions.Invoke_IntConfg.OnServerInvoke = function(player)
    local InternalSettings = DatabaseService.GetInitializeSettings(player)
    return InternalSettings
end