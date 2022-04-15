--# selene: allow(almost_swapped, divide_by_zero, duplicate_keys, empty_if, global_usage, if_same_then_else, ifs_same_cond, multiple_statements, mismatched_arg_count, parenthese_conditions, roblox_incorrect_color3_new_bounds, roblox_incorrect_roact_usage, shadowing, incorrect_standard_library_use, suspicious_reverse_loop, type_check_inside_call, unbalanced_assignments, undefined_variable, unscoped_variables, unused_variable)
local Expectation = require(script.Expectation)
local TestBootstrap = require(script.TestBootstrap)
local TestEnum = require(script.TestEnum)
local TestPlan = require(script.TestPlan)
local TestPlanner = require(script.TestPlanner)
local TestResults = require(script.TestResults)
local TestRunner = require(script.TestRunner)
local TestSession = require(script.TestSession)
local TextReporter = require(script.Reporters.TextReporter)
local TextReporterQuiet = require(script.Reporters.TextReporterQuiet)
local TeamCityReporter = require(script.Reporters.TeamCityReporter)

local function run(testRoot, callback)
	local modules = TestBootstrap:getModules(testRoot)
	local plan = TestPlanner.createPlan(modules)
	local results = TestRunner.runPlan(plan)

	callback(results)
end

local TestEZ = {
	run = run,

	Expectation = Expectation,
	TestBootstrap = TestBootstrap,
	TestEnum = TestEnum,
	TestPlan = TestPlan,
	TestPlanner = TestPlanner,
	TestResults = TestResults,
	TestRunner = TestRunner,
	TestSession = TestSession,

	Reporters = {
		TextReporter = TextReporter,
		TextReporterQuiet = TextReporterQuiet,
		TeamCityReporter = TeamCityReporter,
	},
}

return TestEZ