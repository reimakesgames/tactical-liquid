----DEBUGGER----
local ERROR_CODES = {
    --Warns
    [100] = "Provided Viewmodel is nil, did you forget to set it as a parameter?",
    [101] = "Provided Viewmodel isn't a Model, did you forget to set it as a model?",
    [102] = "Cannot find AnimationFolder, did you forget to parent it to the viewmodel?",
    [103] = "AnimationFolder is not a Configuration Container, set it to a Configuration Container",
    [104] = "Cannot find AnimationController, did you forget to add one?",
    [105] = "Cannot find Animator in AnimationController, did you forget to add one?",
    
    --Errors
    [401] = "Viewmodel dissapeared during [ 500/POSTCHARACTER-VIEWMODEL ]",
}

----CONFIGURATION----


----====----====----====----====----====----====----====----====----====----====


----SERVICES----
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

----DIRECTORIES----
-- local LOCAL_PLAYER = game:GetService("Players").LocalPlayer
-- local PLAYER_GUI = LOCAL_PLAYER:WaitForChild("PlayerGui")
-- local PLAYER_SCRIPTS = LOCAL_PLAYER:WaitForChild("PlayerScripts")
local TacticalLiquid = ReplicatedStorage:WaitForChild("TacticalLiquid")
local Modules = TacticalLiquid:WaitForChild("Modules")

----INTERNAL CLASSES----

----EXTERNAL CLASSES----
local Classes = ReplicatedStorage.Classes
local ViewmodelSubsystem = require(Classes.ViewmodelSubsystem)

----INTERNAL MODULES----
-- local inputPanel = require(PLAYER_SCRIPTS.TacticalLiquidClient.InputPanel)

----EXTERNAL MODULES----
local Util = require(ReplicatedStorage.Libraries.Utility)

local animatorPanel = require(Modules.AnimatorPanel)

----LIBRARIES----
local spring = require(TacticalLiquid.Modules.Spring)


----====----====----====----====----====----====----====----====----====----====


----VARIABLES----
local camera = workspace.CurrentCamera
-- local character = LOCAL_PLAYER.Character
-- LOCAL_PLAYER.CharacterAdded:Connect(function(newCharacter)
--     character = newCharacter
-- end)

local viewmodelFolder = camera:FindFirstChild("Viewmodel") or Util.quickInstance("Folder", {Name = "Viewmodel", Parent = camera})
local activeViewmodel = viewmodelFolder:FindFirstChild("Active") or Util.quickInstance("Model", {Name = "Active", Parent = viewmodelFolder})
local inactiveViewmodels = viewmodelFolder:FindFirstChild("Inactive") or Util.quickInstance("Folder", {Name = "Inactive", Parent = viewmodelFolder})

local ViewmodelSway = spring.new(5, 50, 4, 4)

local active = nil
local viewmodel = nil

----FUNCTIONS----
local function ErrorWrapper(code)
    Util.safeError("["..code.."]: "..ERROR_CODES[code])
end

function SetViewmodel(_ViewmodelSubsystem: ViewmodelSubsystem.ViewmodelSubsystem): nil
    ClearActiveViewmodel()
    _ViewmodelSubsystem.Viewmodel.Parent = activeViewmodel
    viewmodel = _ViewmodelSubsystem.Viewmodel
    active = _ViewmodelSubsystem
    return nil
end

function GetViewmodel(): Model
    return viewmodel
end

function ClearActiveViewmodel(): nil
    for _, _Viewmodel in pairs(activeViewmodel:GetChildren()) do
        _Viewmodel:SetPrimaryPartCFrame(CFrame.new(0, -64, 0))
        _Viewmodel.Parent = inactiveViewmodels
    end
    viewmodel = nil
    active = nil
    return nil
end

function CreateViewmodel(Model: Model, Name: string): ViewmodelSubsystem.ViewmodelSubsystem | nil
    if not Model == nil then
        ErrorWrapper(100)
        return
    end
    if not Util.assertType(Model, "Model") then
        ErrorWrapper(101)
        return
    end
    if not Model:FindFirstChild("Animations") then
        ErrorWrapper(102)
        return
    end
    if not Model:FindFirstChild("Animations"):IsA("Configuration") then
        ErrorWrapper(103)
        return
    end
    if not Model:FindFirstChild("AnimationController") then
        ErrorWrapper(104)
        return
    end
    if not Model:FindFirstChild("AnimationController"):FindFirstChild("Animator") then
        ErrorWrapper(105)
        return
    end

    local _Viewmodel = Model:Clone()
    _Viewmodel.Parent = inactiveViewmodels
    if Name then
        _Viewmodel.Name = Name
    end
    local _ViewmodelAnimator: animatorPanel.AnimatorPanel = animatorPanel.New(_Viewmodel.AnimationController, _Viewmodel.Animations)

    local ViewmodelSubsystem: ViewmodelSubsystem.ViewmodelSubsystem = {
        Viewmodel = _Viewmodel,
        Animator = _ViewmodelAnimator,
    }

    viewmodel = ViewmodelSubsystem.Viewmodel
    active = ViewmodelSubsystem

    print(ViewmodelSubsystem)

    return ViewmodelSubsystem
end

function FinalizeCalculation(deltaTime): nil
    local MouseDelta = UserInputService:GetMouseDelta()

    ViewmodelSway
        :Shove(Vector3.new(-MouseDelta.Y, -MouseDelta.X, 0) * 0.05)
        :Update(deltaTime)

    return nil
end

function SetFromCalculation(): ViewmodelSubsystem.ViewmodelSubsystem | nil
    if active == nil then return nil end
    local _Viewmodel = active.Viewmodel or nil

    local _ViewmodelCFrame = camera.CFrame

    _ViewmodelCFrame = _ViewmodelCFrame * CFrame.Angles(math.rad(ViewmodelSway.Position.X), math.rad(ViewmodelSway.Position.Y), 0)

    _Viewmodel:SetPrimaryPartCFrame(_ViewmodelCFrame)

    return active
end

----CONNECTED FUNCTIONS----


----====----====----====----====----====----====----====----====----====----====


----PUBLIC----
local Panel = {
    ViewmodelFolder = viewmodelFolder,
    ActiveViewmodel = activeViewmodel,
    InactiveViewmodels = inactiveViewmodels,
}

Panel.SetViewmodel = SetViewmodel
Panel.GetViewmodel = GetViewmodel
Panel.ClearActiveViewmodel = ClearActiveViewmodel
Panel.CreateViewmodel = CreateViewmodel
Panel.FinalizeCalculation = FinalizeCalculation
Panel.SetFromCalculation = SetFromCalculation

RunService:BindToRenderStep("STARBLAST_INTERNAL: 450/POSTCHARACTER-VIEWMODEL_CALCULATION", 450, FinalizeCalculation)
RunService:BindToRenderStep("STARBLAST_INTERNAL: 500/POSTCHARACTER-VIEWMODEL", 500, SetFromCalculation)

return Panel
