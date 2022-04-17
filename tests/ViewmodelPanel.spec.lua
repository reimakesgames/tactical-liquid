local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestEZ = require(ReplicatedStorage.Libraries.TestEZ)
local ViewmodelPanel = require(game.StarterPlayer:WaitForChild("StarterPlayerScripts").TacticalLiquidClient.Starblast.ViewmodelPanel)
local Utility = require(ReplicatedStorage.Libraries.Utility)

local RandomViewmodel = Utility.quickInstance("Model", {})
local Animations = Utility.quickInstance("Configuration", {Name = "Animations", Parent = RandomViewmodel})
local AnimationController = Utility.quickInstance("AnimationController", {Parent = RandomViewmodel})
local Animator = Utility.quickInstance("Animator", {Parent = AnimationController})

return function()
    describe("this ViewmodelPanel", function()
        it("should make a viewmodel", function()
            expect(ViewmodelPanel.createViewmodel(RandomViewmodel)).to.be.ok()
        end)
    end)
end