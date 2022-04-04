local UTILITY = {}

UTILITY.safeError = function(ErrorMessage)
    pcall(function()
        error(ErrorMessage)
    end)
end

UTILITY.assertType = function(Object, Type)
    if not Object:IsA(Type) then
        return false
    end

    return true
end

return UTILITY