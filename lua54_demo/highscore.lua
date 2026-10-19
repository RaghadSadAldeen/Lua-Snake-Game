
local HighScore = {}

local FILE_NAME = "highscore.txt"

-- Lua 5.4 feature:
-- <close> automatically closes a file
-- when the variable goes out of scope.

function HighScore:save(score)
    local file <close> = assert(
        io.open(FILE_NAME, "w")
    )

    file:write(tostring(score))
end

function HighScore:load()
    local file <close> = io.open(FILE_NAME, "r")

    if file then
        local content = file:read("*a")
        return tonumber(content) or 0
    end

    return 0
end

return HighScore
