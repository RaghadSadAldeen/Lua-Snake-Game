
local GameState = require("gamestate")
local Input = require("input")
local Events = require("events")

local gameState = GameState:new()
local input = Input:new()

function love.load()
    love.window.setMode(600, 600)
    love.window.setTitle("Snake Game")

    local playing = gameState.states.playing

    -- Observe food events
    Events:subscribe("food_eaten", function(data)
        print("Food eaten! Score: " .. data.score)
    end)

    -- Observe new high score
    Events:subscribe("new_highscore", function(data)
        print("New high score: " .. data.score)
    end)

    -- Observe game over
    Events:subscribe("game_over", function(data)
        print("Game Over! Score: " .. data.score)
    end)

    -- Movement commands
    input:bind("up", function()
        playing:changeDirection(0, -1)
    end)

    input:bind("w", function()
        playing:changeDirection(0, -1)
    end)

    input:bind("down", function()
        playing:changeDirection(0, 1)
    end)

    input:bind("s", function()
        playing:changeDirection(0, 1)
    end)

    input:bind("left", function()
        playing:changeDirection(-1, 0)
    end)

    input:bind("a", function()
        playing:changeDirection(-1, 0)
    end)

    input:bind("right", function()
        playing:changeDirection(1, 0)
    end)

    input:bind("d", function()
        playing:changeDirection(1, 0)
    end)
end

function love.update(dt)
    gameState:update(dt)
end

function love.draw()
    gameState:draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
        return
    end

    if gameState.current == "menu" then
        if key == "return" then
            gameState:switch("playing")
        end
        return
    end

    if gameState.current == "playing" then
        local playing = gameState.states.playing

        if playing:isGameOver() then
            if key == "space" or key == "return" then
                playing:restart()
            end
            return
        end

        input:handleKey(key)
    end
end
