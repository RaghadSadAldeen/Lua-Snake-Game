
local Input = {}
Input.__index = Input

-- Create input manager
function Input:new()
    local input = {
        commands = {}
    }

    return setmetatable(input, Input)
end

-- Connect a key to a command
function Input:bind(key, command)
    self.commands[key] = command
end

-- Execute the command for a pressed key
function Input:handleKey(key)
    local command = self.commands[key]

    if command then
        command()
    end
end

return Input
