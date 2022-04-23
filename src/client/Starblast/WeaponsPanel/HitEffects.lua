local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")
local UTILITY = require(REPLICATED_STORAGE.Libraries.Utility)
local Camera = workspace.CurrentCamera
local SurfaceDecals = Camera:FindFirstChild("SurfaceDecals") or UTILITY.quickInstance("Folder", {Name = "SurfaceDecals", Parent = Camera})
local BulletHoles = Camera:FindFirstChild("BulletHole") or UTILITY.quickInstance("Folder", {Name = "BulletHoles", Parent = SurfaceDecals})
local ClientHoles = Camera:FindFirstChild("BulletHole") or UTILITY.quickInstance("Folder", {Name = "ClientHoles", Parent = BulletHoles})

local function getNearbyBulletHoles(position)
    local array = workspace:GetPartBoundsInRadius(position, 0.125)
    local filtered = {}
    for _, Parts in pairs(array) do
        if Parts.Parent == BulletHoles then
            table.insert(filtered, Parts)
        end
    end

    return filtered
end

local function getClosestPart(position, array)
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

local PANEL = {}

local ColorByAccess = {
    [0] = Color3.new(0, 0.5, .9),
    [1] = Color3.new(0.9, 0.75, 0),
}

function PANEL.OnHit(Access: number, RaycastResult: RaycastResult, ColorOverride: Color3, ImageOverride: string)
    local filtered = getNearbyBulletHoles(RaycastResult.Position)
    local closest = getClosestPart(RaycastResult.Position, filtered)
    if closest then
        closest:Destroy()
    end
    if typeof(ImageOverride) == "string" then
        if ImageOverride:sub(1, 13) ~= "rbxassetid://" then
            warn("ImageOverride must be a valid rbxassetid://* link format")
        end
    end

    local holeRoot = UTILITY.quickInstance("Part", {
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
    UTILITY.quickInstance("Decal", {
        Name = "Decal",
        Parent = holeRoot,
        Texture = ImageOverride or "rbxassetid://7180225054", --also "rbxassetid://8922687555"
        Face = Enum.NormalId.Front,
    })
end

return PANEL