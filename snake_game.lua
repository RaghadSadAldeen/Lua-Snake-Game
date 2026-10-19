
local Entity = require("entity")
local Vector2 = require("vector2")
local HighScore = require("highscore")
local Events = require("events")

local SnakeGame = {}
SnakeGame.__index = SnakeGame

local GRID = 20
local CELL = 30
local STEP_TIME = 0.12

function SnakeGame:new()
    local game = {
        snake = {
            Vector2:new(10, 10),
            Vector2:new(9, 10),
            Vector2:new(8, 10)
        },

        direction = Vector2:new(1, 0),
        nextDirection = Vector2:new(1, 0),

        food = nil,
        score = 0,
        highScore = HighScore:load(),
        gameOver = false,
        timer = 0
    }

    setmetatable(game, SnakeGame)

    -- Create snake Entity
    game.entity = Entity:new()

    game.entity:addComponent("Position", {
        x = 10,
        y = 10
    })

    game.entity:addComponent("Movement", {
        dx = 1,
        dy = 0
    })

    game.entity:addComponent("Renderer", {
        color = {0.3, 0.8, 0.4},
        size = CELL
    })

    game:spawnFood()

    return game
end

-- Spawn food in a free position
function SnakeGame:spawnFood()
    if #self.snake >= GRID * GRID then
        self.food = nil
        return
    end

    while true do
        local x = love.math.random(0, GRID - 1)
        local y = love.math.random(0, GRID - 1)
        local newFood = Vector2:new(x, y)

        local free = true

        for _, segment in ipairs(self.snake) do
            if segment == newFood then
                free = false
                break
            end
        end

        if free then
            self.food = newFood
            return
        end
    end
end

-- Change movement direction
function SnakeGame:changeDirection(dx, dy)
    if self.gameOver then
        return
    end

    if dx == -self.direction.x
        and dy == -self.direction.y then
        return
    end

    if self.nextDirection ~= self.direction then
        return
    end

    self.nextDirection = Vector2:new(dx, dy)
end

-- Move snake
function SnakeGame:moveSnake()
    self.direction = self.nextDirection

    local movement =
        self.entity:getComponent("Movement")

    movement.dx = self.direction.x
    movement.dy = self.direction.y

    local head = self.snake[1]

    local newHead = head + Vector2:new(
        movement.dx,
        movement.dy
    )

    -- Wall collision
    if newHead.x < 0 or newHead.x >= GRID
        or newHead.y < 0 or newHead.y >= GRID then
        self.gameOver = true
        Events:emit("game_over", {score = self.score})
        return
    end

    -- Food collision
    local eating = self.food ~= nil
        and newHead == self.food

    -- Self collision
    local lastSegment = #self.snake

    if not eating then
        lastSegment = lastSegment - 1
    end

    for i = 1, lastSegment do
        if newHead == self.snake[i] then
            self.gameOver = true
            Events:emit("game_over", {score = self.score})
            return
        end
    end

    table.insert(self.snake, 1, newHead)

    local position =
        self.entity:getComponent("Position")

    position.x = newHead.x
    position.y = newHead.y

    if eating then
        self.score = self.score + 1

        -- Food eaten event
        Events:emit("food_eaten", {
            score = self.score
        })

        if self.score > self.highScore then
            self.highScore = self.score
            HighScore:save(self.highScore)

            -- New record event
            Events:emit("new_highscore", {
                score = self.highScore
            })
        end

        self:spawnFood()

        if not self.food then
            self.gameOver = true
            Events:emit("game_over", {score = self.score})
        end
    else
        table.remove(self.snake)
    end
end

-- Update game
function SnakeGame:update(dt)
    if self.gameOver then
        return
    end

    self.timer = self.timer + dt

    while self.timer >= STEP_TIME
        and not self.gameOver do
        self.timer = self.timer - STEP_TIME
        self:moveSnake()
    end
end

-- Draw game
function SnakeGame:draw()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.12)

    local renderer =
        self.entity:getComponent("Renderer")

    -- Food
    if self.food then
        love.graphics.setColor(1, 0.3, 0.3)

        love.graphics.rectangle(
            "fill",
            self.food.x * CELL,
            self.food.y * CELL,
            CELL - 2,
            CELL - 2
        )
    end

    -- Snake
    for i, segment in ipairs(self.snake) do
        if i == 1 then
            love.graphics.setColor(0.5, 1, 0.6)
        else
            love.graphics.setColor(renderer.color)
        end

        love.graphics.rectangle(
            "fill",
            segment.x * renderer.size,
            segment.y * renderer.size,
            renderer.size - 2,
            renderer.size - 2
        )
    end

    -- Score
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(
        "Score: " .. self.score, 10, 10
    )

    -- High score
    love.graphics.setColor(1, 0.85, 0.3)
    love.graphics.print(
        "High Score: " .. self.highScore,
        10, 30
    )

    -- Game Over
    if self.gameOver then
        love.graphics.setColor(0, 0, 0, 0.7)

        love.graphics.rectangle(
            "fill", 0, 0,
            GRID * CELL, GRID * CELL
        )

        love.graphics.setColor(1, 1, 1)

        love.graphics.printf(
            "GAME OVER\nScore: " .. self.score ..
            "\nHigh Score: " .. self.highScore ..
            "\nPress SPACE to restart",
            0,
            GRID * CELL / 2 - 50,
            GRID * CELL,
            "center"
        )
    end
end

return SnakeGame
