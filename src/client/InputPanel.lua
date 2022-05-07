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
local KeyDownInputs = {}
local KeyUpInputs = {}

----FUNCTIONS----
local function MakeBindForKeyDown(Key: Enum.UserInputType | Enum.KeyCode, IgnoreGPE: boolean, Callback)
    KeyDownInputs[Key] = KeyDownInputs[Key] or {GoodSignal.new(), GoodSignal.new()}
    (IgnoreGPE and KeyDownInputs[Key][1] or KeyDownInputs[Key][2]):Connect(Callback)
end

local function MakeBindForKeyUp(Key: Enum.UserInputType | Enum.KeyCode, IgnoreGPE: boolean, Callback)
    KeyUpInputs[Key] = KeyUpInputs[Key] or {GoodSignal.new(), GoodSignal.new()}
    (IgnoreGPE and KeyUpInputs[Key][1] or KeyUpInputs[Key][2]):Connect(Callback)
end

local function MakeBindForKeyInput(Key: Enum.UserInputType | Enum.KeyCode, IgnoreGPE: boolean, Callback)
    MakeBindForKeyDown(Key, IgnoreGPE, Callback)
    MakeBindForKeyUp(Key, IgnoreGPE, Callback)
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
    RunInputConnections(Input, IsProcessed, true, KeyDownInputs)
end)

UserInputService.InputEnded:Connect(function(Input, IsProcessed)
    RunInputConnections(Input, IsProcessed, false, KeyUpInputs)
end)

----====----====----====----====----====----====----====----====----====----====

----PUBLIC----
local Panel = {}

Panel.MakeBindForKeyDown = MakeBindForKeyDown
Panel.MakeBindForKeyUp = MakeBindForKeyUp
Panel.MakeBindForKeyInput = MakeBindForKeyInput

return Panel