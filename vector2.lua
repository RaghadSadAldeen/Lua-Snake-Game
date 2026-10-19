
local Vector2 = {}
Vector2.__index = Vector2

-- Create a new Vector2 object
function Vector2:new(x, y)
    return setmetatable({
        x = x or 0,
        y = y or 0
    }, Vector2)
end

-- Add two vectors
function Vector2:__add(other)
    return Vector2:new(
        self.x + other.x,
        self.y + other.y
    )
end

-- Compare two vectors
function Vector2:__eq(other)
    return self.x == other.x
       and self.y == other.y
end

-- Convert vector to string
function Vector2:__tostring()
    return "(" .. self.x .. ", " .. self.y .. ")"
end

return Vector2
