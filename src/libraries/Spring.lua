-- Constants

local ITERATIONS	= 8

-- Module

local SPRING	= {}

-- Functions
function SPRING:Shove(force)
    local x, y, z	= force.X, force.Y, force.Z

    if x ~= x or x == math.huge or x == -math.huge then
        x	= 0
    end
    if y ~= y or y == math.huge or y == -math.huge then
        y	= 0
    end
    if z ~= z or z == math.huge or z == -math.huge then
        z	= 0
    end

    self.Velocity	= self.Velocity + Vector3.new(x, y, z)
end

function SPRING:Update(dt)
    local scaledDeltaTime = math.min(dt,1) * self.Speed / ITERATIONS

    for i = 1, ITERATIONS do
        local iterationForce= self.Target - self.Position
        local acceleration	= (iterationForce * self.Force) / self.Mass

        acceleration		= acceleration - self.Velocity * self.Damping

        self.Velocity	= self.Velocity + acceleration * scaledDeltaTime
        self.Position	= self.Position + self.Velocity * scaledDeltaTime
    end

    return self.Position
end

function SPRING.Create(NewMass, NewForce, NewDamping, NewSpeed)
	local spring	= {
		Target		= Vector3.new();
		Position	= Vector3.new();
		Velocity	= Vector3.new();

		Mass		= NewMass or 5;
		Force		= NewForce or 50;
		Damping		= NewDamping or 4;
		Speed		= NewSpeed  or 4;
	}

	setmetatable(spring, {__index = SPRING})

	return spring
end

-- Return

return SPRING