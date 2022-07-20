local love = require("love")
local checkCollision = require("collision")

local asteroids = {
    asteroidTimer = 0;
    nextAsteroidCooldown = 0;
    asteroids = {};
}

function asteroids.setup()
    asteroids.asteroids = {}
    asteroids.asteroidTimer = 0
    asteroids.nextAsteroidCooldown = 0
end

function asteroids.update(delta, player)
    asteroids.spawnAsteroids(delta)
    -- Update asteroids
    for _, v in ipairs(asteroids.asteroids) do
        -- Move the asteroid
        local astSpeed = 75 / (v.level/3)
        v.xPos = v.xPos + math.cos(v.rotation) * astSpeed * delta
        v.yPos = v.yPos + math.sin(v.rotation) * astSpeed * delta
        -- Make sure the asteroid doesn't go offscreen
        local imgWidth = v.image:getWidth()
        local imgHeight = v.image:getHeight()
        if v.xPos < -imgWidth/2 then
            v.xPos = 960 + imgWidth/2
        elseif v.xPos > 960 + imgWidth/2 then
            v.xPos = -imgWidth/2
        end

        if v.yPos < -imgHeight/2 then
            v.yPos = 540 + imgHeight/2
        elseif v.yPos > 540 + imgHeight/2 then
            v.yPos = -imgHeight/2
        end
        -- Check for player touch
        local pWidth = player.image:getWidth()
        local pHeight = player.image:getHeight()
        if checkCollision(
            v.xPos-imgWidth/2, v.yPos-imgHeight/2, imgWidth, imgHeight,
            player.xPos-pWidth/2, player.yPos-pHeight/2, pWidth, pWidth
        ) then
            player.damage()
        end
    end
end

function asteroids.draw()
    -- Draw asteroids
    for _, v in ipairs(asteroids.asteroids) do
        local imgWidth = v.image:getWidth()
        local imgHeight = v.image:getHeight()
        love.graphics.draw(
            v.image,
            v.xPos, v.yPos,
            0, 1, 1, imgWidth/2, imgHeight/2
        )
    end
end

function asteroids.spawnAsteroids(delta)
    -- Limit the asteroid count to 20
    if #asteroids.asteroids > 19 then return end
    -- Increment timer
    asteroids.asteroidTimer = asteroids.asteroidTimer + delta
    if asteroids.asteroidTimer < asteroids.nextAsteroidCooldown then
        return end
    -- Reset the timer and select a new time
    asteroids.nextAsteroidCooldown = (math.random() * 2.45) + 1.25
    asteroids.asteroidTimer = 0
    -- Spawn the asteroid
    local newAsteroid = {
        image = love.graphics.newImage("asteroid_lvl3.png");
        xPos = 0;
        yPos = 0;
        rotation = math.random(0, 360);
        level = 3;
    }
    local c = math.random()
    -- Set asteroid position
    if c < 0.25 then
        -- Horizontal (up)
        newAsteroid.xPos = math.random(0, 960)
    elseif c < 0.5 then
        -- Horizontal (down)
        newAsteroid.xPos = math.random(0, 960)
        newAsteroid.yPos = 570
    elseif c < 0.75 then
        -- Vertical (left)
        newAsteroid.yPos = math.random(0, 540)
    else
        -- Vertical (right)
        newAsteroid.yPos = math.random(0, 540)
        newAsteroid.xPos = 975
    end
    -- Add new asteroid to list
    asteroids.asteroids[#asteroids.asteroids+1] = newAsteroid
end

return asteroids
