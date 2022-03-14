--input panel, handles all input
--just call CreateInputManager and it returns a new input manager
--you can use the input manager to get input from the keyboard and mouse
--reference 

export type Controller = {
    Event: RBXScriptSignal
}

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local SignalPanel = require(script.Parent.SignalPanel)

local Panel = {}

local function ManageKeyboard(Expected, IgnoreGameProcessedEvent, Input, Processed, Signal, boolean)
    if IgnoreGameProcessedEvent then
        if Processed then
            return
        end
    end

    if Input.KeyCode == Expected then
        Signal.Fire(Input, boolean)
    end
end

local function ManageMouse(Expected, IgnoreGameProcessedEvent, Input, Processed, Signal, boolean)
    if IgnoreGameProcessedEvent then
        if Processed then
            return
        end
    end

    if Input.UserInputType == Expected then
        Signal.Fire(Input, boolean)
    end
end

Panel.CreateInputListener = function(Expected, IgnoreGameProcessedEvent): Controller
    local ManagesMouse = Expected == Enum.UserInputType.MouseButton1
    or Expected == Enum.UserInputType.MouseButton2
    or Expected == Enum.UserInputType.MouseButton3
    or Expected == Enum.UserInputType.MouseWheel
    or Expected == Enum.UserInputType.MouseMovement

    local Signal = SignalPanel.CreateSignal()
    
    local Controller: Controller = {}
    local IB, IE

    Controller.Destroy = function(): nil
        IB:Disconnect()
        IE:Disconnect()
        Signal:Destroy()
    end

    Controller.InputChanged = Signal.Event

    IB = UserInputService.InputBegan:Connect(function(Input, Processed)
        if ManagesMouse then
            ManageMouse(Expected, IgnoreGameProcessedEvent, Input, Processed, Signal, true)
        else
            ManageKeyboard(Expected, IgnoreGameProcessedEvent, Input, Processed, Signal, true)
        end
    end)

    IE = UserInputService.InputEnded:Connect(function(Input, Processed)
        if ManagesMouse then
            ManageMouse(Expected, IgnoreGameProcessedEvent, Input, Processed, Signal, false)
        else
            ManageKeyboard(Expected, IgnoreGameProcessedEvent, Input, Processed, Signal, false)
        end
    end)

    return Controller
end

return Panel