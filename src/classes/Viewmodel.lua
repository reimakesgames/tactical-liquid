export type ViewmodelSettings = {
	UseCharacterShirt: boolean;
	LeftArmColor: Color3?;
	RightArmColor: Color3?;
}

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
	Settings: ViewmodelSettings;
	Instance: Model;
	Animator: Animator;
	Culled: boolean;
	Cull: (state: boolean) -> ();
	LoadAnimation: (key: string, animation: Animation) -> (AnimationTrack);
	GetAnimation: (key: string) -> (AnimationTrack?);
	UnloadAnimation: (key: string) -> ();
	Update: (deltaTime: number, viewmodelCFrame: CFrame) -> ();
}

local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local CULL_CFRAME = CFrame.new(0, 1e29, 0)

local Viewmodel = {}
Viewmodel.__index = Viewmodel

local function checkViewmodelInstance(viewmodelInstance: Model)
	assert(viewmodelInstance:FindFirstChild("HumanoidRootPart"))
	assert(viewmodelInstance:FindFirstChild("Settings"))
	assert(viewmodelInstance:FindFirstChild("FakeCamera"))
	assert(viewmodelInstance:FindFirstChild("Left Arm"))
	assert(viewmodelInstance:FindFirstChild("Right Arm"))
	assert(viewmodelInstance:FindFirstChildWhichIsA("AnimationController") or viewmodelInstance:FindFirstChildWhichIsA("Humanoid"))
	assert(viewmodelInstance:FindFirstChild("Weapon"))
end

local function getAnimator(viewmodelInstance: Model): Animator
	checkViewmodelInstance(viewmodelInstance)
	local animatorContainer: AnimationController | Humanoid = 
		viewmodelInstance:FindFirstChildWhichIsA("AnimationController") or 
		viewmodelInstance:FindFirstChildWhichIsA("Humanoid")
	local animator = animatorContainer:FindFirstChildWhichIsA("Animator") or Instance.new("Animator", animatorContainer)
	return animator
end

local function cleanViewmodelInstance(viewmodelInstance: Model)
	checkViewmodelInstance(viewmodelInstance)
	viewmodelInstance.PrimaryPart = viewmodelInstance.HumanoidRootPart
	if viewmodelInstance:FindFirstChild("AnimSaves") then
		viewmodelInstance.AnimSaves:Destroy()
	end
	for _, obj in pairs(viewmodelInstance:GetDescendants()) do
		if obj:IsA("BasePart") or obj:IsA("UnionOperation") then
			obj.CanCollide = false
			obj.CastShadow = false
		end
	end
end

local function updateArms(viewmodelInstance: Model, viewmodelSettings: ViewmodelSettings)
	checkViewmodelInstance(viewmodelInstance)
	local character: Model = LocalPlayer.Character
	if character then
		local shirt = character:FindFirstChildWhichIsA("Shirt")
		local leftArm: Part = character:FindFirstChild("Left Arm")
		local rightArm: Part = character:FindFirstChild("Right Arm")
		local vmLeftArm: Part = viewmodelInstance:FindFirstChild("Left Arm")
		local vmRightArm: Part = viewmodelInstance:FindFirstChild("Right Arm")
		
		vmLeftArm.Color = viewmodelSettings.LeftArmColor or leftArm.Color
		vmRightArm.Color = viewmodelSettings.RightArmColor or rightArm.Color
		
		if viewmodelSettings.UseCharacterShirt then
			local vmLeftArmShirt: Decal = vmLeftArm:FindFirstChild("Shirt")
			local vmRightArmShirt: Decal = vmRightArm:FindFirstChild("Shirt")

			if vmLeftArmShirt then
				if shirt then
					vmLeftArmShirt.Texture = shirt.ShirtTemplate
					vmLeftArmShirt.Color3 = shirt.Color3
				else
					vmLeftArmShirt.Transparency = 1
				end
			end

			if vmRightArmShirt then
				if shirt then
					vmRightArmShirt.Texture = shirt.ShirtTemplate
					vmRightArmShirt.Color3 = shirt.Color3
				else
					vmRightArmShirt.Transparency = 1
				end
			end
		end
	end
end

function Viewmodel:Cull(state: boolean)
	self.Culled = state
end

function Viewmodel:LoadAnimation(key: string, animation: Animation): AnimationTrack
	local self: Viewmodel = self
	
	assert(self.Animations[key] == nil, string.format("Animation key %s is already taken, unload this key first before loading a new one.", key))
	assert(
		typeof(animation) == "Instance" and animation:IsA("Animation"), 
		string.format(
			"Animation argument is invalid (type %s - class %s)", 
			typeof(animation), (typeof(animation) == "Instance" and animation.ClassName))
	)
	
	local animationTrack = self.Animator:LoadAnimation(animation)
	self.Animations[key] = animationTrack
	return animationTrack
end

function Viewmodel:GetAnimation(key: string): AnimationTrack?
	local self: Viewmodel = self
	return self.Animations[key]
end

function Viewmodel:UnloadAnimation(key: string)
	local self: Viewmodel = self
	
	assert(self.Animations[key], string.format("%s is not a valid member of this Viewmodel's animations"))
	
	local animationTrack: AnimationTrack = self.Animations[key]
	self.Animations[key] = nil
	animationTrack:Destroy()
end

function Viewmodel:Update(deltaTime: number, viewmodelCFrame: CFrame)
	local self: Viewmodel = self
	
	local scaledDeltaTime = deltaTime * 60
	self.Instance:SetPrimaryPartCFrame(self.Culled and CULL_CFRAME or viewmodelCFrame)
	if not self.Culled then
		updateArms(self.Instance, self.Settings) -- save performance a little bit
		--camera animation support
		if self.Instance:FindFirstChild("FakeCamera") then
			local fakeCamera = self.Instance.FakeCamera
			local newCamCFrame = fakeCamera.CFrame:ToObjectSpace(self.Instance.PrimaryPart.CFrame)
			if self.__oldCamCFrame then
				local _, _, z = newCamCFrame:ToOrientation()
				local x, y, _ = newCamCFrame:ToObjectSpace(self.__oldCamCFrame):ToEulerAnglesXYZ()
				workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(x, y, -z)
			end
			self.__oldCamCFrame = newCamCFrame
		end
	end
end

function Viewmodel.new(viewmodelInstance: Model): Viewmodel
	checkViewmodelInstance(viewmodelInstance)
	cleanViewmodelInstance(viewmodelInstance)
	local self = setmetatable({
		Settings = require(viewmodelInstance.Settings);
		Instance = viewmodelInstance;
		Animator = getAnimator(viewmodelInstance);
		Culled = false;
		Animations = {};
	}, Viewmodel)
	return self
end

return Viewmodel