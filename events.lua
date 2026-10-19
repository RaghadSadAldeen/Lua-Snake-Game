
local Events = {}

local listeners = {}

-- Subscribe to an event
function Events:subscribe(event, callback)
    if not listeners[event] then
        listeners[event] = {}
    end

    table.insert(listeners[event], callback)
end

-- Notify event listeners
function Events:emit(event, data)
    if listeners[event] then
        for _, callback in ipairs(listeners[event]) do
            callback(data)
        end
    end
end

return Events
