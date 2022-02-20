--yes, this is a botched signal module
--require the script and call SignalPanel.CreateSignal() to create a signal
--the bindable event is the thing you can use to destroy
--the other returnee is a RBXScriptSignal

export type Controller = {
    --private
    _BindableEvent: BindableEvent,

    --public
    Event: RBXScriptSignal,
}

local Panel = {}

Panel.CreateSignal = function(): BindableEvent & RBXScriptSignal
    local Controller = {}

    local BindableEvent = Instance.new("BindableEvent")

    Controller._BindableEvent = BindableEvent

    Controller.Event = BindableEvent.Event
    
    Controller.Fire = function(...): nil
        BindableEvent:Fire(...)
    end

    return Controller
end

return Panel