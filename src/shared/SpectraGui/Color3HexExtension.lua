local floor = math.floor

return setmetatable({
	fromInt = function(int)
        return Color3.fromRGB(floor(int/256^2)%256,floor(int/256)%256,floor(int)%256)
    end,

    toHex = function(c3)
        local R = string.format("%X", floor(c3.R*255))
        local G = string.format("%X", floor(c3.G*255))
        local B = string.format("%X", floor(c3.B*255))
        return "#"..(R:len()==1 and "0"..R or R)..(G:len()==1 and "0"..G or G)..(B:len()==1 and "0"..B or B)
    end
}, {__index = Color3})
