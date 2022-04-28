----DEBUGGER----
----CONFIGURATION----

----====----====----====----====----====----====----====----====----====----====

----SERVICES----
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

----DIRECTORIES----
----INTERNAL CLASSES----
----EXTERNAL CLASSES----
----INTERNAL MODULES----
----EXTERNAL MODULES----

----LIBRARIES----
local GoodSignal = require(ReplicatedStorage.Libraries.GoodSignal)

----====----====----====----====----====----====----====----====----====----====

----VARIABLES----
local NormalInputs = {}
local KeyDownInputs = {}
local KeyUpInputs = {}

----FUNCTIONS----
local function MakeBindFor(Key: Enum.UserInputType | Enum.KeyCode, IgnoreGPE: boolean, InputType: number, Func)
    --! INPUT TYPE 0 = NORMAL
    --! INPUT TYPE 1 = KEY DOWN
    --! INPUT TYPE 2 = KEY UP
    local Pointer
    if InputType == 0 then
        Pointer = Pointer
    elseif InputType == 1 then
        Pointer = KeyDownInputs
    elseif InputType == 2 then
        Pointer = KeyUpInputs
    else
        error("Invalid InputType Parameter (" .. tostring(Key) .. ")")
    end
    --[[
        Makes a bind for a key.
        Key: The key to bind to.
        IgnoreGPE: Whether or not to ignore the GPE.
        Func: The function to call when the key is pressed.

        The Inputs[Key] table is used to store two Signals
        !1. fires ONLY if the input IS NOT PROCESSED
        !2. fires normally if the input IS PROCESSED or NOT
    ]]
    Pointer[Key] = Pointer[Key] or {GoodSignal.new(), GoodSignal.new()}
    (IgnoreGPE and Pointer[Key][1] or Pointer[Key][2]):Connect(Func)
end

local function RunInputConnections(Input, IsProcessed, IsDown, Pointer)
    for Key, Signal in pairs(Pointer) do
        if Input.KeyCode == Key or Input.UserInputType == Key then
            (IsProcessed and Signal[2] or Signal[1]):Fire(IsDown)
        end
    end
end

----CONNECTED FUNCTIONS----
UserInputService.InputBegan:Connect(function(Input, IsProcessed)
    RunInputConnections(Input, IsProcessed, true, NormalInputs)
    RunInputConnections(Input, IsProcessed, true, KeyDownInputs)
end)

UserInputService.InputEnded:Connect(function(Input, IsProcessed)
    RunInputConnections(Input, IsProcessed, false, NormalInputs)
    RunInputConnections(Input, IsProcessed, false, KeyUpInputs)
end)

----====----====----====----====----====----====----====----====----====----====

----PUBLIC----
local Panel = {}

Panel.MakeBindFor = MakeBindFor

return Panel