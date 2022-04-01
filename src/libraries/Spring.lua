local ITERATIONS = 8
local SPRING = {}
type SpringObject = {
    Target: Vector3;
    Position: Vector3;
    Velocity: Vector3;

    Mass: number;
    Force: number;
    Damping: number;
    Speed: number;
}

--isChainable
function SPRING:shove(Force: Vector3)
    local X, Y, Z	= Force.X, Force.Y, Force.Z
    if X ~= X or X == math.huge or X == -math.huge then
        X = 0
    end
    if Y ~= Y or Y == math.huge or Y == -math.huge then
        Y = 0
    end
    if Z ~= Z or Z == math.huge or Z == -math.huge then
        Z = 0
    end
    self.Velocity	= self.Velocity + Vector3.new(X, Y, Z)
    return self
end

--isChainable
function SPRING:update(DeltaTime)
    local scaledDeltaTime = math.min(DeltaTime, 1) * self.Speed / ITERATIONS
    for i = 1, ITERATIONS do
        local iterationForce= self.Target - self.Position
        local acceleration	= (iterationForce * self.Force) / self.Mass
        acceleration		= acceleration - self.Velocity * self.Damping
        self.Velocity	= self.Velocity + acceleration * scaledDeltaTime
        self.Position	= self.Position + self.Velocity * scaledDeltaTime
    end
    return self
end

--isChainable
function SPRING.create(Name: string, NewMass: number, NewForce: number, NewDamping: number, NewSpeed: number)
	local spring: SpringObject = {
		Target		= Vector3.new();
		Position	= Vector3.new();
		Velocity	= Vector3.new();

		Mass		= NewMass or 5;
		Force		= NewForce or 50;
		Damping		= NewDamping or 4;
		Speed		= NewSpeed  or 4;
	}
	setmetatable(spring, {__index = SPRING})
    SPRING[Name] = spring
	return spring
end

return SPRING