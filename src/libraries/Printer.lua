local Printer = {}

export type Printer = {
    Name: string
}

Printer.New = function(Name)
    local Controller = {
        Name = Name
    }
    
    Controller.Print = function(self, Message, Severity)
        local Name = self.Name
        local Severity = Severity or "Info"
        local Message = Message or "No Message Provided"
        local LogMessage = "[ "..Severity.." ] [ " .. Name .. " ]: " .. Message
        print(LogMessage)
    end

    return Controller
end

return Printer