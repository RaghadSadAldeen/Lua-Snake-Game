
local HighScore = require("highscore")

print("Testing Lua 5.4 High Score")

local oldScore = HighScore:load()
print("Previous High Score: " .. oldScore)

local newScore = 25

if newScore > oldScore then
    HighScore:save(newScore)
end

local savedScore = HighScore:load()
print("Saved High Score: " .. savedScore)
