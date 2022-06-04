----DEBUGGER----

----CONFIGURATION----
local Configurations = game:GetService("ReplicatedFirst").Configuration
local GraphicsConfiguration = require(Configurations["graphics.cfg"])

----====----====----====----====----====----====----====----====----====----====

----SERVICES----
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local RUN_SERVICE = game:GetService("RunService")

----DIRECTORIES----
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
-- local PLAYER_GUI = LOCAL_PLAYER:WaitForChild("PlayerGui")
-- local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local TacticalLiquid = ReplicatedStorage:WaitForChild("TacticalLiquid")

----INTERNAL CLASSES----
----EXTERNAL CLASSES----

----INTERNAL MODULES----
local WeaponsModule = require(script.WeaponsPanel)
local ViewmodelModule = require(script.ViewmodelRemake)
local Effects = require(script.Effects)

----EXTERNAL MODULES----
local Modules = TacticalLiquid.Modules
local InputModule = require(Modules.InputPanel)

----LIBRARIES----
local FastCast = require(ReplicatedStorage.Libraries.FastCastRedux)

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

local CurrentCaster = FastCast.new()
local CurrentBehavior = FastCast.newBehavior()
CurrentBehavior.RaycastParams = nil
CurrentBehavior.Acceleration = Vector3.new()
CurrentBehavior.MaxDistance = GraphicsConfiguration.bullet_render_distance
CurrentBehavior.CanPierceFunction = function(cast, result, segmentVelocity)
    if result.Instance.Transparency == 1 or result.Instance:IsDescendantOf(Camera) or result.Instance:IsDescendantOf(Character) then
        return true
    end
    return false
end
CurrentBehavior.HighFidelityBehavior = FastCast.HighFidelityBehavior.Default
CurrentBehavior.HighFidelitySegmentSize = 0.5
CurrentBehavior.CosmeticBulletTemplate = nil
CurrentBehavior.CosmeticBulletProvider = nil
CurrentBehavior.CosmeticBulletContainer = nil
CurrentBehavior.AutoIgnoreContainer = true

----FUNCTIONS----
local function OnFire(KeyDown)
	if not Character then
		IsLMBDown = false
		for _, _Viewmodel in pairs(Viewmodels) do
			_Viewmodel:Cull(true)
		end
		return
	end

	if not Equipped then
		return
	end

	IsLMBDown = KeyDown
	if CurrentlyFiring then return end
	if IsLMBDown then
		repeat
			CurrentlyFiring = true
			local EndPoint = Viewmodels["ViewmodelTest"].Handle.GunFirePoint.WorldPosition
			local Direction = Camera.CFrame.LookVector
			local Velocity = 512
			WeaponsModule.Fire(EndPoint, Direction, Velocity)
			Effects.MakeTracers(EndPoint, Direction, Velocity)
			Util.clonePlay(workspace:FindFirstChild("FireSound"), workspace)
			task.wait(0.1)
			CurrentlyFiring = false
		until not IsLMBDown
	end
end

local function OnEquip(_)
	if not Character then
		Equipped = false
		ViewmodelModule:Cull(true)
		return
	end

	if Equipped then
		Equipped = false
		ViewmodelModule:Cull(true)
		return
	end
	Equipped = true
	if not Viewmodels["ViewmodelTest"] then
		local VM = ViewmodelModule.new(ReplicatedStorage.TacticalLiquid.ViewmodelTest)
		Viewmodels["ViewmodelTest"] = VM
		VM:Cull(false)
		print(VM)
		print(Viewmodels["ViewmodelTest"])
	end
	ViewmodelModule.SetViewmodel(Viewmodels["ViewmodelTest"])
end

local function SurfaceHit(Caster, RaycastResult, SegmentVelocity, Cosmetic)
    print(RaycastResult.Instance)
    Effects.MakeHitPart(0, RaycastResult)
end

----CONNECTED FUNCTIONS----
WeaponsModule.SetObjects(CurrentCaster, CurrentBehavior)
CurrentCaster.RayHit:Connect(SurfaceHit)
InputModule.MakeBindForKeyInput(Enum.UserInputType.MouseButton1, true, OnFire)
InputModule.MakeBindForKeyDown(Enum.KeyCode.One, true, OnEquip)

RunService:BindToRenderStep("UpdateViewmodel", 500, function(deltaTime)
	ViewmodelModule:Update(deltaTime)
end)