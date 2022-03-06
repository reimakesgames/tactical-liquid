local SpectraGui = {}

--create an element using a style file
SpectraGui.create = function(styleFile)
    local style = require(styleFile)
    local defaultStyle = style.default
    local hoverStyle = style.hover

    local object: TextLabel = Instance.new(style.type)
    object.Size = UDim2.new(0, defaultStyle.width, 0, defaultStyle.height)
    object.BackgroundColor3 = defaultStyle.backgroundColor
    object.BorderSizePixel = defaultStyle.borderSize

    if style.type == "TextLabel" then
        object.TextColor3 = defaultStyle.textColor
        object.Font = defaultStyle.textFont
        object.TextSize = defaultStyle.textSize
    end

    object.MouseEnter:Connect(function(x, y)
        object.BackgroundColor3 = hoverStyle.backgroundColor
        object.BorderSizePixel = hoverStyle.borderSize
        object.BorderColor3 = hoverStyle.borderColor
    end)

    object.MouseLeave:Connect(function(x, y)
        object.BackgroundColor3 = defaultStyle.backgroundColor
        object.BorderSizePixel = defaultStyle.borderSize
        object.BorderColor3 = defaultStyle.borderColor
    end)

    return object
end

return SpectraGui