----DEBUGGER----
----CONFIGURATION----

----====----====----====----====----====----====----====----====----====----====

----SERVICES----
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local RUN_SERVICE = game:GetService("RunService")

----DIRECTORIES----
local LocalPlayer = game:GetService("Players").LocalPlayer
-- local PLAYER_GUI = LOCAL_PLAYER:WaitForChild("PlayerGui")
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local TacticalLiquid = ReplicatedStorage:WaitForChild("TacticalLiquid")

----INTERNAL CLASSES----
----EXTERNAL CLASSES----

----INTERNAL MODULES----
local WeaponsModule = require(script.WeaponsPanel)
local ViewmodelModule = require(script.ViewmodelPanel)

----EXTERNAL MODULES----
local InputModule = require(PlayerScripts.TacticalLiquidClient.InputPanel)

----LIBRARIES----
local Util = require(ReplicatedStorage.Libraries.Utility)

----====----====----====----====----====----====----====----====----====----====

----VARIABLES----
local Character = LocalPlayer.Character
LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
	Character = NewCharacter
end)
local Camera = workspace.CurrentCamera

local Equipped = false
local Viewmodels = {}
local IsLMBDown = false
local CurrentlyFiring = false
-- local Reloading = false

----FUNCTIONS----
local function BodgeFire()
	local endPosition = Camera.CFrame.Position
	if Equipped then
		endPosition = Viewmodels["crappy viewmodel 2"].Viewmodel.Handle.GunFirePoint.WorldPosition
	end
	WeaponsModule.Fire(endPosition, Camera.CFrame.LookVector, 512)
	Util.clonePlay(workspace:FindFirstChild("FireSound"), workspace)
end

local function OnFire(KeyDown)
	if not Character then
		IsLMBDown = false
		return
	end

	IsLMBDown = KeyDown
	if CurrentlyFiring then return end
	if IsLMBDown then
		repeat
			CurrentlyFiring = true
			BodgeFire()
			task.wait(0.1)
			CurrentlyFiring = false
		until not IsLMBDown
	end
end

local function OnEquip(_)
	if not Character then
		return
	end

	if Equipped then
		Equipped = false
		ViewmodelModule.ClearActiveViewmodel()
		return
	end
	Equipped = true
	if not Viewmodels["crappy viewmodel 2"] then
		local something = ViewmodelModule.CreateViewmodel(
			TacticalLiquid:FindFirstChild("crappy viewmodel 2"),
			"crappy viewmodel 2"
		)
		Viewmodels["crappy viewmodel 2"] = something
		print(something)
		print(Viewmodels["crappy viewmodel 2"])
	end
	ViewmodelModule.SetViewmodel(Viewmodels["crappy viewmodel 2"])
end

----CONNECTED FUNCTIONS----
InputModule.MakeBindForKeyInput(Enum.UserInputType.MouseButton1, true, OnFire)
InputModule.MakeBindForKeyDown(Enum.KeyCode.One, true, OnEquip)