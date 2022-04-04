local PANEL = {}

PANEL.createNewDirectory = function(directory, name)
    local NewDirectory = Instance.new("Folder")
    NewDirectory.Parent = directory
    NewDirectory.Name = name

    return NewDirectory
end

PANEL.cleanContentsOfDirectory = function(directory)
    for _, Child in pairs(directory:GetChildren()) do
        Child:Destroy()
    end
end

PANEL.returnChildrenOfDirectory = function(directory)
    return directory:GetChildren()
end

PANEL.returnDescendantsOfDirectory = function(directory)
    return directory:GetDescendants()
end

return PANEL
