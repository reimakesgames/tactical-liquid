----DEBUGGER----
----CONFIGURATION----


----====----====----====----====----====----====----====----====----====----====


----SERVICES----
local USER_INPUT_SERVICE = game:GetService("UserInputService")

----DIRECTORIES----

----INTERNAL CLASSES----
export type InputController = {
    inputChanged: RBXScriptSignal;
    destroy: () -> ();
}

----EXTERNAL CLASSES----
----INTERNAL MODULES----

----EXTERNAL MODULES----
local signalPanel = require(script.Parent.SignalPanel)

----LIBRARIES----


----====----====----====----====----====----====----====----====----====----====


----VARIABLES----

----FUNCTIONS----
local function filterInput(
        expected: Enum.KeyCode | Enum.UserInputType,
        ignoreGameProcessedEvent: boolean,
        input: InputObject,
        processed: boolean,
        signal: signalPanel.SignalController,
        newState: boolean
    )
    if ignoreGameProcessedEvent then
        if processed then
            return
        end
    end
    if input.KeyCode == expected or input.UserInputType == expected then
    ---@diagnostic disable-next-line: redundant-parameter
        signal:fire(input, newState)
    end
end

local function newInputListener(toListen: Enum.UserInputType | Enum.KeyCode, ignoreGameProcessedEvent): InputController
    local signal = signalPanel.newSignal()
    local inputBegan: RBXScriptConnection, inputEnded: RBXScriptConnection
    local _controller: InputController = {
        inputChanged = signal.Event;
        destroy = function()
            inputBegan:Disconnect()
            inputEnded:Disconnect()
            signal:destroy()
        end;
    }

    inputBegan = USER_INPUT_SERVICE.InputBegan:Connect(function(inputObject, bool)
        filterInput(toListen, ignoreGameProcessedEvent, inputObject, bool, signal, true)
    end)
    inputEnded = USER_INPUT_SERVICE.InputEnded:Connect(function(inputObject, bool)
        filterInput(toListen, ignoreGameProcessedEvent, inputObject, bool, signal, false)
    end)

    return _controller
end

----CONNECTED FUNCTIONS----


----====----====----====----====----====----====----====----====----====----====


----PUBLIC----
local PANEL = {}

PANEL.newInputListener = newInputListener

return PANEL