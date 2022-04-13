local PANEL = {}

export type AnimatorPanel = {
    New: (AnimatorInstance: Humanoid | AnimationController, Animations: Folder) -> AnimatorPanel;
    Play: (AnimationName: string, AnimationSpeed: number) -> nil;
    AdjustWeight: (AnimationName: string, Weight: number) -> nil;
    Stop: (AnimationName: string) -> nil;
    StopAll: () -> nil;
}

function PANEL.New(AnimatorInstance: Humanoid | AnimationController, Animations: Folder | Configuration)
    assert(AnimatorInstance and Animations, "AnimatorPanel: AnimatorInstance and Animations are required");

    local self = setmetatable(
        {Animator = nil, AnimatorInstance = nil, Animations = {}},
        {__index = PANEL}
    );

    self.AnimatorInstance = AnimatorInstance;
    self.Animator = AnimatorInstance:FindFirstChild("Animator");

    assert(self.Animator, "AnimatorPanel: Animator is required");

    for _, _Animation in pairs(Animations:GetChildren()) do
        if _Animation:IsA('Animation') then
            self.Animations[_Animation.Name] = self.Animator:LoadAnimation(_Animation);
        end
    end

    return self;
end

function PANEL:Play(AnimationName, AnimationSpeed)
    assert(AnimationName, "AnimatorPanel: AnimationName is required");

    local Animation = self.Animations[AnimationName];

    if (Animation) then
        Animation:Play();
        Animation:AdjustSpeed(AnimationSpeed or 1);
    end
end

function PANEL:AdjustWeight(AnimationName, Weight)
    assert(AnimationName, "AnimatorPanel: AnimationName is required");

    local Animation = self.Animations[AnimationName];

    if (Animation) then
        Animation:AdjustWeight(Weight);
    end
end

function PANEL:Stop(AnimationName)
    assert(AnimationName, "AnimatorPanel: AnimationName is required");

    local Animation = self.Animations[AnimationName];
    if (Animation) then
        Animation:Stop()
    end
end

function PANEL:StopAll()
    local anims = self.AnimatorInstance:GetPlayingAnimationTracks();
    for _, _PlayingAnimations in pairs(anims) do
        _PlayingAnimations:Stop()
    end
end

return PANEL;
