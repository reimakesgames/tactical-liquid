local SpectraGui = {}

local Types = require(script.Types)
local Utility = require(script.Utility)

local function setObjectProperties(object, styleFile)
    for propertyName, propertyValue in pairs(styleFile) do
        if propertyName:sub(1, 1) == "_" then
            print("skipping value because it starts with an underscore: " .. propertyName)
            continue
        end
        object[propertyName] = propertyValue
    end
end

-- local function setPositionAndSize(object, data: Types.defaultPositionAndSize)
--     object.Position = data.Position
--     object.Size = data.Size
--     object.AnchorPoint = data.AnchorPoint
-- end

--check the styleFile if it has text properties, and return true if it does
local function hasTextProperties(styleFile): boolean
    for propertyName, propertyValue in pairs(styleFile) do
        if propertyName:sub(1, 4) == "Text" then
            return true
        end
    end

    return false
end

local function checkIfClickable(styleFile): boolean
    return styleFile.onClick ~= nil
end


--when required, create a new instance of ScreenGui and parent it to the client's PlayerGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
ScreenGui.IgnoreGuiInset = true

SpectraGui.createData = function()
    local tab: Types.defaultPositionAndSize = {
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 100, 0, 100),
        AnchorPoint = Vector2.new(0, 0)

    }

    return tab
end

--create an element using a style file
SpectraGui.create = function(data: Types.defaultPositionAndSize, styleFile, reactFile)
    local style = require(styleFile)
    local react = require(reactFile)

    local hasDefaultState = style.default ~= nil
    local hasHoverState = style.hover ~= nil
    local hasSelectedState = style.selected ~= nil
    local hasDisabledState = style.disabled ~= nil


    local object

    local isText = hasTextProperties(style.default)
    print(isText)

    local isClickable = checkIfClickable(react)

    if isText then
        object = Instance.new("TextLabel")
    else
        object = Instance.new("Frame")
    end

    setObjectProperties(object, data)
    setObjectProperties(object, style.default)

    -- object.BackgroundColor3 = style.default.BackgroundColor3
    -- object.BorderSizePixel = style.default.BorderSizePixel

    -- if isText then
    --     object.TextColor3 = style.default.TextColor3
    --     object.Font = style.default.Font
    --     object.TextSize = style.default.TextSize
    -- end

    react.onClick(object, function()
        setObjectProperties(object, style.clicked)

        object.Size = data.Size + style.clicked._Size
    end)

    react.endClick(object, function()
        setObjectProperties(object, data)
        setObjectProperties(object, style.default)
    end)

    -- if isClickable then
    --     object.MouseEnter:Connect(function(x, y)
    --         -- object.BackgroundColor3 = style.hover.BackgroundColor3
    --         -- object.BorderSizePixel = style.hover.BorderSizePixel
    --         -- object.BorderColor3 = style.hover.BorderColor3
    --         setObjectProperties(object, style.hover)
    --         if style.hover._Size then
    --             object.Size = data.Size + style.hover._Size
    --         end
    --     end)

    --     object.MouseLeave:Connect(function(x, y)
    --         setObjectProperties(object, data)
    --         setObjectProperties(object, style.default)
    --     end)
    -- end

    object.Parent = ScreenGui

    return object
end

return SpectraGui