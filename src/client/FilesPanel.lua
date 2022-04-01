local Panel = {}

Panel.createNewDirectory = function(Directory, Name)
    local NewDirectory = Instance.new("Folder")
    NewDirectory.Parent = Directory
    NewDirectory.Name = Name

    return NewDirectory
end

Panel.cleanContentsOfDirectory = function(Directory)
    for _, Child in pairs(Directory:GetChildren()) do
        Child:Destroy()
    end
end

Panel.returnChildrenOfDirectory = function(Directory)
    return Directory:GetChildren()
end

Panel.returnDescendantsOfDirectory = function(Directory)
    return Directory:GetDescendants()
end

return Panel