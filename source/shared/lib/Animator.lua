local Animator = {}

export type Animator = {
    New: (AnimatorInstance: Humanoid | AnimationController, Animations: Folder) -> Animator;
    Play: (AnimationName: string, AnimationSpeed: number) -> nil;
    AdjustWeight: (AnimationName: string, Weight: number) -> nil;
    Stop: (AnimationName: string) -> nil;
    StopAll: () -> nil;
}

function Animator.new(AnimatorInstance: Humanoid | AnimationController, Animations: Folder | Configuration)
    assert(AnimatorInstance and Animations, "AnimatorInstance and Animations are required");

    local self = setmetatable(
        {Animator = nil, AnimatorInstance = nil, Animations = {}},
        {__index = Animator}
    );

    self.AnimatorInstance = AnimatorInstance;
    self.Animator = AnimatorInstance:FindFirstChild("Animator");

    assert(self.Animator, "Animator is required");

    for _, _Animation in pairs(Animations:GetChildren()) do
        if _Animation:IsA('Animation') then
            self.Animations[_Animation.Name] = self.Animator:LoadAnimation(_Animation);
        end
    end

    return self;
end

function Animator:Play(AnimationName, AnimationSpeed)
    assert(AnimationName, "AnimationName is required");

    local Animation = self.Animations[AnimationName];

    if (Animation) then
        Animation:Play();
        Animation:AdjustSpeed(AnimationSpeed or 1);
    end
end

function Animator:AdjustWeight(AnimationName, Weight)
    assert(AnimationName, "AnimationName is required");

    local Animation = self.Animations[AnimationName];

    if (Animation) then
        Animation:AdjustWeight(Weight);
    end
end

function Animator:Stop(AnimationName)
    assert(AnimationName, "AnimationName is required");

    local Animation = self.Animations[AnimationName];
    if (Animation) then
        Animation:Stop()
    end
end

function Animator:StopAll()
    local anims = self.AnimatorInstance:GetPlayingAnimationTracks();
    for _, _PlayingAnimations in pairs(anims) do
        _PlayingAnimations:Stop()
    end
end

return Animator;
