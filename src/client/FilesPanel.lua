local Panel = {}

Panel.CreateNewDirectory = function(Directory, Name)
    local NewDirectory = Instance.new("Folder")
    NewDirectory.Parent = Directory
    NewDirectory.Name = Name

    return NewDirectory
end

Panel.CleanContentsOfDirectory = function(Directory)
    for _, Child in pairs(Directory:GetChildren()) do
        Child:Destroy()
    end
end

Panel.ReturnChildrenOfDirectory = function(Directory)
    return Directory:GetChildren()
end

Panel.ReturnDescendantsOfDirectory = function(Directory)
    return Directory:GetDescendants()
end

return Panel