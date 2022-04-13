local AnimatorPanel = require(game:GetService("ReplicatedStorage"):WaitForChild("Libraries"):WaitForChild("AnimatorPanel"))

local class = {}

export type ViewmodelSubsystem = {
    Viewmodel: Model;
    Animator: AnimatorPanel.AnimatorPanel;
}

return class