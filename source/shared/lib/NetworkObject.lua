local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local IsServer = RunService:IsServer()

local NetworkObject = {}
NetworkObject.__index = NetworkObject

local function isSetup(timeout)
	if IsServer then
		if not ReplicatedStorage.TacticalLiquid:FindFirstChild("Sockets") then
			local NetworkObjects = Instance.new("Folder")
			NetworkObjects.Name = "Sockets"
			NetworkObjects.Parent = ReplicatedStorage.TacticalLiquid
		end
		if not ReplicatedStorage.TacticalLiquid:FindFirstChild("Sockets_Cache") then
			local InstanceCache = Instance.new("Folder")
			InstanceCache.Name = "Sockets_Cache"
			InstanceCache.Parent = ReplicatedStorage.TacticalLiquid
		end
	else
		if not ReplicatedStorage.TacticalLiquid:FindFirstChild("Sockets") and timeout then
			ReplicatedStorage.TacticalLiquid:WaitForChild("Sockets", timeout or 5)
		end
	end
end

local function InstanceProvider(name, parent)
	local new = ReplicatedStorage.InstanceCache:FindFirstChildOfClass("RemoteEvent")
	if not new then
		local RemoteEvent = Instance.new("RemoteEvent")
		RemoteEvent.Name = name
		RemoteEvent.Parent = parent
		return RemoteEvent
	else
		new.Name = name
		new.Parent = parent
		return new
	end
end

function NetworkObject:Fire(...)
	table.insert(self._firingQueue, table.pack(...))
end

function NetworkObject:Connect(func)
	local queue = {}
	local RemoteConnection
	local HeartbeatConnection

	local function Disconnect()
		HeartbeatConnection:Disconnect()
		RemoteConnection:Disconnect()
	end

	if IsServer then
		RemoteConnection = self._RemoteEvent.OnServerEvent:Connect(function(plr, ...)
			table.insert(queue, {
				["plr"] = plr,
				["args"] = table.pack(...),
			})
		end)
	else
		RemoteConnection = self._RemoteEvent.OnClientEvent:Connect(function(...)
			table.insert(queue, {
				["args"] = table.pack(...),
			})
		end)
	end

	HeartbeatConnection = RunService.Heartbeat:Connect(function()
		if #queue ~= 0 then
			if IsServer then
				for _, v in pairs(queue) do
					func(table.unpack(v["plr"], v["args"]))
				end
			else
				for _, v in pairs(queue) do
					func(table.unpack(v["args"]))
				end
			end
		end
		queue = {}
	end)
	return {
		Disconnect = Disconnect,
	}
end

function NetworkObject:Destroy()
	self._HeartbeatConnection:Disconnect()
	self._RemoteEvent.Parent = ReplicatedStorage.InstanceCache
	task.spawn(function()
		task.wait(10)
		if self._RemoteEvent.Parent == ReplicatedStorage.InstanceCache then
			self._RemoteEvent:Destroy()
		end
	end)
	setmetatable(self, nil)
end

return {
	new = function(name, timeout)
		local self = setmetatable({}, NetworkObject)
		isSetup(timeout)

		local function FireClient(...)
			self._RemoteEvent:FireServer(...)
		end

		local function FireServer(plrOrAll, ...)
			if plrOrAll == "all" then
				self._RemoteEvent:FireAllClients(...)
			else
				assert(typeof(plrOrAll) == "Instance", "Player must be an instance!")
				assert(plrOrAll:IsA("Player"), "Player must be a PlayerInstance!")

				self._RemoteEvent:FireClient(plrOrAll, ...)
			end
		end

		self.format = nil

		self._firingQueue = {}
		if IsServer then
			self._RemoteEvent = InstanceProvider(name, ReplicatedStorage.NetworkObjects)
		else
			self._RemoteEvent = ReplicatedStorage.NetworkObjects:WaitForChild(name, timeout)
		end
		self._HeartbeatConnection = RunService.Heartbeat:Connect(function()
			if #self._firingQueue ~= 0 then
				if IsServer then
					for _, v in pairs(self._firingQueue) do
						FireServer(table.unpack(v))
					end
				else
					for _, v in pairs(self._firingQueue) do
						FireClient(table.unpack(v))
					end
				end
			end
			self._firingQueue = {}
		end)

		return self
	end,
	setup = isSetup,
}