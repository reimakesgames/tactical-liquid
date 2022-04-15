local TestEZ = require(script.Parent.TestEZ)

return function()
    local Utility = require(script.Parent.Utility)

    describe("utility", function()
        it("should add two numbers", function()
            expect(Utility.addition(1, 2)).to.equal(3)
        end)

        it("should multiply two numbers", function()
            expect(Utility.multiplication(1, 2)).to.equal(2)
        end)
    end)
end