local PRINTER = {}

export type Printer = {
    name: string;
    print: (message: string, severity: string) -> (nil)
}

function PRINTER.new(name)
    local _printer: Printer = {
        name = name;
        print = function(self, message, severity)
            severity = severity or "Info"
            message = message or "No Message Provided"
            local logMessage = "[ "..severity.." ] [ " .. name .. " ]: " .. message
            print(logMessage)
        end
    }

    return _printer
end

return PRINTER