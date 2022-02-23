local PolicyService = game:GetService("PolicyService")
local RunService = game:GetService("RunService")
local LocalizationService = game:GetService("LocalizationService")
local LocalPlayer

local RunningOnClient = RunService:IsClient()

local PrinterModule = require(script.Parent.Printer)
local Printer = PrinterModule.New("UserDataPanel")

local UDP = {
    MyData = nil
}

local function protected(func)
    local success, result = pcall(func)
    if not success then
        Printer.Print(result, "Task Error")
    end
    return result
end

UDP.GetPrivateUserData = function(Player: Player): table
    local PrivateUserData = {}
    local Locale
    local Policy

    repeat
        Printer:Print("Getting Locale for User...")
        Locale = protected(function()
            LocalizationService:GetCountryRegionForPlayerAsync(Player)
        end)
        if not Locale then
            Printer:Print("Failed to get Locale for User, retrying...", "Internal Error")
            task.wait(1)
        end
    until Locale

    repeat
        Printer:Print("Getting Policy for User...")
        Policy = protected(function()
            PolicyService:GetPolicyInfoForPlayerAsync(Player)
        end)
        if not Policy then
            Printer:Print("Failed to get PolicyInfo for User, retrying...", "Internal Error")
            task.wait(1)
        end
    until Policy

    Printer:Print("Packing PrivateUserData...")
    PrivateUserData.Locale = Locale
    PrivateUserData.Policy = Policy
    Printer:Print("Done!", "Task Ended")

    return PrivateUserData
end

if RunningOnClient then
    Printer:Print("Running on client, Getting LocalPlayer Info Now...", "Task Started")
    LocalPlayer = game:GetService("Players").LocalPlayer
    UDP.MyData = UDP.GetPrivateUserData(LocalPlayer)
else
    Printer:Print("Not running on client, enabling Server-Side UserDataPanel", "Task Altered")
end

return UDP