local love = require("love")
local checkCollision = require("collision")

-- Player
local player = {
    image = love.graphics.newImage("spaceship.png");
    xPos = 480;
    yPos = 270;
    rotation = 0;
    velocity = 0;
    shootTimer = 0;
    bullets = {};
    health = 3;
    damageTimer = 0;
    score = 0;
    damageSound = love.audio.newSource("damage.wav", "static");
    shootSound = love.audio.newSource("shoot.wav", "static");
    astHitSound = love.audio.newSource("asteroid_hit.wav", "static");
}

function player.setup()
    player.xPos = 480;
    player.yPos = 270;
    player.rotation = 0;
    player.velocity = 0;
    player.shootTimer = 0;
    player.bullets = {};
    player.health = 3;
    player.damageTimer = 0;
    player.score = 0;
end

function player.load()
    player.shootSound:setVolume(0.25)
    player.astHitSound:setVolume(0.5)
end

function player.updateBullet(b, i, delta, asteroids)
    -- Despawn bullet
    b.lifetime = b.lifetime + delta
    if b.lifetime > 1.9 then
        table.remove(player.bullets, i)
        goto skipToNext
    end
    -- Move bullet
    local bulletSpeed = 550
    b.xPos = b.xPos + math.cos(b.rotation) * bulletSpeed * delta
    b.yPos = b.yPos + math.sin(b.rotation) * bulletSpeed * delta

    -- Check for asteroid collision
    local bWidth = b.image:getWidth()
    local bHeight = b.image:getHeight()
    for iAsteroid, a in ipairs(asteroids.asteroids) do
        local aWidth = a.image:getWidth()
        local aHeight = a.image:getHeight()
        if checkCollision(
            b.xPos-bWidth/2, b.yPos-bHeight/2, bWidth, bHeight,
            a.xPos-aWidth/2, a.yPos-aHeight/2, aWidth, aHeight
        ) then
            -- Increment score
            player.score = player.score + 10 / (a.level/3)
            -- Divide the asteroid (if its level is higher than 1)
            if a.level > 1 then
                a.level = a.level - 1
                a.image = love.graphics.newImage("asteroid_lvl" .. a.level .. ".png")
                -- Create new asteroid
                local newAsteroid = {
                    image = a.image;
                    xPos = a.xPos;
                    yPos = a.yPos;
                    rotation = a.rotation + 180;
                    level = a.level;
                }
                asteroids.asteroids[#asteroids.asteroids+1] = newAsteroid
            else
                table.remove(asteroids.asteroids, iAsteroid)
            end
            -- Play sound effect
            if not player.astHitSound:isPlaying() then
                love.audio.play(player.astHitSound)
            end
            -- Remove self
            table.remove(player.bullets, i)
        end
    end
    ::skipToNext::
end
-- Player functions
function player.movement(delta)
    local speed = 1200
    -- Change velocity
    if love.keyboard.isDown("up", "w") then
        player.velocity = player.velocity + speed * delta
    elseif love.keyboard.isDown("down", "s") then
        player.velocity = player.velocity - speed * delta
    end
    -- Move by velocity
    player.xPos = player.xPos + math.cos(player.rotation) * player.velocity * delta
    player.yPos = player.yPos + math.sin(player.rotation) * player.velocity * delta
    -- Decrease velocity
    local temp = 0.225 / delta
    player.velocity = player.velocity + (-player.velocity / temp)
end

function player.shoot(delta)
    player.shootTimer = player.shootTimer + delta
    if not love.keyboard.isDown("space") or player.shootTimer < 0.235 then
        return end
    -- Shoot
    player.shootTimer = 0
    local newBullet = {
        image = love.graphics.newImage("bullet.png");
        xPos = 0;
        yPos = 0;
        rotation = 0;
        lifetime = 0;
    }
    -- Set bullet position
    newBullet.xPos = player.xPos ; newBullet.yPos = player.yPos
    newBullet.xPos = newBullet.xPos + math.cos(player.rotation) * 10
    newBullet.yPos = newBullet.yPos + math.sin(player.rotation) * 10
    -- Set bullet rotation
    newBullet.rotation = player.rotation
    -- Add to bullets list
    player.bullets[#player.bullets+1] = newBullet
    -- Play the sound effect
    if not player.shootSound:isPlaying() then
        love.audio.play(player.shootSound)
    end
end

function player.rotate(delta)
    local rotSpeed = 4.5
    if love.keyboard.isDown("right", "d") then
        player.rotation = player.rotation + rotSpeed * delta
    elseif love.keyboard.isDown("left", "a") then
        player.rotation = player.rotation - rotSpeed * delta
    end
end

function player.damage()
    if player.damageTimer < 2.6 then return end
    player.damageTimer = 0
    player.health = player.health - 1
    -- Play the sound effect
    if not player.damageSound:isPlaying() then
        love.audio.play(player.damageSound)
    end
    -- Return to menu if ded
    if player.health < 1 then
        GameState = "menu"
        PreviousScore = player.score
    end
end

function player.update(delta, asteroids)
    player.damageTimer = player.damageTimer + delta
    player.rotate(delta)
    player.movement(delta)
    player.shoot(delta)
    -- Update bullets
    for i, b in ipairs(player.bullets) do
        player.updateBullet(b, i, delta, asteroids)
    end
end

function player.draw()
    local imgWidth = player.image:getWidth()
    local imgHeight = player.image:getHeight()
    love.graphics.draw(
        player.image,
        player.xPos, player.yPos,
        player.rotation, 1, 1, imgWidth/2, imgHeight/2
    )
    -- Draw bullets
    for _, b in ipairs(player.bullets) do
        local bWidth = b.image:getWidth()
        local bHeight = b.image:getHeight()
        love.graphics.draw(
            b.image,
            b.xPos, b.yPos,
            b.rotation, 1, 1, bWidth/2, bHeight/2
        )
    end
end

return player
