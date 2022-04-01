--yes, this is a botched signal module
--require the script and call SignalPanel.CreateSignal() to create a signal
--the bindable event is the thing you can use to destroy
--the other returnee is a RBXScriptSignal

export type SignalController = {
    --private
    _BindableEvent: BindableEvent,

    --public
    Event: RBXScriptSignal,

    --functions
    fire: (any) -> (nil),
    destroy: (nil) -> (nil),
}

local PANEL = { allowDisposal = false }

PANEL.createSignal = function(): Controller
    local controller: Controller = { _enabled = true }

    local BINDABLE_EVENT = Instance.new("BindableEvent")

    controller._BindableEvent = BINDABLE_EVENT
    controller.Event = BINDABLE_EVENT.Event

    controller.fire = function(...)
        assert(controller._enabled, "Signal is disposed already")

        BINDABLE_EVENT:Fire(...)
    end

    controller.destroy = function()
        assert(controller._enabled, "Signal is disposed already")

        BINDABLE_EVENT:Destroy()
        if PANEL.allowDisposal then
            controller._enabled = false
            return
        else
            controller = nil
        end
    end

    return controller
end

return PANEL