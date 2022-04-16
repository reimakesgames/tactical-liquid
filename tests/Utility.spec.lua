--# selene: allow(almost_swapped, divide_by_zero, duplicate_keys, empty_if, global_usage, if_same_then_else, ifs_same_cond, multiple_statements, mismatched_arg_count, parenthese_conditions, roblox_incorrect_color3_new_bounds, roblox_incorrect_roact_usage, shadowing, incorrect_standard_library_use, suspicious_reverse_loop, type_check_inside_call, unbalanced_assignments, undefined_variable, unscoped_variables, unused_variable)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

return function()
    local Utility = require(ReplicatedStorage.Libraries.Utility)

    describe("utility instances", function()
        it("should create a new part with 2nd param as nil", function()
            local instance = Utility.quickInstance("Part")

            expect(instance).to.be.ok()
            expect(instance.ClassName).to.equal("Part")
        end)

        it("should create a new part regardless of 2nd parameter", function()
            local instance = Utility.quickInstance("Part", {})

            expect(instance).to.be.ok()
            expect(instance.ClassName).to.equal("Part")
        end)

        it("should halt if 2nd parameter isn't a table", function()
            expect(function()
                Utility.quickInstance("Part", "")
            end).to.throw()
        end)
    end)



    describe("utility assertions", function()
        it("should assert type", function()
            local instance = Instance.new("Part")

            expect(Utility.assertType(instance, "Part")).to.equal(true)
            expect(Utility.assertType(instance, "Model")).to.equal(false)
        end)

        it("should halt if provided with a non-instance", function()
            expect(function()
                Utility.assertType("", "Model")
            end).to.throw()

            expect(function()
                Utility.assertType({}, "Model")
            end).to.throw()
        end)

        it("should assert custom type", function()
            local instance = {
                ClassName = "JoeBiden",
                IsA = function(self, className)
                    return self.ClassName == className
                end
            }

            expect(Utility.assertType(instance, "JoeBiden")).to.equal(true)
        end)
    end)
end