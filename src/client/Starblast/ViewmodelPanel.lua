--debugger
local ErrorCodes = {
    --Warns
    [100] = "Provided Viewmodel isn't a Model",
    
    --Errors
    [401] = "Viewmodel dissapeared during [ 020/PRECAM-VIEWMODEL ]",
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

local Spring = require(ReplicatedStorage.Libraries.Spring)

--directories
local Camera = PlayerPanel.GetCamera()

--variable directories
--Contains the Viewmodels and hidden Viewmodels
ViewmodelFolder = Camera:FindFirstChild("Viewmodel") or FilesPanel.CreateNewDirectory(Camera, "Viewmodel")
ActiveViewmodel = ViewmodelFolder:FindFirstChild("Active") or FilesPanel.CreateNewDirectory(ViewmodelFolder, "Active")
InactiveViewmodels = ViewmodelFolder:FindFirstChild("Inactive") or FilesPanel.CreateNewDirectory(ViewmodelFolder, "Inactive")

local SwaySpring = Spring.Create()
local SwaySpringValue = Vector3.new(0, 0, 0)

--inputs


--functions
local function clearActiveViewmodelFolder()
    RunService:UnbindFromRenderStep("STARBLAST_INTERNAL: 020/PRECAM-VIEWMODEL")

    for _, child in pairs(ActiveViewmodel:GetChildren()) do
        child:SetPrimaryPartCFrame(CFrame.new())
        child.Parent = InactiveViewmodels
    end
end

local function setAsActiveViewmodel(viewmodel)
    viewmodel.Parent = ActiveViewmodel

    RunService:BindToRenderStep("STARBLAST_INTERNAL: 020/PRECAM-VIEWMODEL", Enum.RenderPriority.Camera.Value - 80, function(deltaTime)
        if not viewmodel then
            RunService:UnbindFromRenderStep("STARBLAST_INTERNAL: 020/PRECAM-VIEWMODEL")
            
            return
        end

        viewmodel:SetPrimaryPartCFrame(Camera.CFrame * CFrame.Angles(math.rad(SwaySpringValue.X), math.rad(SwaySpringValue.Y), 0))
    end)
end

local Panel = {
    ViewmodelFolder = ViewmodelFolder,
    ActiveViewmodel = ActiveViewmodel,
    InactiveViewmodels = InactiveViewmodels,

    ErrorCodes = {
        
    }
}

Panel.CreateViewmodelFromModel = function(model: Instance): Model
    if not model:IsA("Model") then print(ErrorCodes[100]) return end
    local viewmodel = model:Clone()
    viewmodel.Parent = InactiveViewmodels

    return viewmodel
end

Panel.UseViewmodel = function(viewmodel)
    clearActiveViewmodelFolder()

    if not viewmodel then
        return
    end

    setAsActiveViewmodel(viewmodel)

end

RunService.RenderStepped:Connect(function(deltaTime)
    local MouseDelta = UserInputService:GetMouseDelta()
    SwaySpring:Shove(Vector3.new(-MouseDelta.Y, -MouseDelta.X, 0) * 0.05)
    SwaySpringValue = SwaySpring:Update(deltaTime)
end)

RunService:BindToRenderStep("STARBLAST_INTERNAL: 010/PRECAM-VIEWMODEL_CALCULATION", Enum.RenderPriority.Camera.Value - 90, function(deltaTime)
    
    
end)

return Panel
