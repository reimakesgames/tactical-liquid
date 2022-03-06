local Style = {type = "TextLabel"}

--the button styles
Style.default = {
    backgroundColor = Color3.fromRGB(25, 25, 25),

    height = 100,
    width = 200,

    borderSize = 1,
    borderColor = Color3.fromRGB(0, 0, 0),

    textFont = Enum.Font.GothamBlack,
    textSize = 20,
    textColor = Color3.fromRGB(220, 220, 220),

}

Style.hover = {
    backgroundColor = Color3.fromRGB(50, 50, 50),

    borderSize = 2,
    borderColor = Color3.fromRGB(255, 255, 255),
}


return Style