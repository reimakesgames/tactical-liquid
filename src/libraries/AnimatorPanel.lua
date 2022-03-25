local AnimatorPanel = {}

function AnimatorPanel.New(AnimatorInstance: Humanoid | AnimationController, Animations: Folder | Configuration)
    assert(AnimatorInstance and Animations);

    local self = setmetatable(
        {Animator = nil, AnimatorInstance = nil, Animations = {}},
        {__index = AnimatorPanel}
    );

    self.AnimatorInstance = AnimatorInstance;
    self.Animator = AnimatorInstance:FindFirstChild("Animator");

    assert(self.Animator);

    for _, _Animation in pairs(Animations:GetChildren()) do
        if _Animation:IsA('Animation') then
            self.Animations[_Animation.Name] = self.Animator:LoadAnimation(_Animation);
        end
    end

    return self;
end

function AnimatorPanel:Play(AnimationName, AnimationSpeed)
    assert(AnimationName);

    local Animation = self.Animations[AnimationName];

    if (Animation) then
        Animation:Play();
        Animation:AdjustSpeed(AnimationSpeed or 1);
    end
end

function AnimatorPanel:AdjustWeight(AnimationName, Weight)
    assert(AnimationName);

    local Animation = self.Animations[AnimationName];

    if (Animation) then
        Animation:AdjustWeight(Weight);
    end
end

function AnimatorPanel:Stop(AnimationName)
    assert(AnimationName);

    local Animation = self.Animations[AnimationName];
    if (Animation) then Animation:Stop(); end
end

function AnimatorPanel:StopAll()
    local anims = self.animator:GetPlayingAnimationTracks();
    for _, _PlayingAnimations in pairs(anims) do _PlayingAnimations:Stop(); end
end

return AnimatorPanel;
