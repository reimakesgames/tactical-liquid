local AnimatorPanel = {}

function AnimatorPanel.new(AnimatorInstance: Humanoid | AnimationController, Animations: Instance)
    assert(AnimatorInstance and Animations);

    local self = setmetatable(
        {animator = nil, animatorinstance = nil, Animations = {}},
        {__index = AnimatorPanel}
    );

    self.animatorinstance = AnimatorInstance;
    self.animator = AnimatorInstance:FindFirstChild("Animator");

    assert(self.animator);

    for _, anim in pairs(Animations:GetChildren()) do
        if anim:IsA('Animation') then
            self.Animations[anim.Name] = self.animator:LoadAnimation(anim);
        end
    end

    return self;
end

function AnimatorPanel:play(animName, animSpeed)
    assert(animName);

    local anim = self.Animations[animName];

    if (anim) then
        anim:Play();
        anim:AdjustSpeed(animSpeed or 1);
    end
end

function AnimatorPanel:stop(animName)
    assert(animName);

    local anim = self.Animations[animName];

    if (anim) then anim:Stop(); end
end

function AnimatorPanel:stopAll()
    local anims = self.animator:GetPlayingAnimationTracks();

    for _, v in pairs(anims) do v:Stop(); end
end

return AnimatorPanel;
