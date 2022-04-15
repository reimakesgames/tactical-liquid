--# selene: allow(almost_swapped, divide_by_zero, duplicate_keys, empty_if, global_usage, if_same_then_else, ifs_same_cond, multiple_statements, mismatched_arg_count, parenthese_conditions, roblox_incorrect_color3_new_bounds, roblox_incorrect_roact_usage, shadowing, incorrect_standard_library_use, suspicious_reverse_loop, type_check_inside_call, unbalanced_assignments, undefined_variable, unscoped_variables, unused_variable)
local TestEnum = require(script.Parent.TestEnum)

local LifecycleHooks = {}
LifecycleHooks.__index = LifecycleHooks

function LifecycleHooks.new()
	local self = {
		_stack = {},
	}
	return setmetatable(self, LifecycleHooks)
end

--[[
	Returns an array of `beforeEach` hooks in FIFO order
]]
function LifecycleHooks:getBeforeEachHooks()
	local key = TestEnum.NodeType.BeforeEach
	local hooks = {}

	for _, level in ipairs(self._stack) do
		for _, hook in ipairs(level[key]) do
			table.insert(hooks, hook)
		end
	end

	return hooks
end

--[[
	Returns an array of `afterEach` hooks in FILO order
]]
function LifecycleHooks:getAfterEachHooks()
	local key = TestEnum.NodeType.AfterEach
	local hooks = {}

	for _, level in ipairs(self._stack) do
		for _, hook in ipairs(level[key]) do
			table.insert(hooks, 1, hook)
		end
	end

	return hooks
end

--[[
	Pushes uncalled beforeAll and afterAll hooks back up the stack
]]
function LifecycleHooks:popHooks()
	table.remove(self._stack, #self._stack)
end

function LifecycleHooks:pushHooksFrom(planNode)
	assert(planNode ~= nil)

	table.insert(self._stack, {
		[TestEnum.NodeType.BeforeAll] = self:_getHooksOfType(planNode.children, TestEnum.NodeType.BeforeAll),
		[TestEnum.NodeType.AfterAll] = self:_getHooksOfType(planNode.children, TestEnum.NodeType.AfterAll),
		[TestEnum.NodeType.BeforeEach] = self:_getHooksOfType(planNode.children, TestEnum.NodeType.BeforeEach),
		[TestEnum.NodeType.AfterEach] = self:_getHooksOfType(planNode.children, TestEnum.NodeType.AfterEach),
	})
end

--[[
	Get the beforeAll hooks from the current level.
]]
function LifecycleHooks:getBeforeAllHooks()
	return self._stack[#self._stack][TestEnum.NodeType.BeforeAll]
end

--[[
	Get the afterAll hooks from the current level.
]]
function LifecycleHooks:getAfterAllHooks()
	return self._stack[#self._stack][TestEnum.NodeType.AfterAll]
end

function LifecycleHooks:_getHooksOfType(nodes, key)
	local hooks = {}

	for _, node in ipairs(nodes) do
		if node.type == key then
			table.insert(hooks, node.callback)
		end
	end

	return hooks
end

return LifecycleHooks
