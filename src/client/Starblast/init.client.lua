local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local FilesPanel = require(PlayerScripts.FilesPanel)
local PlayerPanel = require(PlayerScripts.PlayerPanel)

local FastCast = require(ReplicatedStorage.Libraries.FastCastRedux)

