local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Libraries = ReplicatedStorage:WaitForChild("Libraries")

local DataStore2 = require(Libraries:WaitForChild("DataStore2"))

DataStore2.Combine("Internal", "InternalSettings")

local DatabaseService = {}

--get settings from database with DataStore2
function DatabaseService.GetInitializeSettings(Player)
    local settings = DataStore2("InternalSettings", Player)
    return settings:Get(
        {
            ["Crosshair"] = "Default"
        }
    )
end

return DatabaseService