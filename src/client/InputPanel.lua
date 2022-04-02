----CLASSES----
export type InputController = {
    inputChanged: RBXScriptSignal;
    destroy: () -> ();
}
----SERVICES----
local RUN_SERVICE = game:GetService("RunService")
local USER_INPUT_SERVICE = game:GetService("UserInputService")

----DIRECTORIES----
----EXTERNAL MODULES----
----INTERNAL MODULES----

----LIBRARIES----
local signalPanel = require(script.Parent.SignalPanel)

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
    if input.KeyCode == expected then
    ---@diagnostic disable-next-line: redundant-parameter
        signal.fire(input, newState)
    elseif input.UserInputType == expected then
    ---@diagnostic disable-next-line: redundant-parameter
        signal.fire(input, newState)
    end
end

----VARIABLES----
----FUNCTIONS----
----CONNECTED FUNCTIONS----

----PUBLIC----
local PANEL = {}

PANEL.createInputListener = function(toListen: Enum.UserInputType | Enum.KeyCode, ignoreGameProcessedEvent): Controller
    local signal = signalPanel.createSignal()
    local _controller: InputController = {inputChanged = signal.Event}
    local inputBegan: RBXScriptConnection, inputEnded: RBXScriptConnection

    _controller.destroy = function()
        inputBegan:Disconnect()
        inputEnded:Disconnect()
        signal:destroy()
    end
    inputBegan = USER_INPUT_SERVICE.InputBegan:Connect(function(inputObject, bool)
        filterInput(toListen, ignoreGameProcessedEvent, inputObject, bool, signal, true)
    end)
    inputEnded = USER_INPUT_SERVICE.InputEnded:Connect(function(inputObject, bool)
        filterInput(toListen, ignoreGameProcessedEvent, inputObject, bool, signal, false)
    end)

    return _controller
end

return PANEL