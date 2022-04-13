--[[

Custodian 1.1.3
This is a heavily modified Maid class.
Modified to be more lightweight.
Custodian:Clean() will clean the values outside of tables.
Custodian:Clean(true) will clean the values of all the tables inside the object but the tables
will still exist inside the object.
Custodian:Destroy() will clean up all the values in all tables and set all tables to nil after.

Written By: Odysseus_Orien / Synthranger#1764 - 01/02/2022

Updates:
  1.0.1 - 1.0.3
    Hotfixes and cleaner code
  1.1.3
    Constructor is now Custodian.new() instead of Custodian()
    Typechecking for autocomplete
    Edited documentation
    Fixed recursive

API:
  local Custodian = require(this.module)
  local newCustodian = Custodian.new()
  newCustodian.someEvent = Event:Connect(func)
  newCustodian.someFunc = function() print("Cleaned!") end

  -- set recursive to true to clean tables inside the custodian
  newCustodian:Clean(true) -- will not set tables inside to nil
  newCustodian:Destroy() -- will set tables to nil

]]

export type Custodian = {
	Clean: (recursive: boolean) -> ();
	Destroy: () -> ();
}

local Custodian = {}

local function CleanupObject(Obj)
	local objType = typeof(Obj)
	if objType == 'function' then
		Obj()
	elseif objType == 'RBXScriptConnection' or Obj.Disconnect then
		Obj:Disconnect()
	elseif objType == 'Instance' or Obj.Destroy then
		Obj:Destroy()
	elseif Obj.destroy then
		Obj:destroy()
	elseif Obj.disconnect then
		Obj:disconnect()
	end
end

local function CleanupTable(Table, Recursive, KeepEmptyTables)
	for Key, Value in pairs(Table) do
		local valueType = typeof(Value)
		if valueType ~= "table" then
			Table[Key] = nil
			CleanupObject(Value)
		elseif Recursive then
			if not KeepEmptyTables then
				Table[Key] = nil
			end
			CleanupTable(Value)
		end
	end
end

function Custodian:Clean(Recursive)
	CleanupTable(self._bin, Recursive, false)
end

function Custodian:Destroy()
	CleanupTable(self._bin, true, true)
end

function Custodian:__index(k)
	return Custodian[k] or self._bin[k]
end

function Custodian:__newindex(k, v)
	if Custodian[k] then
		error(string.format("%s is a class method and cannot be overwritten.", k))
		return
	end

	local OldObj = self._bin[k]
	self._bin[k] = v

	if OldObj then
		CleanupObject(OldObj)
	end
end

function Custodian.new(): Custodian
	local self = {}
	self._bin = {}
	return setmetatable(self, Custodian)
end

return Custodian