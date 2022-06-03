local Printer = {}

export type Printer = {
    name: string;
    Print: (message: string, severity: string) -> (nil)
}

local LOG_TEMPLATE = "[ %s ] [ %s ]: %s"
local format = string.format

function Printer:Print(message, severity)
    severity = severity or "Info"
    message = message or "Mga kuwentong hindi kapakapaniwala"
    print(format(LOG_TEMPLATE, severity, self.name, message))
end

function Printer.new(name)
    return setmetatable({name = name;}, Printer)
end

return Printer
