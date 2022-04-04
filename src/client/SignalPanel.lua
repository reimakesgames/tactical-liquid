--yes, this is a botched signal module
--require the script and call SignalPanel.CreateSignal() to create a signal
--the bindable event is the thing you can use to destroy
--the other returnee is a RBXScriptSignal

----DEBUGGER----

----CONFIGURATION----
local config_root = game:GetService("ReplicatedFirst").Configuration
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
    fire: (SignalController, ...any?) -> (nil),
    destroy: (nil) -> (nil),
}

----EXTERNAL CLASSES----
----INTERNAL MODULES----
----EXTERNAL MODULES----
----LIBRARIES----


----====----====----====----====----====----====----====----====----====----====


----VARIABLES----

----FUNCTIONS----
local function newSignal(): SignalController?
    local bindableEvent = Instance.new("BindableEvent")
    local cleanUp = Instance.new("BindableEvent")
    local enabled = true

    local _controller: SignalController? = {
        _BindableEvent = bindableEvent;
        event = bindableEvent.event;
        fire = function(self, ...: any?)
            assert(enabled, "Signal is disposed already")

            bindableEvent:Fire(...)
        end;
        destroy = function()
            assert(enabled, "Signal is disposed already")

            bindableEvent:Destroy()
            if signal_behavior.allowDisposal then
                enabled = false
                return
            else
                cleanUp:Fire()
            end
        end;
    }

    if not signal_behavior.allowDisposal then
        cleanUp.Event:Connect(function()
            _controller = nil
            cleanUp:Destroy()
        end)
    end

    return _controller
end

----CONNECTED FUNCTIONS----


----====----====----====----====----====----====----====----====----====----====


----PUBLIC----
local PANEL = {}

PANEL.newSignal = newSignal

return PANEL
