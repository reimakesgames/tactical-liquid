local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")

local UserDataPanel = require(ReplicatedStorage.Libraries.UserDataPanel)
local UserData = UserDataPanel.GetPrivateUserData(LocalPlayer)
local FilesPanel = require(PlayerScripts.TacticalLiquidClient.FilesPanel)
local PlayerPanel = require(PlayerScripts.TacticalLiquidClient.PlayerPanel)

local FastCast = require(ReplicatedStorage.Libraries.FastCastRedux)

