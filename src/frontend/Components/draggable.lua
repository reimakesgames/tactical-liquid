local ReplicatedStorage = game:GetService("ReplicatedStorage")

local roact = require(ReplicatedStorage.Libraries.roact)

-- local roactspring = require(ReplicatedStorage.Libraries["roact-spring"])

local Button = roact.Component:extend("Button")

function Button:init()
    self.held = false
    self.inputstartPos = nil
end

function Button:render() 
    return roact.createElement("TextButton", {
        Size = UDim2.fromOffset(100, 50),
        Position = self.props.Position,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 2,
        Text = "Button",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 14,

        [roact.Event.InputBegan] = function(frame, input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if self.held then return end
                self.held = true
                self.inputstartPos = input.Position
            end
        end,

        [roact.Event.InputEnded] = function(frame, input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                self.held = false
            end
        end,

        [roact.Event.MouseMoved] = function(frame, x, y)
            if self.held then
                frame.Position = UDim2.fromOffset(x - self.inputstartPos.X, y - self.inputstartPos.Y)
            end
        end
    })
end

return Button