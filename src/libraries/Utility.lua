local Debris = game:GetService("Debris")

local Utility = {}

--math
function Utility.addition(a, b)
    return a + b
end

function Utility.multiplication(a, b)
    return a * b
end

--script utilities
function Utility.safeError(message)
    pcall(error, message)
end

function Utility.assertType(object, type)
    if not object:IsA(type) then
        return false
    end

    return true
end

function Utility.badLerp(origin, goal, alpha)
    if alpha < 0 then
        return origin
    elseif alpha > 1 then
        return goal
    end

    return origin + ((goal - origin) * alpha)
end

--instance utilities
function Utility.quickInstance(class, properties)
    local instance = Instance.new(class)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

function Utility.clonePlay(sound: Sound, parent: Instance): Sound
	local clone = sound:Clone()
	clone.Parent = parent
	clone:Play()
	Debris:AddItem(clone, clone.TimeLength + 1)
	return clone
end

--flow utilities
function Utility.isTeamMate(player1: Player, player2: Player): boolean
	return (player1 and player2 and not player1.Neutral and not player2.Neutral and player1.TeamColor == player2.TeamColor)
end

return Utility