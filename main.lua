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

--[[
push is a library that will allow us to draw our game at a virtual
resolution, instead of however large our window is; used to provide
a more retro aesthetic

 https://github.com/Ulydev/push
]]
push = require 'push'

window_width = 800
window_height = 600

virtual_width = 432
virtual_height = 243

--[[
    Runs when the game first starts up.
]]

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallFont = love.graphics.newFont('font.ttf', 30)   -- a "retro-looking" font object

    love.graphics.setFont(smallFont)


-- initialize the window with virtual resulation

    push: setupScreen(virtual_width, virtual_height, window_width, window_height, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end


function love.keypressed(key)
    if key == 'escape' then     --keys  can be accessed by string name
        love.event.quit()       -- quit function to terminate the game
    end
end

function love.draw()
    love.graphics.printf('HELL-Looo Player!!!', 0, window_height/2-6, window_width, 'center')


end
