local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")
local UTILITY = require(REPLICATED_STORAGE.Libraries.Utility)
local Camera = workspace.CurrentCamera
local SurfaceDecals = Camera:FindFirstChild("SurfaceDecals") or UTILITY.quickInstance("Folder", {Name = "SurfaceDecals", Parent = Camera})
local BulletHole = Camera:FindFirstChild("BulletHole") or UTILITY.quickInstance("Folder", {Name = "BulletHole", Parent = SurfaceDecals})

local PANEL = {}

function PANEL.OnHit(RaycastResult: RaycastResult)
    UTILITY.quickInstance("Part", {
        Name = "Hit",
        Parent = BulletHole,
        Size = Vector3.new(0.1, 0.1, 0.1),
        CFrame = CFrame.new(RaycastResult.Position, RaycastResult.Position + RaycastResult.Normal),
        Color = Color3.new(0, 0.5, 0.5),
        Transparency = 0.5,
        Anchored = true,
        CanCollide = false,
        CanQuery = false,
        CanTouch = false,
    })
end

return PANEL