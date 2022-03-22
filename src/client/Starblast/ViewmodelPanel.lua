--debugger
local ErrorCodes = {
    --Warns
    [100] = "Provided Viewmodel is nil",
    [101] = "Provided Viewmodel isn't a Model",
    
    --Errors
    [401] = "Viewmodel dissapeared during [ 500/POSTCHARACTER-VIEWMODEL ]",
}

--services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

--constant directories
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")

--client modules
local FilesPanel = require(PlayerScripts.TacticalLiquidClient.FilesPanel)
local PlayerPanel = require(PlayerScripts.TacticalLiquidClient.PlayerPanel)
local InputPanel = require(PlayerScripts.TacticalLiquidClient.InputPanel)

--shared modules
local Spring = require(ReplicatedStorage.Libraries.Spring)
local Utility = require(ReplicatedStorage.Libraries.Utility)

--directories
local Camera = PlayerPanel.GetCamera()
local Classes = ReplicatedStorage.Classes

--variable directories
--Contains the Viewmodels and hidden Viewmodels
ViewmodelFolder = Camera:FindFirstChild("Viewmodel") or FilesPanel.CreateNewDirectory(Camera, "Viewmodel")
ActiveViewmodel = ViewmodelFolder:FindFirstChild("Active") or FilesPanel.CreateNewDirectory(ViewmodelFolder, "Active")
InactiveViewmodels = ViewmodelFolder:FindFirstChild("Inactive") or FilesPanel.CreateNewDirectory(ViewmodelFolder, "Inactive")

local SwaySpring = Spring.Create()
local SwaySpringValue = Vector3.new(0, 0, 0)

--external classes
local ViewmodelClass = require(Classes.ViewmodelClass)

--inputs


--functions
local function ErrorWrapper(Code)
    Utility.SafeError("["..Code.."]: "..ErrorCodes[Code])
end



local function clearActiveViewmodelFolder()
    RunService:UnbindFromRenderStep("STARBLAST_INTERNAL: 500/POSTCHARACTER_VIEWMODEL")

    for _, child in pairs(ActiveViewmodel:GetChildren()) do
        child:SetPrimaryPartCFrame(CFrame.new())
        child.Parent = InactiveViewmodels
    end

    return nil
end

local function setAsActiveViewmodel(viewmodel)
    if viewmodel == nil then warn(ErrorCodes[100]) return end
    if not viewmodel:IsA("Model") then warn(ErrorCodes[101]) return end

    viewmodel.Parent = ActiveViewmodel

    RunService:BindToRenderStep("STARBLAST_INTERNAL: 500/POSTCHARACTER_VIEWMODEL", 500, function(deltaTime)
        if not viewmodel or viewmodel.Parent ~= ActiveViewmodel then
            clearActiveViewmodelFolder()
            setAsActiveViewmodel()
            ErrorWrapper(401)
            return
        end

        viewmodel:SetPrimaryPartCFrame(Camera.CFrame * CFrame.Angles(math.rad(SwaySpringValue.X), math.rad(SwaySpringValue.Y), 0))
    end)
end



local function createViewmodelFromModel(model: Instance): Model | nil
    if not model:IsA("Model") then print(ErrorCodes[100]) return nil end
    local viewmodel = model:Clone()
    viewmodel.Parent = InactiveViewmodels

    return viewmodel
end

local function useViewmodel(ViewmodelToUse: ViewmodelClass.Class | nil): nil
    clearActiveViewmodelFolder()
    setAsActiveViewmodel(ViewmodelToUse)
    
    return nil
end

local Panel = {
    ViewmodelFolder = ViewmodelFolder,
    ActiveViewmodel = ActiveViewmodel,
    InactiveViewmodels = InactiveViewmodels,
}

Panel.CreateViewmodelFromModel = createViewmodelFromModel

Panel.UseViewmodel = useViewmodel

RunService:BindToRenderStep("STARBLAST_INTERNAL: 450/POSTCHARACTER-VIEWMODEL_CALCULATION", 450, function(deltaTime)
    local MouseDelta = UserInputService:GetMouseDelta()
    SwaySpring:Shove(Vector3.new(-MouseDelta.Y, -MouseDelta.X, 0) * 0.05)
    SwaySpringValue = SwaySpring:Update(deltaTime)
end)

return Panel
