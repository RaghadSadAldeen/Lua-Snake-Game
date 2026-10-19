
local SnakeGame = require("snake_game")

local Playing = {}
local game = SnakeGame:new()

function Playing:update(dt)
    game:update(dt)
end

function Playing:draw()
    game:draw()
end

function Playing:changeDirection(dx, dy)
    game:changeDirection(dx, dy)
end

function Playing:isGameOver()
    return game.gameOver
end

function Playing:restart()
    game = SnakeGame:new()
end

return Playing
