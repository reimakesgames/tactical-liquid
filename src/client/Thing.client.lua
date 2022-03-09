local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer

local SpectraGui = require(ReplicatedStorage.TacticalLiquid.SpectraGui)
local Frontend = ReplicatedStorage.SpectraGui

local size = SpectraGui.createData()
size.AnchorPoint = Vector2.new(0.5, 0.5)
size.Position = UDim2.new(0, 200, 0, 200)
size.Size = UDim2.new(0, 250, 0, 50)

local inst = SpectraGui.create(size, Frontend.style["button.style"], Frontend.react["button.react"])