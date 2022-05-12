----DEBUGGER----
----CONFIGURATION----
local Configurations = game:GetService("ReplicatedFirst").Configuration
local GraphicsConfiguration = require(Configurations["graphics.cfg"])


----====----====----====----====----====----====----====----====----====----====

----SERVICES----
local ReplicatedStorage = game:GetService("ReplicatedStorage")

----DIRECTORIES----
----INTERNAL CLASSES----
----EXTERNAL CLASSES----
----INTERNAL MODULES----
----EXTERNAL MODULES----

----LIBRARIES----
local Util = require(ReplicatedStorage.Libraries.Utility)

local Tracers = require(ReplicatedStorage.Libraries.Tracers)

----====----====----====----====----====----====----====----====----====----====

----VARIABLES----
local Camera = workspace.CurrentCamera
local SurfaceDecals = Camera:FindFirstChild("SurfaceDecals") or Util.quickInstance("Folder", {Name = "SurfaceDecals", Parent = Camera})
local BulletHoles = Camera:FindFirstChild("BulletHole") or Util.quickInstance("Folder", {Name = "BulletHoles", Parent = SurfaceDecals})

local ColorByAccess = {
    [0] = Color3.new(0, 0.5, .9),
    [1] = Color3.new(0.9, 0.75, 0),
}

----FUNCTIONS----
local function GetNearbyBulletHoles(position)
    local array = workspace:GetPartBoundsInRadius(position, 0.125)
    local filtered = {}
    for _, Parts in pairs(array) do
        if Parts.Parent == BulletHoles then
            table.insert(filtered, Parts)
        end
    end

    return filtered
end

local function GetClosestPart(position, array)
    local closest
    local closestDistance = math.huge
    for _, Parts in pairs(array) do
        if not Parts:IsA("Part") then continue end
        local distance = (Parts.Position - position).Magnitude
        if distance < closestDistance then
            closest = Parts
            closestDistance = distance
        end
    end

    return closest
end

local function MakeHitPart(Access: number, RaycastResult: RaycastResult, ColorOverride: Color3, ImageOverride: string)
    local filtered = GetNearbyBulletHoles(RaycastResult.Position)
    local closest = GetClosestPart(RaycastResult.Position, filtered)
    if closest then
        closest:Destroy()
    end
    if typeof(ImageOverride) == "string" then
        if ImageOverride:sub(1, 13) ~= "rbxassetid://" then
            warn("ImageOverride must be a valid rbxassetid://* link format")
        end
    end

    local holeRoot = Util.quickInstance("Part", {
        Name = "Hit",
        Parent = BulletHoles,
        Size = Vector3.new(0.25, 0.25, 0.05),
        CFrame = CFrame.new(RaycastResult.Position, RaycastResult.Position + RaycastResult.Normal),
        Color = ColorOverride or ColorByAccess[Access] or Color3.new(0, 0.5, 0.5),
        Anchored = true,
        CanCollide = false,
        -- CanQuery = false,
        -- CanTouch = false,
    })
    Util.quickInstance("Decal", {
        Name = "Decal",
        Parent = holeRoot,
        Texture = ImageOverride or "rbxassetid://7180225054", --also "rbxassetid://8922687555"
        Face = Enum.NormalId.Front,
    })
end

local function CreateReflectSparks(originalDirection: Vector3, result: RaycastResult)
    local reflect = originalDirection - (2 * originalDirection:Dot(result.Normal)) * result.Normal
    for i = 1, math.random(4, GraphicsConfiguration.bullet_hit_sparks) do
        Tracers.new({
            position = result.Position,
            velocity = (Util.deviateUnit(reflect) * math.random(1, 50)),
            acceleration = Vector3.new(0, -workspace.Gravity, 0),
            visible = true,
            cancollide = true,
            size = 0.1,
            -- brightness = 20 * math.random(),
            brightness = 50,
            color = Color3.new(1, 1, 0.8),
            -- bloom = 0.005 * math.random(),
            bloom = 0,
            life = 1,
        })
    end
end

----CONNECTED FUNCTIONS----

----====----====----====----====----====----====----====----====----====----====

----PUBLIC----
local Panel = {}

Panel.MakeHitPart = MakeHitPart
Panel.CreateReflectSparks = CreateReflectSparks

return Panel