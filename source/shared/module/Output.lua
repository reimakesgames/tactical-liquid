local Output = {}
Output.__index = Output

export type Printer = {
    name: string;
    Print: (message: string, severity: string) -> (nil);
    Printf: (TEMPLATE: string, ...any) -> (nil)
}

local LOG_TEMPLATE = "[ %s ] [ %s ]: %s"
local format = string.format

function Output:Print(message, severity)
    severity = severity or "Info"
    message = message or "Mga kuwentong hindi kapakapaniwala"
    print(format(LOG_TEMPLATE, severity, self.name, message))
end

function Output:Printf(TEMPLATE, ...)
    print(format(TEMPLATE, ...))
end

function Output.new(name)
    return setmetatable({name = name;}, Output)
end

return Output
