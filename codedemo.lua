local unused_variable: string = "the quick brown fox jumps over the lazy dog"
local used_variable: string = "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG"
local fake: string = 245612
local CONST = 123456789
local function func(a: number, b: number, c: number): string
    return a + b * c
end
print(func(CONST, 1, 1))
--comment
--[[
    multi
    line
    comment
]]