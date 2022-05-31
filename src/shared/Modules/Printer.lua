local PRINTER = {}

export type Printer = {
    name: string;
    print: (message: string, severity: string) -> (nil)
}

local LOG_TEMPLATE = "[ %s ] [ %s ]: %s"
local format = string.format

function PRINTER:print(message, severity)
    severity = severity or "Info"
    message = message or "Mga kuwentong hindi kapakapaniwala"
    print(format(LOG_TEMPLATE, severity, self.name, message))
end

function PRINTER.new(name)
    local _printer: Printer = setmetatable({name = name;}, PRINTER)
    return _printer
end

return PRINTER