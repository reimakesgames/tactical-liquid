--create a toolbar
local SpectraGuiSuite = plugin:CreateToolbar("SpectraGuiSuite")

--create a toolbar button that opens the LCSS editor
local LCSSEditor = SpectraGuiSuite:CreateButton("LCSS Editor", "Opens the LCSS Editor", "rbxassetid://7271246894")
local LCSSModule = require(script.LCSS)

local LCSSEditorWidget = plugin:CreateDockWidgetPluginGui("LCSSEditor", LCSSModule.WidgetInfo)
LCSSEditorWidget.Title = "[SpectraX v0.1] SpectraX - LCSS Editor - Untitled"

local ColorDark = {
    BackgroundColor3 = Color3.fromRGB(33, 37, 43),
    BorderSizePixel = 0,
}

local ColorMed = {
    BackgroundColor3 = Color3.fromRGB(40, 44, 52),
    BorderSizePixel = 0,
}

local ColorLight = {
    BackgroundColor3 = Color3.fromRGB(51, 56, 66),
    BorderSizePixel = 0,
}

--create a function that applies styles to a gui element
local function ApplyStyle(GuiElement, Style)
    for i, v in pairs(Style) do
        GuiElement[i] = v
    end
end

local function SetFrameSizeWithTextBounds(Text)
    Text.Size = UDim2.new(0, Text.TextBounds.X + 16, 1, 0)
end

local function ButtonFinisher(Instance)
    Instance.TextScaled = false
    Instance.TextSize = 16
    Instance.TextColor3 = Color3.fromRGB(157, 165, 180)
    Instance.Font = Enum.Font.SourceSans
    Instance.Size = UDim2.new(0, 250, 1, 0)
    SetFrameSizeWithTextBounds(Instance)
end

--create a background frame
local BackgroundFrame = Instance.new("Frame")
ApplyStyle(BackgroundFrame, ColorMed)
BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
BackgroundFrame.Parent = LCSSEditorWidget

local EditorAreaFrame = Instance.new("Frame")
ApplyStyle(EditorAreaFrame, ColorMed)
EditorAreaFrame.Size = UDim2.new(1, -298, 1, -54)
EditorAreaFrame.Position = UDim2.new(0, 298, 0, 30)
EditorAreaFrame.Parent = BackgroundFrame
local EditorAreaImage = Instance.new("ImageLabel")
EditorAreaImage.BackgroundTransparency = 1
EditorAreaImage.Size = UDim2.new(0, 256, 0, 256)
EditorAreaImage.Position = UDim2.new(0.5, 0, 0.5, 0)
EditorAreaImage.AnchorPoint = Vector2.new(0.5, 0.5)
EditorAreaImage.Image = "rbxassetid://7414445494"
EditorAreaImage.ImageColor3 = ColorDark.BackgroundColor3
EditorAreaImage.Parent = EditorAreaFrame


--create a topbar in the widget
local TopbarFrame = Instance.new("Frame")
ApplyStyle(TopbarFrame, ColorDark)
TopbarFrame.Name = "Topbar"
TopbarFrame.Size = UDim2.new(1, 0, 0, 30)
TopbarFrame.Parent = LCSSEditorWidget

local IconFrame = Instance.new("Frame")
ApplyStyle(IconFrame, ColorDark)
IconFrame.Name = "Icon"
IconFrame.Size = UDim2.new(0, 35, 0, 30)
IconFrame.Parent = TopbarFrame
local IconImage = Instance.new("ImageLabel")
IconImage.Name = "IconImage"
IconImage.Size = UDim2.fromOffset(16, 16)
IconImage.AnchorPoint = Vector2.new(0.5, 0.5)
IconImage.Position = UDim2.fromScale(0.5, 0.5)
IconImage.BackgroundTransparency = 1
IconImage.Image = "rbxassetid://7271246894"
IconImage.Parent = IconFrame

local FileButton = Instance.new("TextButton")
ApplyStyle(FileButton, ColorDark)
FileButton.Name = "FileButton"
FileButton.Text = "File"
FileButton.Parent = TopbarFrame
ButtonFinisher(FileButton)
FileButton.Position = UDim2.new(0, IconFrame.Position.X.Offset + IconFrame.Size.X.Offset, 0, 0)

local EditButton = Instance.new("TextButton")
ApplyStyle(EditButton, ColorDark)
EditButton.Name = "EditButton"
EditButton.Text = "Edit"
EditButton.Parent = TopbarFrame
ButtonFinisher(EditButton)
EditButton.Position = UDim2.new(0, FileButton.Position.X.Offset + FileButton.Size.X.Offset, 0, 0)

