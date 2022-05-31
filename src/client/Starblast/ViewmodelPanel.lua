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

local AnimatorPanel = require(Modules.AnimatorPanel)

----LIBRARIES----
local Spring = require(TacticalLiquid.Modules.Spring)


----====----====----====----====----====----====----====----====----====----====


----VARIABLES----
local Camera = workspace.CurrentCamera
-- local character = LOCAL_PLAYER.Character
-- LOCAL_PLAYER.CharacterAdded:Connect(function(newCharacter)
--     character = newCharacter
-- end)

local ViewmodelFolder = Camera:FindFirstChild("Viewmodel") or Util.quickInstance("Folder", {Name = "Viewmodel", Parent = Camera})
local ActiveViewmodel = ViewmodelFolder:FindFirstChild("Active") or Util.quickInstance("Model", {Name = "Active", Parent = ViewmodelFolder})
local InactiveViewmodels = ViewmodelFolder:FindFirstChild("Inactive") or Util.quickInstance("Folder", {Name = "Inactive", Parent = ViewmodelFolder})

local ViewmodelSway = Spring.new(5, 50, 4, 4)

local Active = nil
local Viewmodel = nil

----FUNCTIONS----
local function ErrorWrapper(code)
    Util.safeError("["..code.."]: "..ERROR_CODES[code])
end

function SetViewmodel(_ViewmodelSubsystem: ViewmodelSubsystem.ViewmodelSubsystem): nil
    ClearActiveViewmodel()
    _ViewmodelSubsystem.Viewmodel.Parent = ActiveViewmodel
    Viewmodel = _ViewmodelSubsystem.Viewmodel
    Active = _ViewmodelSubsystem
    return nil
end

function GetViewmodel(): Model
    return Viewmodel
end

function ClearActiveViewmodel(): nil
    for _, _Viewmodel in pairs(ActiveViewmodel:GetChildren()) do
        _Viewmodel:SetPrimaryPartCFrame(CFrame.new(0, -64, 0))
        _Viewmodel.Parent = InactiveViewmodels
    end
    Viewmodel = nil
    Active = nil
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

    local viewmodel = Model:Clone()
    viewmodel.Parent = InactiveViewmodels
    if Name then
        viewmodel.Name = Name
    end
    local viewmodelAnimator: AnimatorPanel.AnimatorPanel = AnimatorPanel.New(viewmodel.AnimationController, viewmodel.Animations)

    local viewmodelSubsystem: ViewmodelSubsystem.ViewmodelSubsystem = {
        Viewmodel = viewmodel,
        Animator = viewmodelAnimator,
    }

    viewmodel = viewmodelSubsystem.Viewmodel
    Active = viewmodelSubsystem

    print(viewmodelSubsystem)

    return viewmodelSubsystem
end

function FinalizeCalculation(deltaTime): nil
    local MouseDelta = UserInputService:GetMouseDelta()

    ViewmodelSway
        :Shove(Vector3.new(-MouseDelta.Y, -MouseDelta.X, 0) * 0.05)
        :Update(deltaTime)

    return nil
end

function SetFromCalculation(): ViewmodelSubsystem.ViewmodelSubsystem | nil
    if Active == nil then return nil end
    local viewmodel = Active.Viewmodel or nil

    local viewmodelCFrame = Camera.CFrame

    viewmodelCFrame = viewmodelCFrame * CFrame.Angles(math.rad(ViewmodelSway.Position.X), math.rad(ViewmodelSway.Position.Y), 0)

    viewmodel:SetPrimaryPartCFrame(viewmodelCFrame)

    return Active
end

----CONNECTED FUNCTIONS----


----====----====----====----====----====----====----====----====----====----====


----PUBLIC----
local Panel = {
    ViewmodelFolder = ViewmodelFolder,
    ActiveViewmodel = ActiveViewmodel,
    InactiveViewmodels = InactiveViewmodels,
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
