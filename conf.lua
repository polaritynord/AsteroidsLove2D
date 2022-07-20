local love = require("love")

function love.conf(t)
    t.version = "11.4"
    t.title = "Asteroids"
    t.window.width = 960
    t.window.height = 540
    --t.window.vsync = 0
end
