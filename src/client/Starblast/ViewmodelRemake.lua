----DEBUGGER----
----CONFIGURATION----


----====----====----====----====----====----====----====----====----====----====


----SERVICES----
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

----DIRECTORIES----
local TacticalLiquid = ReplicatedStorage:WaitForChild("TacticalLiquid")

----INTERNAL CLASSES----
export type ViewmodelInstance = Model & {
    HumanoidRootPart: Part;
    Settings: ModuleScript;
    FakeCamera: Part;
    ["Left Arm"]: Part;
    ["Right Arm"]: Part;
    AnimationController: AnimationController?;
    Humanoid: Humanoid?;
    Weapon: Model;
}

export type Viewmodel = {
    Animations: {[string]: AnimationTrack};
    Instance: Model;
    Animator: Animator;
    Culled: boolean;

    Cull: (self: Viewmodel, state: boolean) -> ();
    LoadAnimation: (self: Viewmodel, key: string, animation: Animation) -> (AnimationTrack);
    GetAnimation: (self: Viewmodel, key: string) -> (AnimationTrack?);
    UnloadAnimation: (self: Viewmodel, key: string) -> ();
    Update: (self: Viewmodel, deltaTime: number, viewmodelCFrame: CFrame) -> ();
}

----EXTERNAL CLASSES----
----INTERNAL MODULES----

----EXTERNAL MODULES----
local Spring = require(TacticalLiquid.Modules.Spring)

----LIBRARIES----
local Util = require(ReplicatedStorage.Libraries.Utility)


----====----====----====----====----====----====----====----====----====----====


----VARIABLES----
local CurrentCamera = workspace.CurrentCamera
local ViewmodelDirectory = CurrentCamera:FindFirstChild("Viewmodels") or Util.quickInstance("Folder", {Name = "Viewmodels", Parent = CurrentCamera})
local CULL_CFRAME = CFrame.new(0, 1e29, 0)

local SwaySpring = Spring.new(5, 50, 4, 4)

local format = string.format

----FUNCTIONS----
local function checkViewmodelInstance(viewmodelInstance: Model)
    assert(viewmodelInstance:FindFirstChild("HumanoidRootPart"))
    assert(viewmodelInstance:FindFirstChild("FakeCamera"))
    assert(viewmodelInstance:FindFirstChild("Left Arm"))
    assert(viewmodelInstance:FindFirstChild("Right Arm"))
    assert(viewmodelInstance:FindFirstChildWhichIsA("AnimationController") or viewmodelInstance:FindFirstChildWhichIsA("Humanoid"))
end

local function cleanViewmodelInstance(viewmodelInstance: Model | any)
    local success = pcall(checkViewmodelInstance, viewmodelInstance)
    if not success then
        viewmodelInstance:Destroy()
        return 1
    end
    viewmodelInstance.PrimaryPart = viewmodelInstance.HumanoidRootPart
    if viewmodelInstance:FindFirstChild("AnimSaves") then
        viewmodelInstance.AnimSaves:Destroy()
    end
    for _, child in pairs(viewmodelInstance:GetDescendants()) do
        if child:IsA("BasePart") or child:IsA("UnionOperation") then
            child.Anchored = false
            child.CanCollide = false
            child.CastShadow = false
        end
    end
    viewmodelInstance.Parent = ViewmodelDirectory
    return 0
end

local function getAnimator(viewmodelInstance: Model): Animator
    checkViewmodelInstance(viewmodelInstance)
    local animatorContainer: AnimationController | Humanoid =
        viewmodelInstance:FindFirstChildWhichIsA("AnimationController") or
        viewmodelInstance:FindFirstChildWhichIsA("Humanoid")
    local animator = animatorContainer:FindFirstChildWhichIsA("Animator") or Instance.new("Animator", animatorContainer)
    return animator
end

local function updateSpring(deltaTime)
    SwaySpring:Update(deltaTime)
end

----CONNECTED FUNCTIONS----
RunService.RenderStepped:Connect(updateSpring)


----====----====----====----====----====----====----====----====----====----====


----PUBLIC----
local Viewmodel = {}
-- Viewmodel Controls
function Viewmodel:Cull(state: boolean)
    self.Culled = state
end

-- Viewmodel Animation API
function Viewmodel:LoadAnimation(key: string, animation: Animation): AnimationTrack
    assert(self.Animations[key] == nil, format("Cannot use %s as animation key", key))
    assert(
		typeof(animation) == "Instance" and animation:IsA("Animation"),
		format(
			"Animation argument is invalid (type %s - class %s)",
			typeof(animation), (typeof(animation) == "Instance" and animation.ClassName))
	)
    local animationTrack = self.Animator:LoadAnimation(animation)
    self.Animations[key] = animationTrack
    return animationTrack
end
function Viewmodel:UnloadAnimation(key: string)
	assert(self.Animations[key], format("%s is not a valid member of this Viewmodel's animations"))
    local animationTrack = self.Animations[key]
    if animationTrack then
        self.Animations[key] = nil
        animationTrack:Destroy()
    end
end
function Viewmodel:GetAnimation(key: string)
    return self.Animations[key]
end

-- Viewmodel CFrame API
function Viewmodel:Update(deltaTime: number, viewmodelCFrame: CFrame)
    if not self.Culled then
        local Delta = UserInputService:GetMouseDelta()
        SwaySpring:Shove(Vector3.new(-Delta.Y, -Delta.X, 0) * 0.05)
        viewmodelCFrame = viewmodelCFrame * CFrame.Angles(math.rad(SwaySpring.Position.X), math.rad(SwaySpring.Position.Y), 0)
    end
    self.Instance:SetPrimaryPartCFrame(self.Culled and CULL_CFRAME or viewmodelCFrame)

    -- camera stuff lol

    if self.Culled then
        return
    end

    if not self.Instance:FindFirstChild("FakeCamera") then
        return
    end

    local fakeCamera = self.Instance.FakeCamera
    local newCamCFrame = fakeCamera.CFrame:ToObjectSpace(self.Instance.PrimaryPart.CFrame)
    if self.__oldCamCFrame then
        local _, _, z = newCamCFrame:ToOrientation()
        local x, y, _ = newCamCFrame:ToObjectSpace(self.__oldCamCFrame):ToEulerAnglesXYZ()
        CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.Angles(x, y, -z)
    end
    self.__oldCamCFrame = newCamCFrame
end

-- new function duh
function Viewmodel.new(viewmodelInstance: Model): Viewmodel | number
    local VM = viewmodelInstance:Clone()
    if cleanViewmodelInstance(VM) == 0 then
        local viewmodel = setmetatable({
            Animations = {},
            Animator = getAnimator(VM),
            Instance = VM,
            Culled = false,
        }, Viewmodel)
        return viewmodel
    else
        return 1
    end
end

Viewmodel.__index = Viewmodel

return Viewmodel
