local React = {
    Held = false;
    RelativeMouseDisplacement = Vector2.new(0, 0);
    object = nil;
}

local UserInputService = game:GetService("UserInputService")

React.onClick = function(object, callback)
    object.InputBegan:Connect(function(InputObject)
        if InputObject.UserInputType == Enum.UserInputType.MouseButton1 then
            callback()
        end
    end)
end

React.endClick = function(object, callback)
    object.InputEnded:Connect(function(InputObject)
        if InputObject.UserInputType == Enum.UserInputType.MouseButton1 then
            callback()
        end
    end)
end

return React