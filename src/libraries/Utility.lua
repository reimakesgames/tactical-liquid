local Utility = {}

Utility.SafeError = function(errorMessage)
    pcall(function()
        error(errorMessage)
    end)
end

return Utility