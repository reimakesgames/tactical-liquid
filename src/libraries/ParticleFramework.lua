--particle framework, just call CreateTracerController and it returns a new tracer controller
--it only has basic functionality, for debug purposes
--or not at all i figured out that FastCast has their own particle system
--orrrrr i can use this to........ simplify thingssss...

local ParticleFramework = {}

ParticleFramework.GeneratePair = function()
    local Folder = Instance.new("Folder")
    Folder.Name = "Beam"
    local Attachment = Instance.new("Attachment")
    local Attachment2 = Instance.new("Attachment")
    local Beam = Instance.new("Beam")
    Attachment.Parent = Folder
    Attachment2.Parent = Folder
    Beam.Parent = Folder

    Beam.Attachment0 = Attachment
    Beam.Attachment1 = Attachment2
    Beam.Width = 0.1
    Beam.Brightness = 10
    
    return Folder
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