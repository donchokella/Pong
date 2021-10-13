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

window_width = 800
window_height = 600

--[[
    Runs when the game first starts up.
]]

function love.load()
    smallFont = love.graphics.newFont('font.ttf', 8)

    love.graphics.setFont(smallFont)




    love.window.setMode(window_width, window_height, {
        fullscreen = false,
        resizable = false,
        vsync = true

    })
end

function love.update(dt)


end

function love.draw()
    love.graphics.printf('HELL-Looo Player!!!', 0, window_height/2-6, window_width, 'center')


end
