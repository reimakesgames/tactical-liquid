local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Libraries = ReplicatedStorage:WaitForChild("Libraries")

local DataStore2 = require(Libraries:WaitForChild("DataStore2"))

DataStore2.Combine("Internal", "InternalSettings")

local DatabaseService = {}

--get settings from database with DataStore2
function DatabaseService.GetInitializeSettings(Player)
    local settings = DataStore2("InternalSettings", Player)
    local data = settings:GetTable({
        ["crosshair"] = "default"
    })
    return data
end

function DatabaseService.UpdateSettings(Player, Key, Value)
    local settings = DataStore2("InternalSettings", Player)
    local data = settings:Get()

    data[Key] = Value
    
    settings:Set(data)
end

return DatabaseService