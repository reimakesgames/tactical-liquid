local PRINTER = {}

export type Printer = {
    name: string;
    print: (self: Printer, message: string, severity: string) -> ()
}

function PRINTER.new(name)
    local _printer: Printer = {
        name = name;
        print = function(_--[[self: Printer]], message: string, severity: string)
            severity = severity or "Info"
            message = message or "No Message Provided"
            local logMessage = "[ "..severity.." ] [ " .. name .. " ]: " .. message
            print(logMessage)
        end;
    }

    return _printer
end

return PRINTER