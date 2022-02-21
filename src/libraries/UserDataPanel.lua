local PolicyService = game:GetService("PolicyService")
local RunService = game:GetService("RunService")
local LocalizationService = game:GetService("LocalizationService")
local LocalPlayer

local RunningOnClient = RunService:IsClient()

local UDP = {}

UDP.GetPrivateUserData = function(Player: Player): table
    local PrivateUserData = {}

    print("[UserDataPanel] Getting Locale for User...")
    local Locale = LocalizationService:GetCountryRegionForPlayerAsync(Player)
    print("[UserDataPanel] Getting Policy for User...")
    local Policy = PolicyService:GetPolicyInfoForPlayerAsync(Player)

    print("[UserDataPanel] Packing PrivateUserData...")
    PrivateUserData.Locale = Locale
    PrivateUserData.Policy = Policy
    print("[UserDataPanel] Done!")
    
    return PrivateUserData
end

if RunningOnClient then
    print("[UserDataPanel] Running on client, Getting LocalPlayer Info Now...")
    LocalPlayer = game:GetService("Players").LocalPlayer
    PrivateUserData = UDP.GetPrivateUserData(LocalPlayer)
else
    print("[UserDataPanel] Not running on client, enabling Server-Side UserDataPanel")
end

return UDP