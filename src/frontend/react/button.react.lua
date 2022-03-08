local React = {}

React.onClick = function(object, callback)
    object.InputBegan:Connect(function(InputObject)
        if InputObject.UserInputType == Enum.UserInputType.MouseButton1 then
            callback(object.Position.X - InputObject.Position.X, object.Position.Y - InputObject.Position.Y)
        end
    end)
end

return React