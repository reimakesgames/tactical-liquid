----DEBUGGER----
----CONFIGURATION----


----====----====----====----====----====----====----====----====----====----====


----SERVICES----
local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")
local USER_INPUT_SERVICE = game:GetService("UserInputService")

----DIRECTORIES----

----INTERNAL CLASSES----
export type InputController = {
    Event: any;
    Destroy: () -> ();
}

----EXTERNAL CLASSES----
----INTERNAL MODULES----
----EXTERNAL MODULES----

----LIBRARIES----
local GoodSignal = require(REPLICATED_STORAGE.Libraries.GoodSignal)



----====----====----====----====----====----====----====----====----====----====


----VARIABLES----

----FUNCTIONS----
local function filterInput(
        expected: Enum.KeyCode | Enum.UserInputType,
        ignoreGameProcessedEvent: boolean,
        input: InputObject,
        processed: boolean,
        signal,
        newState: boolean
    )
    if ignoreGameProcessedEvent then
        if processed then
            return
        end
    end
    if input.KeyCode == expected or input.UserInputType == expected then
        signal:Fire(newState)
    end
end

local function newInputListener(toListen: Enum.UserInputType | Enum.KeyCode, ignoreGameProcessedEvent): InputController
    local signal = GoodSignal.new()
    local inputBegan: RBXScriptConnection, inputEnded: RBXScriptConnection
    local _controller: InputController = {
        Event = signal;
        Destroy = function()
            inputBegan:Disconnect()
            inputEnded:Disconnect()
            signal:DisconnectAll()
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

local function bindToInputBegan(toListen: Enum.UserInputType | Enum.KeyCode, ignoreGameProcessedEvent): InputController
    local signal = GoodSignal.new()
    local inputBegan: RBXScriptConnection
    local _controller: InputController = {
        Event = signal;
        Destroy = function()
            inputBegan:Disconnect()
            signal:DisconnectAll()
        end;
    }

    inputBegan = USER_INPUT_SERVICE.InputBegan:Connect(function(inputObject, bool)
        filterInput(toListen, ignoreGameProcessedEvent, inputObject, bool, signal, true)
    end)

    return _controller
end

local function bindToInputEnded(toListen: Enum.UserInputType | Enum.KeyCode, ignoreGameProcessedEvent): InputController
    local signal = GoodSignal.new()
    local inputEnded: RBXScriptConnection
    local _controller: InputController = {
        Event = signal;
        Destroy = function()
            inputEnded:Disconnect()
            signal:DisconnectAll()
        end;
    }

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
PANEL.bindToInputBegan = bindToInputBegan
PANEL.bindToInputEnded = bindToInputEnded

return PANEL