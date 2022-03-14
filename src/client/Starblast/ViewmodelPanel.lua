--services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

--constant directories
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")

--client modules
local FilesPanel = require(PlayerScripts.TacticalLiquidClient.FilesPanel)
local PlayerPanel = require(PlayerScripts.TacticalLiquidClient.PlayerPanel)

local Spring = require(ReplicatedStorage.Libraries.Spring)

--directories
local Camera = PlayerPanel.GetCamera()

--variable directories
--Contains the Viewmodels and hidden Viewmodels
ViewmodelFolder = Camera:FindFirstChild("Viewmodel") or FilesPanel.CreateNewDirectory(Camera, "Viewmodel")
ActiveViewmodel = ViewmodelFolder:FindFirstChild("Active") or FilesPanel.CreateNewDirectory(ViewmodelFolder, "Active")
InactiveViewmodels = ViewmodelFolder:FindFirstChild("Inactive") or FilesPanel.CreateNewDirectory(ViewmodelFolder, "Inactive")

--functions
local function clearActiveViewmodelFolder()
    RunService:UnbindFromRenderStep("TacticalLiquid_Internal_Viewmodel")
    for _, child in pairs(ActiveViewmodel:GetChildren()) do
        child:SetPrimaryPartCFrame(CFrame.new())
        child.Parent = InactiveViewmodels
    end
end

local function setAsActiveViewmodel(viewmodel)
    viewmodel.Parent = ActiveViewmodel
end

local Panel = {
    ViewmodelFolder = ViewmodelFolder,
    ActiveViewmodel = ActiveViewmodel,
    InactiveViewmodels = InactiveViewmodels,
}

Panel.CreateViewmodelFromModel = function(model)
    local viewmodel = model:Clone()
    viewmodel.Parent = InactiveViewmodels
    return viewmodel
end

Panel.ClearActiveViewmodelFolder = function()
    clearActiveViewmodelFolder()
end

Panel.UseViewmodel = function(viewmodel)
    clearActiveViewmodelFolder()
    if viewmodel then
        setAsActiveViewmodel(viewmodel)
        RunService:BindToRenderStep("TacticalLiquid_Internal_Viewmodel", Enum.RenderPriority.Camera.Value, function()
            viewmodel:SetPrimaryPartCFrame(Camera.CFrame)
        end)
    end
end

RunService.RenderStepped:Connect(function()

end)

return Panel