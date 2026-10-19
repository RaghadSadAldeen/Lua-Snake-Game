
local HighScore = {}

local FILE_NAME = "highscore.txt"

-- Save the highest score
function HighScore:save(score)
    local success, message =
        love.filesystem.write(FILE_NAME, tostring(score))

    if not success then
        print("High score save error: " .. tostring(message))
    end

    return success
end

-- Load the saved high score
function HighScore:load()
    if love.filesystem.getInfo(FILE_NAME) then
        local content = love.filesystem.read(FILE_NAME)
        return tonumber(content) or 0
    end

    return 0
end

return HighScore
