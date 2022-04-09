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
local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")
local USER_INPUT_SERVICE = game:GetService("UserInputService")
local RUN_SERVICE = game:GetService("RunService")

----DIRECTORIES----
local LOCAL_PLAYER = game:GetService("Players").LocalPlayer
local PLAYER_GUI = LOCAL_PLAYER:WaitForChild("PlayerGui")
local PLAYER_SCRIPTS = LOCAL_PLAYER:WaitForChild("PlayerScripts")
local TACTICAL_LIQUID = REPLICATED_STORAGE:WaitForChild("TacticalLiquid")
local LIBRARIES = TACTICAL_LIQUID:WaitForChild("Libraries")

----INTERNAL CLASSES----

----EXTERNAL CLASSES----
local CLASSES = REPLICATED_STORAGE.Classes
local VIEWMODEL_SUBSYSTEM = require(CLASSES.ViewmodelSubsystem)

----INTERNAL MODULES----
local inputPanel = require(PLAYER_SCRIPTS.TacticalLiquidClient.InputPanel)

----EXTERNAL MODULES----
local UTILITY = require(REPLICATED_STORAGE.Libraries.Utility)

local animatorPanel = require(REPLICATED_STORAGE.Libraries.AnimatorPanel)

----LIBRARIES----
local spring = require(TACTICAL_LIQUID.Modules.Spring)


----====----====----====----====----====----====----====----====----====----====


----VARIABLES----
local camera = workspace.CurrentCamera
local character = LOCAL_PLAYER.Character
LOCAL_PLAYER.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
end)

local viewmodelFolder = camera:FindFirstChild("Viewmodel") or UTILITY.quickInstance(Instance.new("Folder"), {Name = "Viewmodel", Parent = camera})
local activeViewmodel = viewmodelFolder:FindFirstChild("Active") or UTILITY.quickInstance(Instance.new("Model"), {Name = "Active", Parent = viewmodelFolder})
local inactiveViewmodels = viewmodelFolder:FindFirstChild("Inactive") or UTILITY.quickInstance(Instance.new("Folder"), {Name = "Inactive", Parent = viewmodelFolder})

spring.new("VIEWMODEL_SWAY", 5, 50, 4, 4)

local active = nil
local viewmodel = nil

----FUNCTIONS----
local function ErrorWrapper(code)
    UTILITY.safeError("["..code.."]: "..ERROR_CODES[code])
end

function setViewmodel(ViewmodelSubsystem: VIEWMODEL_SUBSYSTEM.ViewmodelSubsystem): nil
    clearActiveViewmodel()
    ViewmodelSubsystem.Viewmodel.Parent = activeViewmodel
    viewmodel = ViewmodelSubsystem.Viewmodel
    active = ViewmodelSubsystem
    return nil
end

function getViewmodel(): Model
    return viewmodel
end

function clearActiveViewmodel(): nil
    for _, _Viewmodel in pairs(activeViewmodel:GetChildren()) do
        _Viewmodel:SetPrimaryPartCFrame(CFrame.new(0, -64, 0))
        _Viewmodel.Parent = inactiveViewmodels
    end
    viewmodel = nil
    active = nil
    return nil
end

function createViewmodel(Model: Model, Name: string): VIEWMODEL_SUBSYSTEM.ViewmodelSubsystem | nil
    if not Model == nil then ErrorWrapper(100) return end
    if not UTILITY.assertType(Model, "Model") then ErrorWrapper(101) return end
    if not Model:FindFirstChild("Animations") then ErrorWrapper(102) return end
    if not Model:FindFirstChild("Animations"):IsA("Configuration") then ErrorWrapper(103) return end
    if not Model:FindFirstChild("AnimationController") then ErrorWrapper(104) return end
    if not Model:FindFirstChild("AnimationController"):FindFirstChild("Animator") then ErrorWrapper(105) return end

    local _Viewmodel = Model:Clone()
    _Viewmodel.Parent = inactiveViewmodels
    if Name then _Viewmodel.Name = Name end
    local _ViewmodelAnimator = animatorPanel.New(_Viewmodel.AnimationController, _Viewmodel.Animations)

    local ViewmodelSubsystem: VIEWMODEL_SUBSYSTEM.ViewmodelSubsystem = {
        Viewmodel = _Viewmodel,
        Animator = _ViewmodelAnimator,
    }

    viewmodel = ViewmodelSubsystem.Viewmodel
    active = ViewmodelSubsystem

    print(ViewmodelSubsystem)

    return ViewmodelSubsystem
end

function finalizeCalculation(deltaTime): nil
    local MouseDelta = USER_INPUT_SERVICE:GetMouseDelta()

    spring.VIEWMODEL_SWAY
        :shove(Vector3.new(-MouseDelta.Y, -MouseDelta.X, 0) * 0.05)
        :update(deltaTime)

    return nil
end

function setFromCalculation(): VIEWMODEL_SUBSYSTEM.ViewmodelSubsystem | nil
    if active == nil then return nil end
    local _Viewmodel = active.Viewmodel or nil

    local _ViewmodelCFrame = camera.CFrame

    _ViewmodelCFrame = _ViewmodelCFrame * CFrame.Angles(math.rad(spring.VIEWMODEL_SWAY.Position.X), math.rad(spring.VIEWMODEL_SWAY.Position.Y), 0)

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

Panel.setViewmodel = setViewmodel
Panel.getViewmodel = getViewmodel
Panel.clearActiveViewmodel = clearActiveViewmodel
Panel.createViewmodel = createViewmodel
Panel.finalizeCalculation = finalizeCalculation
Panel.setFromCalculation = setFromCalculation

RUN_SERVICE:BindToRenderStep("STARBLAST_INTERNAL: 450/POSTCHARACTER-VIEWMODEL_CALCULATION", 450, finalizeCalculation)
RUN_SERVICE:BindToRenderStep("STARBLAST_INTERNAL: 500/POSTCHARACTER-VIEWMODEL", 500, setFromCalculation)

return Panel
