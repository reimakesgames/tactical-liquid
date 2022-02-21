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

UDP.GetPrivateUserData = function(Player: Player): table
    local PrivateUserData = {}

    Printer:Print("Getting Locale for User...")
    local Locale = LocalizationService:GetCountryRegionForPlayerAsync(Player)
    Printer:Print("Getting Policy for User...")
    local Policy = PolicyService:GetPolicyInfoForPlayerAsync(Player)

    Printer:Print("Packing PrivateUserData...")
    PrivateUserData.Locale = Locale
    PrivateUserData.Policy = Policy
    Printer:Print("Done!", "Task Ended")
    print("exited")

    return PrivateUserData
end

if RunningOnClient then
    Printer:Print("Running on client, Getting LocalPlayer Info Now...", "Task Started")
    LocalPlayer = game:GetService("Players").LocalPlayer
    print("called once lol")
    UDP.MyData = UDP.GetPrivateUserData(LocalPlayer)
else
    Printer:Print("Not running on client, enabling Server-Side UserDataPanel", "Task Altered")
end

return UDP