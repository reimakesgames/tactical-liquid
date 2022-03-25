local Utility = {}

Utility.SafeError = function(errorMessage)
    pcall(function()
        error(errorMessage)
    end)
end

Utility.AssertType = function(Object, Type)
    if not Object:IsA(Type) then
        return false
    end

    return true
end

return Utility