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

--[[
    the "Class"library we are using will allow us to represent anything in our game as code,
    rather than keeping track of many disparae variables and methods

    https://github.com/vrld/hump/blob/master/class.lua
]]
Class = require 'class'

require 'Paddle'
require 'Ball'

window_width = 800
window_height = 600

virtual_width = 432
virtual_height = 243

paddle_speed = 200      -- speed at which we will move our paddle; multiplied by dt in update

--[[
    Runs when the game first starts up.
]]
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')  -- I don't why ???

    love.window.setTitle('Pong Game by donchokella') -- the title of the window

    math.randomseed(os.time())  -- "seed" to random are always random by using "os.time" 
                                --which means the number is always increasing thats why different

    smallFont = love.graphics.newFont('font.ttf', 8)    -- a "retro-looking" font object

    scoreFont = love.graphics.newFont('font.ttf', 32)   -- a larger font to see the score

    love.graphics.setFont(smallFont)

    -- initialize the window with virtual resulation
    push:setupScreen(virtual_width, virtual_height, window_width, window_height, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    player1Score = 0        -- initialize the score veirables
    player2Score = 0        -- we're gonna add the score on these

    player1 = Paddle(10, 20, 5, 20)
    player2 = Paddle(virtual_width - 10, virtual_height - 30, 5, 20)

    ball = Ball(virtual_width/2 - 2, virtual_height/2 - 2, 4, 4)

    -- game state variable used to transition between different parts of the game
    -- (used for beginning, menus, main game, high score list, etc.)
    -- we will use this to determine behavior during render and update
    gameState = 'start'
end

--[[
    Runs every frame, with "dt" passed in, our delte in seconds since the last
    frame, which LOVE2D supplies us.
]]
function love.update(dt)

    -- player1 movement
    if love.keyboard.isDown('w') then
        player1.dy = -paddle_speed
    elseif love.keyboard.isDown('s') then
        player1.dy = paddle_speed
    else
        player1.dy = 0
    end

    -- player2 movement
    if love.keyboard.isDown('up') then
        player2.dy = -paddle_speed
    elseif love.keyboard.isDown('down') then
        player2.dy = paddle_speed
    else
        player2.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then     -- keys  can be accessed by string name
        love.event.quit()       -- quit function to terminate the game

            -- if we press enter during the start state of the game, we'll go into play mode
            -- during play mode, the ball will move in a random direction
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
           
            ball:reset()
        end        
    end
end

function love.draw()

    push:apply('start')        -- begin rendering at virtual resolution
    
    love.graphics.clear(40/255, 45/255, 53/255, 255/255)    -- clear the screen with a color that similar the original pong game
    
    -- welcome text on the top of the screen
    love.graphics.setFont(smallFont)
    love.graphics.printf('HELL-Looo Player!!!', 0, 20, virtual_width, 'center')

    -- score text on the middle left and middle right
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), virtual_width/2 - 50, virtual_height/3)
    love.graphics.print(tostring(player2Score), virtual_width/2 + 30, virtual_height/3)

    if gameState == 'start' then
        love.graphics.printf('Hello Start State!', 0, 20, virtual_width, 'center')
    else 
        love.graphics.printf('Hello Play State!', 0, 20, virtual_width, 'center')
    end

    player1:render()
    player2:render()
    ball:render()

    displayFPS()

    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
