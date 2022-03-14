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
        RunService:BindToRenderStep("TacticalLiquid_Internal_Viewmodel", Enum.RenderPriority.Camera.Value, function(deltaTime)
            viewmodel:SetPrimaryPartCFrame(Camera.CFrame * CFrame.Angles(math.rad(SwaySpringValue.X), math.rad(SwaySpringValue.Y), 0))
        end)
    end
end

RunService.RenderStepped:Connect(function(deltaTime)
    local MouseDelta = UserInputService:GetMouseDelta()
    SwaySpring:Shove(Vector3.new(-MouseDelta.Y, -MouseDelta.X, 0) * 0.05)
    SwaySpringValue = SwaySpring:Update(deltaTime)
end)

return Panel