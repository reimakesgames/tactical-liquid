--particle framework, just call CreateTracerController and it returns a new tracer controller
--it only has basic functionality, for debug purposes
--or not at all i figured out that FastCast has their own particle system
--orrrrr i can use this to........ simplify thingssss...

local ParticleFramework = {}

ParticleFramework.GeneratePair = function()
    local RootPart = Instance.new("Part")
    RootPart.Position = Vector3.new(0, 0, 0)
    RootPart.Size = Vector3.new(1, 1, 1)
    RootPart.Anchored = true
    RootPart.CanCollide = false
    RootPart.Transparency = 1
    local Attachment = Instance.new("Attachment")
    Attachment.Name = "Attachment0"
    local Attachment2 = Instance.new("Attachment")
    Attachment2.Name = "Attachment1"
    local Beam = Instance.new("Beam")
    Attachment.Parent = RootPart
    Attachment2.Parent = RootPart
    Beam.Parent = RootPart

    Beam.FaceCamera = true
    Beam.Texture = "rbxassetid://502107146"
    Beam.Attachment0 = Attachment
    Beam.Attachment1 = Attachment2
    Beam.Width0 = 0.1
    Beam.Width1 = 0.1
    Beam.Brightness = 100

    local cycle = 1
    repeat
        cycle += 1
        Beam:Clone().Parent = RootPart
    until cycle >= 7
    
    return RootPart
end

ParticleFramework.CreateTracerController = function()
    local TracerController = {}

    TracerController.NewEffect = function(Position: Vector3, Direction: Vector3, Velocity: number)
        
    end

    TracerController.UpdateEffect = function()
        
    end

    return TracerController
end

return ParticleFramework