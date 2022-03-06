local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer

local SpectraGui = require(ReplicatedStorage.TacticalLiquid.SpectraGui)
local Frontend = ReplicatedStorage.SpectraGui

local inst = SpectraGui.create(Frontend.style["button.style"])
inst.Parent = LocalPlayer.PlayerGui