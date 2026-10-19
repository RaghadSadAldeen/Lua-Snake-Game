
local Menu = {}

function Menu:update(dt)
    -- No movement in menu
end

function Menu:draw()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.12)
    love.graphics.setColor(0.3, 0.9, 0.4)

    love.graphics.printf(
        "SNAKE GAME",
        0, 200, 600, "center"
    )

    love.graphics.setColor(1, 1, 1)

    love.graphics.printf(
        "Press ENTER to Start",
        0, 300, 600, "center"
    )
end

return Menu
