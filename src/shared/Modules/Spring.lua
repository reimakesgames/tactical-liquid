export type Spring = {
	Target: Vector3;
	Position: Vector3;
	Velocity: Vector3;

	Mass: number;
	Force: number;
	Damping: number;
	Speed: number;

	Shove: (force: Vector3) -> (Spring);
	Update: (deltaTime: number) -> (Spring);
}

local ITERATIONS = 8

-- GOTTA GO FAST
local v3 = Vector3.new
local min, _ = math.min, math.max
local huge = math.huge

local Spring = {}
Spring.__index = Spring

local function unmathhuge(num: number)
	if num == huge or num == -huge then
		return 0
	end
	return num
end

function Spring.Shove(self: Spring, force: Vector3): Spring
	local x = unmathhuge(force.X)
	local y = unmathhuge(force.Y)
	local z = unmathhuge(force.Z)
	self.Velocity = self.Velocity + v3(x, y, z)
	return self
end

function Spring.Update(self: Spring, deltaTime: number): Spring
	local scaledDeltaTime = min(deltaTime, 1) * self.Speed / ITERATIONS
	for _ = 1, ITERATIONS do
		local iterationForce = self.Target - self.Position
		local acceleration = (iterationForce * self.Force) / self.Mass
		acceleration = acceleration - self.Velocity * self.Damping
		self.Velocity = self.Velocity + acceleration * scaledDeltaTime
		self.Position = self.Position + self.Velocity * scaledDeltaTime
	end
	return self
end

function Spring.new(name, mass: number, force: number, damping: number, speed: number): Spring
	local self = setmetatable({
		Target = v3();
		Position = v3();
		Velocity = v3();

		Mass = mass or 5;
		Force = force or 50;
		Damping = damping or 4;
		Speed = speed  or 4;
	}, Spring)
    Spring[name] = self
	return self
end

return Spring