local SelectionButton = Instance.new("TextButton")
ApplyStyle(SelectionButton, ColorDark)
SelectionButton.Name = "SelectionButton"
SelectionButton.Text = "Selection"
SelectionButton.Parent = TopbarFrame
ButtonFinisher(SelectionButton)
SelectionButton.Position = UDim2.new(0, EditButton.Position.X.Offset + EditButton.Size.X.Offset, 0, 0)

local SideBarFrame = Instance.new("Frame")
ApplyStyle(SideBarFrame, ColorLight)
SideBarFrame.Name = "SideBar"
SideBarFrame.Size = UDim2.new(0, 48, 1, -54)
SideBarFrame.Position = UDim2.new(0, 0, 0, 30)
SideBarFrame.Parent = LCSSEditorWidget

local SideBarViewFrame = Instance.new("Frame")
ApplyStyle(SideBarViewFrame, ColorDark)
SideBarViewFrame.Name = "SideBarView"
SideBarViewFrame.Size = UDim2.new(0, 256, 1, -54)
SideBarViewFrame.Position = UDim2.new(0, 48, 0, 30)
SideBarViewFrame.Parent = LCSSEditorWidget

local CurrentMenuOpenFrame = Instance.new("Frame")
ApplyStyle(CurrentMenuOpenFrame, ColorDark)
CurrentMenuOpenFrame.Name = "CurrentMenuOpen"
CurrentMenuOpenFrame.Size = UDim2.new(0, 256, 0, 35)
CurrentMenuOpenFrame.Position = UDim2.new(0, 0, 0, 0)
CurrentMenuOpenFrame.Parent = SideBarViewFrame
local CurrentMenuOpenLabel = Instance.new("TextLabel")
CurrentMenuOpenLabel.Name = "CurrentMenuOpenLabel"
CurrentMenuOpenLabel.Text = "EXPLORER"
CurrentMenuOpenLabel.BackgroundTransparency = 1
CurrentMenuOpenLabel.Size = UDim2.new(0.5, 0, 1, 0)
CurrentMenuOpenLabel.Position = UDim2.new(0, 20, 0, 0)
CurrentMenuOpenLabel.TextSize = 14
CurrentMenuOpenLabel.TextXAlignment = Enum.TextXAlignment.Left
CurrentMenuOpenLabel.Font = Enum.Font.SourceSans
CurrentMenuOpenLabel.TextColor3 = Color3.fromRGB(204, 204, 204)
CurrentMenuOpenLabel.Parent = CurrentMenuOpenFrame

local OpenEditorsButton = Instance.new("TextButton")
ApplyStyle(OpenEditorsButton, ColorLight)
OpenEditorsButton.Name = "OpenEditorsButton"
OpenEditorsButton.Size = UDim2.new(0, 256, 0, 24)
OpenEditorsButton.Position = UDim2.new(0, 0, 0, 35)
OpenEditorsButton.Text = "OPEN EDITORS"
OpenEditorsButton.TextScaled = false
OpenEditorsButton.TextSize = 14
OpenEditorsButton.Font = Enum.Font.SourceSans
OpenEditorsButton.TextColor3 = Color3.fromRGB(204, 204, 204)
OpenEditorsButton.Parent = SideBarViewFrame


local SideBarViewScroll = Instance.new("ScrollingFrame")
ApplyStyle(SideBarViewScroll, ColorDark)
SideBarViewScroll.Name = "SideBarView"
SideBarViewScroll.Size = UDim2.new(0, 256, 1, -59)
SideBarViewScroll.Position = UDim2.new(0, 0, 0, 59)
SideBarViewScroll.TopImage = "rbxassetid://2807298556"
SideBarViewScroll.MidImage = "rbxassetid://2807298556"
SideBarViewScroll.BottomImage = "rbxassetid://2807298556"
SideBarViewScroll.ScrollBarImageTransparency = 0.5
SideBarViewScroll.ScrollBarThickness = 10
SideBarViewScroll.Parent = SideBarViewFrame

local StatusBarFrame = Instance.new("Frame")
ApplyStyle(StatusBarFrame, ColorDark)
StatusBarFrame.Name = "StatusBar"
StatusBarFrame.Size = UDim2.new(1, 0, 0, 24)
StatusBarFrame.Position = UDim2.new(0, 0, 1, -24)
StatusBarFrame.Parent = LCSSEditorWidget