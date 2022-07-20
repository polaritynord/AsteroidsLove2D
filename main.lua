local love = require("love")

-- Load other tables
local player = require("player")
local asteroids = require("asteroids")
local gameInterface = require("gameInterface")
local menuInterface = require("menuInterface")

local oldState
-- Main functions
function love.load()
    player:load()
    gameInterface:load()
    GameState = "menu"
    PreviousScore = -1
    Font = love.graphics.newFont("font.ttf", 35)
end

function love.update(delta)
    if GameState == "game" then
        player.update(delta, asteroids)
        asteroids.update(delta, player)
    else
        menuInterface.update(player, asteroids)
    end
    oldState = GameState
end

function love.draw()
    if GameState == "game" then
        player.draw()
        asteroids.draw()
        gameInterface.draw(player)
    else
        menuInterface.draw()
    end
end
