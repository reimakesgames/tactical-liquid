--input panel, handles all input
--just call CreateInputManager and it returns a new input manager
--you can use the input manager to get input from the keyboard and mouse
--reference 

export type Controller = {
    Event: RBXScriptSignal
}

local UserInputService = game:GetService("UserInputService")

local SignalPanel = require(script.Parent.SignalPanel)

local Panel = {}

local function ManageKeyboard(Expected, IgnoreGameProcessedEvent, Input, Processed, Event, InputBegan)
    if IgnoreGameProcessedEvent and Processed then
        return
    end
    if Input.KeyCode == Expected then
        Event:Fire(InputBegan)
    end
end

local function ManageMouse(Expected, IgnoreGameProcessedEvent, Input, Processed, Event, InputBegan)
    if IgnoreGameProcessedEvent and Processed then
        return
    end
    if Input.UserInputType == Expected then
        Event:Fire(InputBegan)
    end
end

Panel.CreateInputListener = function(Expected, IgnoreGameProcessedEvent): Controller
    local ManagesKeyboard = Expected == Enum.UserInputType.Keyboard

    local Obj, Event = SignalPanel.CreateSignal()
    
    local Controller: Controller = {}
    local IB, IE

    Controller.Destroy = function(): nil
        IB:Disconnect()
        IE:Disconnect()
        Obj:Destroy()
    end

    Controller.InputChanged = Event

    IB = UserInputService.InputBegan:Connect(function(Input, Processed)
        if ManagesKeyboard then
            ManageKeyboard(Expected, IgnoreGameProcessedEvent, Input, Processed, Obj, true)
        else
            ManageMouse(Expected, IgnoreGameProcessedEvent, Input, Processed, Obj, true)
        end
    end)

    IE = UserInputService.InputEnded:Connect(function(Input, Processed)
        if ManagesKeyboard then
            ManageKeyboard(Expected, IgnoreGameProcessedEvent, Input, Processed, Obj, false)
        else
            ManageMouse(Expected, IgnoreGameProcessedEvent, Input, Processed, Obj, false)
        end
    end)

    return Controller
end

return Panel