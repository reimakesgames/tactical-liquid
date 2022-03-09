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
    TextColor3 = Color3.fromRGB(200, 200, 200),
}

Style.hover = {
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),

    _Size = UDim2.new(0, 8, 0, 8),

    BorderSizePixel = 2,
    BorderColor3 = Color3.fromRGB(255, 255, 255),

    Font = Enum.Font.GothamBlack,
    TextSize = 22,
    TextColor3 = Color3.fromRGB(255, 255, 255),
}

Style.clicked = {
    BackgroundColor3 = Color3.fromRGB(20, 20, 20),

    _Size = UDim2.new(0, -4, 0, -4),

    BorderSizePixel = 1,
    BorderColor3 = Color3.fromRGB(80, 80, 80),

    Font = Enum.Font.GothamBlack,
    TextSize = 22,
    TextColor3 = Color3.fromRGB(160, 160, 160),
}


return Style