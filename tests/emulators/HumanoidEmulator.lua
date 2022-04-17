local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayerScripts = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local SignalPanel = require(StarterPlayerScripts.TacticalLiquidClient.SignalPanel)

local Humanoid = {}

-- construct a new Humanoid Class
function Humanoid.new()
    local _Humanoid = {
        Died = SignalPanel.new();
    }

    return _Humanoid
end


return Humanoid