--yes, this is a botched signal module
--require the script and call SignalPanel.CreateSignal() to create a signal
--the bindable event is the thing you can use to destroy
--the other returnee is a RBXScriptSignal

----DEBUGGER----

----CONFIGURATION----
local config_root = game:GetService("ReplicatedFirst").configuration
local signal_behavior = require(config_root["signal_behavior.cfg"])


----====----====----====----====----====----====----====----====----====----====


----SERVICES----
----DIRECTORIES----

----INTERNAL CLASSES----
export type SignalController = {
    --private
    _BindableEvent: BindableEvent,

    --public
    event: RBXScriptSignal,

    --functions
    fire: (any) -> (nil),
    destroy: (nil) -> (nil),
}

----EXTERNAL CLASSES----
----INTERNAL MODULES----
----EXTERNAL MODULES----
----LIBRARIES----


----====----====----====----====----====----====----====----====----====----====


----VARIABLES----

----FUNCTIONS----
local function newSignal(): SignalController
    local _controller: SignalController = { _enabled = true }

    local bindableEvent = Instance.new("BindableEvent")

    _controller._BindableEvent = bindableEvent
    _controller.event = bindableEvent.event

    _controller.fire = function(...)
        assert(_controller._enabled, "Signal is disposed already")

        bindableEvent:Fire(...)
    end

    _controller.destroy = function()
        assert(_controller._enabled, "Signal is disposed already")

        bindableEvent:Destroy()
        if signal_behavior.allowDisposal then
            _controller._enabled = false
            return
        else
            _controller = nil
        end
    end

    return _controller
end

----CONNECTED FUNCTIONS----


----====----====----====----====----====----====----====----====----====----====


----PUBLIC----
local PANEL = {}

PANEL.newSignal = newSignal

return PANEL
