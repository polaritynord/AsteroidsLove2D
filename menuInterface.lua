local love = require("love")

local menuInterface = {}

function menuInterface.update(player, asteroids)
    if love.keyboard.isDown("x") then
        player.setup()
        asteroids.setup()
        GameState = "game"
    end
end

function menuInterface.draw()
    -- Title
    love.graphics.setNewFont("font.ttf", 75)
    love.graphics.printf("ASTEROIDS", 0, 125, 1000, "center")
    -- Press space
    love.graphics.setNewFont("font.ttf", 25)
    love.graphics.printf("press x to start", 0, 240, 1000, "center")
    if PreviousScore > -1 then
        love.graphics.printf("Score: " .. PreviousScore, 0, 300, 1000, "center")
    end
end

return menuInterface
