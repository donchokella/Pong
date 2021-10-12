--[[
This is a Pong game remake

Author: Ali Alparslan
ali.alparslan@outlook.com

Originally programmed by Atari in 1972.

There is a two paddles an a ball. 
Paddles are placed on opposite sides of the screen 
and can only be moved up and down by the players.
The goal is to get the ball past the opponent.
Reaching 10 points wins!!!
]]

window_width = 1280
window_height = 720

--[[
    Runs when the game first starts up.
]]

function love.load()
    love.window.setMode(window_width, window_height, {
        fullscreen = false
        resizable = false
        vsync = true

    })
end

