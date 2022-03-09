local React = {
    Held = false;
    RelativeMouseDisplacement = Vector2.new(0, 0);
    object = nil;
}

local UserInputService = game:GetService("UserInputService")

local function CalculateSpring(deltaTime, current: Vector2, target: Vector2)
    local spring = Vector2.new(0, 0)
    spring = target - current
    spring = spring * (deltaTime * 5)
    -- spring = spring * 0.5
    return spring
end

React.onClick = function(object, callback)
    object.InputBegan:Connect(function(InputObject)
        if InputObject.UserInputType == Enum.UserInputType.MouseButton1 then
            React.object = object
            --get the offset from the center of the frame where the mouse was pressed
            local ObjPos = object.AbsolutePosition + Vector2.new(object.AbsoluteSize.X / 2, object.AbsoluteSize.Y / 2)
            local Pos = Vector2.new(InputObject.Position.X, InputObject.Position.Y)
            React.RelativeMouseDisplacement = ObjPos - Pos
            React.Held = true

            callback(InputObject.Position.X - object.AbsolutePosition.X, InputObject.Position.Y - object.AbsolutePosition.Y)
        end
    end)
end

React.endClick = function(object, callback)
    object.InputEnded:Connect(function(InputObject)
        if InputObject.UserInputType == Enum.UserInputType.MouseButton1 then
            React.Held = false

            callback(InputObject.Position.X - object.AbsolutePosition.X, InputObject.Position.Y - object.AbsolutePosition.Y)
        end
    end)
end

game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
    if React.Held then
        --check if the mouse was moved to a new position, if so, then move the frame there
        local mousePosition = UserInputService:GetMouseLocation()
        local newPosition = React.RelativeMouseDisplacement + mousePosition
        local spring = CalculateSpring(deltaTime, (React.object.AbsolutePosition + Vector2.new(0, 36)) + (React.object.AbsoluteSize / 2), newPosition)
        React.object.Position = React.object.Position + UDim2.fromOffset(spring.X, spring.Y)
    end
end)


return React