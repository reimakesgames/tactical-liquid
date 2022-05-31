local AnimatorPanel = require(game:GetService("ReplicatedStorage"):WaitForChild("TacticalLiquid"):WaitForChild("Modules"):WaitForChild("AnimatorPanel"))

local class = {}

export type ViewmodelSubsystem = {
    Viewmodel: Model;
    Animator: AnimatorPanel.AnimatorPanel;
}

return class