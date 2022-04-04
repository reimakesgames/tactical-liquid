----DEBUGGER----
----CONFIGURATION----


----====----====----====----====----====----====----====----====----====----====


----SERVICES----
local POLICY_SERVICE = game:GetService("PolicyService")
local RUN_SERVICE = game:GetService("RunService")
local LOCALIZATION_SERVICE = game:GetService("LocalizationService")

----DIRECTORIES----

----INTERNAL CLASSES----
type UserData_Class = {
    __locale: string;
    __policy: {
        [string]: boolean;
    };
}

export type panel = {
    getUserData: (Player) -> (UserData_Class);
}

----EXTERNAL CLASSES----
----INTERNAL MODULES----

----EXTERNAL MODULES----
local printerModule = require(script.Parent.Printer)

----LIBRARIES----


----====----====----====----====----====----====----====----====----====----====


----VARIABLES----
local LOCAL_PLAYER
local Printer = printerModule.new("UserDataPanel")
local runningOnClient = RUN_SERVICE:IsClient()

----FUNCTIONS----
local function protected(func)
    local success, result = pcall(func)
    if not success then
        Printer.Print(result, "Task Error")
    end
    return result
end

local function getUserData(player: Player): UserData_Class | nil
    local _UserData = {}
    local _locale
    local _policy
    local _LAttempts = 0
    local _PAttempts = 0

    repeat
        Printer:Print("Getting Locale for User...")
        _locale = protected(function()
            return LOCALIZATION_SERVICE:GetCountryRegionForPlayerAsync(player)
        end)
        if not _locale then
            Printer:Print("Failed to get Locale for User, retrying...", "Internal Error")
            _LAttempts += 1
            if _LAttempts > 3 then
                Printer:Print("Failed to get Locale for User 3 times, aborting...", "Internal Error")
                break
            end
            task.wait(1)
        end
    until _locale

    repeat
        Printer:Print("Getting Policy for User...")
        _policy = protected(function()
            return POLICY_SERVICE:GetPolicyInfoForPlayerAsync(player)
        end)
        if not _policy then
            Printer:Print("Failed to get PolicyInfo for User, retrying...", "Internal Error")
            _PAttempts += 1
            if _PAttempts > 3 then
                Printer:Print("Failed to get PolicyInfo for User 3 times, aborting...", "Internal Error")
                break
            end
            task.wait(1)
        end
    until _policy

    Printer:Print("Packing UserData...")
    _UserData.__locale = _locale
    _UserData.__policy = _policy
    Printer:Print("Done!", "Task Ended")

    return _UserData
end

----CONNECTED FUNCTIONS----


----====----====----====----====----====----====----====----====----====----====


----PUBLIC----
local PANEL = {
    __myData = nil
}

PANEL.getUserData = getUserData

if runningOnClient then
    Printer:Print("Running on client, Getting LocalPlayer Info Now...", "Task Started")
    LOCAL_PLAYER = game:GetService("Players").LocalPlayer
    PANEL.__myData = PANEL.getUserData(LOCAL_PLAYER)
else
    Printer:Print("Not running on client, enabling Server-Side UserDataPanel", "Task Altered")
end

return PANEL