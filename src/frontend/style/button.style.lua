local Style = {
    className = "TextLabel";
    type = "Clickable";
}

--the button styles
Style.default = {
    BackgroundColor3 = Color3.fromRGB(25, 25, 25),

    BorderSizePixel = 1,
    BorderColor3 = Color3.fromRGB(100, 100, 100),

    Font = Enum.Font.GothamBlack,
    TextSize = 20,
    TextColor3 = Color3.fromRGB(220, 220, 220),
}

Style.hover = {
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),

    _Size = UDim2.new(0, 10, 0, 10),

    BorderSizePixel = 2,
    BorderColor3 = Color3.fromRGB(255, 255, 255),

    Font = Enum.Font.GothamBlack,
    TextSize = 22,
    TextColor3 = Color3.fromRGB(255, 255, 255),
}


return Style