--# selene: allow(almost_swapped, divide_by_zero, duplicate_keys, empty_if, global_usage, if_same_then_else, ifs_same_cond, multiple_statements, mismatched_arg_count, parenthese_conditions, roblox_incorrect_color3_new_bounds, roblox_incorrect_roact_usage, shadowing, incorrect_standard_library_use, suspicious_reverse_loop, type_check_inside_call, unbalanced_assignments, undefined_variable, unscoped_variables, unused_variable)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestEZ = require(ReplicatedStorage.Libraries.TestEZ)

return function()
    local Utility = require(ReplicatedStorage.Libraries.Utility)

    describe("utility", function()
        it("should add two numbers", function()
            expect(Utility.addition(1, 2)).to.equal(3)
        end)

        it("should multiply two numbers", function()
            expect(Utility.multiplication(1, 2)).to.equal(2)
        end)
    end)
end