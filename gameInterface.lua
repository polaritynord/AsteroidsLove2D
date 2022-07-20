local love = require("love")

local gameInterface = {
    heartImg = love.graphics.newImage("heart.png");
}

function gameInterface.load()
    gameInterface.heartImg:setFilter("nearest", "nearest")
end

function gameInterface.draw(player)
    -- Draw hearts
    for i=1,player.health do
        love.graphics.draw(
            gameInterface.heartImg, 13 + (i-1)*32, 500, 0, 3
        )
    end
    -- Draw score
    love.graphics.setNewFont("font.ttf", 40)
    love.graphics.print(player.score, 15, 15)
end

return gameInterface
