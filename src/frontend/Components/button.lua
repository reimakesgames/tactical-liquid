local ReplicatedStorage = game:GetService("ReplicatedStorage")

local roact = require(ReplicatedStorage.Libraries.roact)
local roactspring = require(ReplicatedStorage.Libraries["roact-spring"])

local Button = roact.Component:extend("Button")

function Button:render() 
    return roact.createElement("TextButton", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 2,
        Text = "Button",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 14,
        [roact.Event.Activated] = function()
            print("Button activated")
        end
    })
end

return Button