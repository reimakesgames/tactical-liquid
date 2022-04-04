--[[
setViewmodel
	Only sets the viewmodel
	Returns nothing
getViewmodel
	Only gets the viewmodel
	Returns the viewmodel
clearActiveViewmodel
	Clears viewmodel folder
	Returns nothing


createViewmodel
	Turns the provided model into a ViewmodelClass and docks an AnimatorClass for it
	Returns ViewmodelSubsystem


finalizeCalculation
	Updates and finalizes the calculations
	Returns nothing
setFromCalculation
	Sets the provided ViewmodelClass' MATRIX
	Returns ViewmodelClass
]]

--debugger
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

--services
local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")
local RUN_SERVICE = game:GetService("RunService")

--constant directories
local USER_INPUT_SERVICE = game:GetService("UserInputService")
local LOCAL_PLAYER = game:GetService("Players").LocalPlayer
local PLAYER_GUI = LOCAL_PLAYER:WaitForChild("PlayerGui")
local PLAYER_SCRIPTS = LOCAL_PLAYER:WaitForChild("PlayerScripts")

--client modules
local filesPanel = require(PLAYER_SCRIPTS.TacticalLiquidClient.FilesPanel)
local playerPanel = require(PLAYER_SCRIPTS.TacticalLiquidClient.PlayerPanel)
local inputPanel = require(PLAYER_SCRIPTS.TacticalLiquidClient.InputPanel)

--shared modules
local animatorPanel = require(REPLICATED_STORAGE.Libraries.AnimatorPanel)
local spring = require(REPLICATED_STORAGE.Libraries.Spring)
local Utility = require(REPLICATED_STORAGE.Libraries.Utility)

--directories
local Camera = playerPanel.GetCamera()
local CLASSES = REPLICATED_STORAGE.Classes

--variable directories
--Contains the Viewmodels and hidden Viewmodels
ViewmodelFolder = Camera:FindFirstChild("Viewmodel") or filesPanel.CreateNewDirectory(Camera, "Viewmodel")
ActiveViewmodel = ViewmodelFolder:FindFirstChild("Active") or filesPanel.CreateNewDirectory(ViewmodelFolder, "Active")
InactiveViewmodels = ViewmodelFolder:FindFirstChild("Inactive") or filesPanel.CreateNewDirectory(ViewmodelFolder, "Inactive")

--springs
spring.Create("VIEWMODEL_SWAY", 5, 50, 4, 4)

--external classes
local VIEWMODEL_SUBSYSTEM = require(CLASSES.ViewmodelSubsystem)

--variables
local Active
local Viewmodel = nil

--inputs


--supportive functions
local function ErrorWrapper(Code)
    Utility.SafeError("["..Code.."]: "..ERROR_CODES[Code])
end


--main functions
function setViewmodel(ViewmodelSubsystem: VIEWMODEL_SUBSYSTEM.Class): nil
    clearActiveViewmodel()
    ViewmodelSubsystem.Viewmodel.Parent = ActiveViewmodel
    Viewmodel = ViewmodelSubsystem.Viewmodel
    Active = ViewmodelSubsystem
    return nil
end

function getViewmodel()
    return Viewmodel
end

function clearActiveViewmodel(): nil
    for _, _Viewmodel in pairs(ActiveViewmodel:GetChildren()) do
        _Viewmodel:SetPrimaryPartCFrame(CFrame.new(0, -64, 0))
        _Viewmodel.Parent = InactiveViewmodels
    end
    Viewmodel = nil
    Active = nil
    return nil
end



