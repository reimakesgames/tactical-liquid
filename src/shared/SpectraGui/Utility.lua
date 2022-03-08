local Utility = {}

Utility.Assert = function(condition, message): nil
    if not condition then
        error(message, 2)
    end
end

Utility.SafeAssert = function(condition): boolean
    if not condition then
        return false
    end

    return true
end

Utility.AssertType = function(value, expectedType, message)
    Utility.Assert(typeof(value) == expectedType, message)
end

return Utility