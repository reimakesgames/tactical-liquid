----DEBUGGER----
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

----INTERNAL CLASSES----
----EXTERNAL CLASSES----

----INTERNAL MODULES----
-- local inputPanel = require(PLAYER_SCRIPTS.TacticalLiquidClient.InputPanel)

----EXTERNAL MODULES----
local Util = require(ReplicatedStorage.Libraries.Utility)

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
local InactiveViewmodels = ViewmodelFolder:FindFirstChild("Inactive") or Util.quickInstance("Folder", {Name = "Inactive", Parent = ViewmodelFolder})

local ViewmodelSway = Spring.new(5, 50, 4, 4)

local Viewmodel = nil

----FUNCTIONS----
function SetViewmodel(viewmodel: Model)
    ClearActiveViewmodel()
    viewmodel.Parent = ViewmodelFolder
    Viewmodel = viewmodel
end

function GetViewmodel()
    return Viewmodel
end

function ClearActiveViewmodel()
    if Viewmodel then
        Viewmodel:SetPrimaryPartCFrame(CFrame.new(0, -128, 0))
        Viewmodel.Parent = InactiveViewmodels
        Viewmodel = nil
    end
end

function CreateViewmodel(Model: Model, Name: string)
    if not Model == nil then return end
    if not Model:IsA("Model") then return end

    local viewmodel = Model:Clone()
    viewmodel.Parent = InactiveViewmodels
    if Name then
        viewmodel.Name = Name
    end

    return viewmodel
end

function FinalizeCalculation(deltaTime)
    local MouseDelta = UserInputService:GetMouseDelta()

    ViewmodelSway:Shove(Vector3.new(-MouseDelta.Y, -MouseDelta.X, 0) * 0.05)
    ViewmodelSway:Update(deltaTime)
end

function SetFromCalculation()
    if Viewmodel == nil then return end
    local viewmodelCFrame = Camera.CFrame
    viewmodelCFrame = viewmodelCFrame * CFrame.Angles(math.rad(ViewmodelSway.Position.X), math.rad(ViewmodelSway.Position.Y), 0)
    Viewmodel:SetPrimaryPartCFrame(viewmodelCFrame)
end

----CONNECTED FUNCTIONS----
RunService:BindToRenderStep("STARBLAST_INTERNAL: 450/POSTCHARACTER-VIEWMODEL_CALCULATION", 450, FinalizeCalculation)
RunService:BindToRenderStep("STARBLAST_INTERNAL: 500/POSTCHARACTER-VIEWMODEL", 500, SetFromCalculation)


----====----====----====----====----====----====----====----====----====----====


----PUBLIC----
local Panel = {
    ViewmodelFolder = ViewmodelFolder,
    InactiveViewmodels = InactiveViewmodels,
}

Panel.SetViewmodel = SetViewmodel
Panel.GetViewmodel = GetViewmodel
Panel.ClearActiveViewmodel = ClearActiveViewmodel
Panel.CreateViewmodel = CreateViewmodel
Panel.FinalizeCalculation = FinalizeCalculation
Panel.SetFromCalculation = SetFromCalculation

return Panel