function createViewmodel(Model: Model, Name: string): VIEWMODEL_SUBSYSTEM.Class | nil
    if not Model == nil                                                                 then ErrorWrapper(100) return end
    if not Utility.AssertType(Model, "Model")                                           then ErrorWrapper(101) return end
    if not Model:FindFirstChild("Animations")                                           then ErrorWrapper(102) return end
    if not Model:FindFirstChild("Animations"):IsA("Configuration")                      then ErrorWrapper(103) return end
    if not Model:FindFirstChild("AnimationController")                                  then ErrorWrapper(104) return end
    if not Model:FindFirstChild("AnimationController"):FindFirstChild("Animator")       then ErrorWrapper(105) return end

    local _Viewmodel = Model:Clone()
    _Viewmodel.Parent = InactiveViewmodels
    if Name then _Viewmodel.Name = Name end
    local _ViewmodelAnimator = animatorPanel.New(_Viewmodel.AnimationController, _Viewmodel.Animations)
    
    local ViewmodelSubsystem: VIEWMODEL_SUBSYSTEM.Class = {
        Viewmodel = _Viewmodel,
        Animator = _ViewmodelAnimator,
    }
    
    Viewmodel = ViewmodelSubsystem.Viewmodel
    Active = ViewmodelSubsystem

    print(ViewmodelSubsystem)
    
    return ViewmodelSubsystem
end



function finalizeCalculation(deltaTime): nil
    local MouseDelta = USER_INPUT_SERVICE:GetMouseDelta()
    
    spring.VIEWMODEL_SWAY
        :Shove(Vector3.new(-MouseDelta.Y, -MouseDelta.X, 0) * 0.05)
        :Update(deltaTime)

    return nil
end

function setFromCalculation(): VIEWMODEL_SUBSYSTEM.Class | nil
    if not Active then return nil end
    local _Viewmodel = Active.Viewmodel
    
    local _ViewmodelCFrame = Camera.CFrame

    _ViewmodelCFrame = _ViewmodelCFrame * CFrame.Angles(math.rad(spring.VIEWMODEL_SWAY.Position.X), math.rad(spring.VIEWMODEL_SWAY.Position.Y), 0)

    _Viewmodel:SetPrimaryPartCFrame(_ViewmodelCFrame)
    
    return Active
end


do
-- local function Update(deltaTime)
--     if not Viewmodel or Viewmodel.Parent ~= ActiveViewmodel then
--         clearActiveViewmodelFolder()
--         setAsActiveViewmodel()
--         ErrorWrapper(401)
--         return
--     end

--     Viewmodel:SetPrimaryPartCFrame(Camera.CFrame * CFrame.Angles(math.rad(spring.VIEWMODEL_SWAY.Position.X), math.rad(spring.VIEWMODEL_SWAY.Position.Y), 0))
-- end



-- local function clearActiveViewmodelFolder()
--     RUN_SERVICE:UnbindFromRenderStep("STARBLAST_INTERNAL: 500/POSTCHARACTER_VIEWMODEL")

--     for _, child in pairs(ActiveViewmodel:GetChildren()) do
--         child:SetPrimaryPartCFrame(CFrame.new(0, -64, 0))
--         child.Parent = InactiveViewmodels
--     end

--     return nil
-- end

-- local function setAsActiveViewmodel(viewmodel)
--     if viewmodel == nil then warn(ERROR_CODES[100]) return end
--     if not viewmodel:IsA("Model") then warn(ERROR_CODES[101]) return end

--     viewmodel.Parent = ActiveViewmodel

--     RUN_SERVICE:BindToRenderStep("STARBLAST_INTERNAL: 500/POSTCHARACTER_VIEWMODEL", 500, Update)
-- end



-- local function createViewmodelFromModel(model: Instance): Model | nil
--     if not model:IsA("Model") then print(ERROR_CODES[100]) return nil end
--     local viewmodel = model:Clone()
--     viewmodel.Parent = InactiveViewmodels

--     return viewmodel
-- end

-- local function useViewmodel(ViewmodelToUse: CLASS_viewmodel.Class | nil): nil
--     clearActiveViewmodelFolder()
--     setAsActiveViewmodel(ViewmodelToUse)

--     return nil
-- end
end

local Panel = {
    ViewmodelFolder = ViewmodelFolder,
    ActiveViewmodel = ActiveViewmodel,
    InactiveViewmodels = InactiveViewmodels,
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
