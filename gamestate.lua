
local GameState = {}
GameState.__index = GameState

function GameState:new()
    local state = {
        current = "menu",
        states = {
            menu = require("states.menu_state"),
            playing = require("states.game_state")
        }
    }

    return setmetatable(state, GameState)
end

function GameState:switch(newState)
    if self.states[newState] then
        self.current = newState
    end
end

function GameState:update(dt)
    self.states[self.current]:update(dt)
end

function GameState:draw()
    self.states[self.current]:draw()
end

return GameState
