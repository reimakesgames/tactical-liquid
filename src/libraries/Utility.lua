local Debris = game:GetService("Debris")

local Utility = {}

--vector utilities
function Utility.reflect(vector, normal)
    return vector - (2 * vector:Dot(normal)) * normal
end

-- returns a unit vector that's been deviated
function Utility.deviateUnit(vector3: Vector3)
    return (vector3 + (Vector3.new(math.random(-10,10), math.random(-10,10), math.random(-10,10)).Unit * 0.01)).Unit
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

--instance utilities
function Utility.quickInstance(class, properties)
    local instance = Instance.new(class)
    if typeof(properties) == "table" then
        for property, value in pairs(properties) do
            instance[property] = value
        end
    elseif properties ~= nil then
        error("Invalid 2nd argument to quickInstance")
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