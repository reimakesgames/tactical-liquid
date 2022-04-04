local PANEL = {}

function PANEL.new(AnimatorInstance: Humanoid | AnimationController, Animations: Folder | Configuration)
    assert(AnimatorInstance and Animations);

    local self = setmetatable(
        {Animator = nil, AnimatorInstance = nil, Animations = {}},
        {__index = PANEL}
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

function PANEL:play(AnimationName, AnimationSpeed)
    assert(AnimationName);

    local Animation = self.Animations[AnimationName];

    if (Animation) then
        Animation:Play();
        Animation:AdjustSpeed(AnimationSpeed or 1);
    end
end

function PANEL:adjustWeight(AnimationName, Weight)
    assert(AnimationName);

    local Animation = self.Animations[AnimationName];

    if (Animation) then
        Animation:AdjustWeight(Weight);
    end
end

function PANEL:stop(AnimationName)
    assert(AnimationName);

    local Animation = self.Animations[AnimationName];
    if (Animation) then Animation:Stop(); end
end

function PANEL:stopAll()
    local anims = self.AnimatorInstance:GetPlayingAnimationTracks();
    for _, _PlayingAnimations in pairs(anims) do _PlayingAnimations:Stop(); end
end

return PANEL;
