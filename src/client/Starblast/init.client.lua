----DEBUGGER----
----CONFIGURATION----


----====----====----====----====----====----====----====----====----====----====


----SERVICES----
local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")
-- local RUN_SERVICE = game:GetService("RunService")

----DIRECTORIES----
local RunService = game:GetService("RunService")
local LOCAL_PLAYER = game:GetService("Players").LocalPlayer
-- local PLAYER_GUI = LOCAL_PLAYER:WaitForChild("PlayerGui")
local PLAYER_SCRIPTS = LOCAL_PLAYER:WaitForChild("PlayerScripts")
local TACTICAL_LIQUID = REPLICATED_STORAGE:WaitForChild("TacticalLiquid")

----INTERNAL CLASSES----

----EXTERNAL CLASSES----
-- local CLASSES = REPLICATED_STORAGE.Classes

----INTERNAL MODULES----
local weaponsPanel = require(script.WeaponsPanel)
local viewmodelPanel = require(script.ViewmodelPanel)

----EXTERNAL MODULES----
local inputPanel = require(PLAYER_SCRIPTS.TacticalLiquidClient.InputPanel)

local spring = require(TACTICAL_LIQUID.Modules.Spring)

----LIBRARIES----
local UTILITY = require(REPLICATED_STORAGE.Libraries.Utility)



----====----====----====----====----====----====----====----====----====----====


----VARIABLES----
spring.new("cameraRecoil", 5, 50, 4, 4)
local character = LOCAL_PLAYER.Character
LOCAL_PLAYER.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
end)
local camera = workspace.CurrentCamera

local equipped = false
local viewmodels = {}
local firing = false
-- local reloading = false
local cameraRecoil = Vector3.new(0, 0, 0)
local sprayPattern = {
    {X = 0, Y = 0},
    {X = -3, Y = 14},
    {X = -3, Y = 24},
    {X = 7, Y = 54},
    {X = -4, Y = 95},
    {X = 11, Y = 142},
    {X = 20, Y = 193},
    {X = -11, Y = 226},
    {X = -30, Y = 252},
    {X = -71, Y = 265},
    {X = -62, Y = 284},
    {X = -28, Y = 296},
    {X = 26, Y = 290},
    {X = 70, Y = 290},
    {X = 119, Y = 282},
    {X = 119, Y = 287},
    {X = 100, Y = 295},
    {X = 121, Y = 302},
    {X = 147, Y = 295},
    {X = 142, Y = 300},
}

local mouseButton1 = inputPanel.newInputListener(Enum.UserInputType.MouseButton1, true)
local num1 = inputPanel.newInputListener(Enum.KeyCode.One, false)

----FUNCTIONS----
local function fire(_, keyDown)
    if not character then
        firing = false
        return
    end
    firing = keyDown
    if firing then
        -- local cycle = 0
        -- local yep
        -- yep = RunService.RenderStepped:Connect(function(deltaTime)
        --     cycle = cycle + deltaTime
        --     if not firing then
        --         yep:Disconnect()
        --     end
        --     if cycle > 0.1 then
        --         cycle -= 0.1
                
        --         local endPosition = camera.CFrame.Position
        --         if equipped then
        --             endPosition = viewmodels["crappy viewmodel 2"].Viewmodel.Handle.GunFirePoint.WorldPosition
        --         end
        --         weaponsPanel.fire(endPosition, camera.CFrame.LookVector, 512)
        --         UTILITY.clonePlay(workspace:FindFirstChild("FireSound"), workspace)
        --     end
        -- end)
        local bulletsFired = 0
        repeat
            bulletsFired = bulletsFired + 1
            local endPosition = camera.CFrame.Position
            if equipped then
                endPosition = viewmodels["crappy viewmodel 2"].Viewmodel.Handle.GunFirePoint.WorldPosition
            end
            local X = sprayPattern[bulletsFired] or {X = math.random(-150, 150)}
            local Y = sprayPattern[bulletsFired] or sprayPattern[#sprayPattern]
            X = X.X
            Y = Y.Y
            weaponsPanel.fire(endPosition, camera.CFrame.LookVector, 512)
            UTILITY.clonePlay(workspace:FindFirstChild("FireSound"), workspace)
            spring.cameraRecoil
                :Shove(Vector3.new(X, 0, Y))
            task.delay(0, function()
                spring.cameraRecoil
                    :Shove(Vector3.new(-X, 0, -Y))
            end)
            -- cameraRecoil = cameraRecoil + Vector3.new(0.1, 0, 0)
            task.wait(0.1)
        until not firing
    end
end

local function equip(_, keyDown)
    if not character then return end
    if not keyDown then return end
    if equipped then
        equipped = false
        viewmodelPanel.clearActiveViewmodel()
        return
    end
    equipped = true
    if not viewmodels["crappy viewmodel 2"] then
        local something = viewmodelPanel.createViewmodel(TACTICAL_LIQUID:FindFirstChild("crappy viewmodel 2"), "crappy viewmodel 2")
        viewmodels["crappy viewmodel 2"] = something
        print(something)
        print(viewmodels["crappy viewmodel 2"])
    end
    viewmodelPanel.setViewmodel(viewmodels["crappy viewmodel 2"])
end

local function updateSprings(deltaTime)
    spring.cameraRecoil
        :Update(deltaTime)

	cameraRecoil = spring.cameraRecoil.Position * (Vector3.new(0.2, 0.2, 0.2) * Vector3.new(deltaTime, deltaTime, deltaTime))

    -- cameraRecoil = UTILITY.badLerp(cameraRecoil, Vector3.new(0, 0, 0), 0.3)
    camera.CFrame = camera.CFrame * CFrame.Angles(cameraRecoil.Z, -cameraRecoil.X, cameraRecoil.Y)
end

----CONNECTED FUNCTIONS----
mouseButton1.inputChanged:Connect(fire)
num1.inputChanged:Connect(equip)
RunService.RenderStepped:Connect(updateSprings)