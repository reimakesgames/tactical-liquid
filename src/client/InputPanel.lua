--input panel, handles all input
--just call CreateInputManager and it returns a new input manager
--you can use the input manager to get input from the keyboard and mouse
--reference 

export type InputController = {
    inputChanged: RBXScriptSignal;
    Destroy: () -> ();
}

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local SignalPanel = require(script.Parent.SignalPanel)

local PANEL = {}

local function manageKeyboard(Expected, IgnoreGameProcessedEvent, Input, Processed, Signal, boolean)
    if IgnoreGameProcessedEvent then
        if Processed then
            return
        end
    end

    if Input.KeyCode == Expected then
        Signal.Fire(Input, boolean)
    end
end

local function manageMouse(Expected, IgnoreGameProcessedEvent, Input, Processed, Signal, boolean)
    if IgnoreGameProcessedEvent then
        if Processed then
            return
        end
    end

    if Input.UserInputType == Expected then
        Signal.Fire(Input, boolean)
    end
end

PANEL.createInputListener = function(Expected: Enum.UserInputType | Enum.KeyCode, IgnoreGameProcessedEvent): Controller
    local ManagesMouse = Expected == Enum.UserInputType.MouseButton1
    or Expected == Enum.UserInputType.MouseButton2
    or Expected == Enum.UserInputType.MouseButton3
    or Expected == Enum.UserInputType.MouseWheel
    or Expected == Enum.UserInputType.MouseMovement

    local Signal = SignalPanel.createSignal()
    
    local Controller: Controller = {inputChanged = Signal.Event}
    local IB, IE

    Controller.Destroy = function()
        IB:Disconnect()
        IE:Disconnect()
        Signal:Destroy()
    end

    print(Controller)

    IB = UserInputService.InputBegan:Connect(function(Input, Processed)
        if ManagesMouse then
            manageMouse(Expected, IgnoreGameProcessedEvent, Input, Processed, Signal, true)
        else
            manageKeyboard(Expected, IgnoreGameProcessedEvent, Input, Processed, Signal, true)
        end
    end)

    IE = UserInputService.InputEnded:Connect(function(Input, Processed)
        if ManagesMouse then
            manageMouse(Expected, IgnoreGameProcessedEvent, Input, Processed, Signal, false)
        else
            manageKeyboard(Expected, IgnoreGameProcessedEvent, Input, Processed, Signal, false)
        end
    end)

    return Controller
end

return PANEL