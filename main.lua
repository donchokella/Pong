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


paddle_speed = 200      -- speed at which we will move our paddle; multiplied by dt in update

--[[
    Runs when the game first starts up.
]]

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')  -- I don't why ???

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

    player1Y = 30                   -- paddle positions on Y axis
    player2Y = virtual_height - 50  -- they can only move up or down

    -- velecity and position variables for our ball when play starts
    ballX = virtual_width/2 - 2
    ballY = virtual_height/2 - 2

    -- math.random returns a random value between the left and right number
    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

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
        player1Y = player1Y + -paddle_speed*dt      -- negative paddle speed since the y axis is upside down for the LOVE2D
        player1Y = math.max(0, player1Y + -paddle_speed*dt)     -- we clamp our position between the bounds of the screen
    elseif love.keyboard.isDown('s') then
        player1Y = player1Y + paddle_speed*dt
        player1Y = math.min(virtual_height - 20, player1Y + paddle_speed*dt)
    end


    -- player2 movement
    if love.keyboard.isDown('up') then
        player2Y = player2Y + -paddle_speed*dt      -- negative paddle speed since the y axis is upside down for the LOVE2D
        player2Y = math.max(0, player2Y + -paddle_speed*dt)   
    elseif love.keyboard.isDown('down') then
        player2Y = player2Y + paddle_speed*dt
        player2Y = math.min(virtual_height - 20, player2Y + paddle_speed*dt)
    end

    if gameState == 'play' then
        ballX = ballX + ballDX*dt
        ballY = ballY + ballDY*dt
    end
    
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
           
            -- start ball's position in the middle of the screen
            ballX = virtual_width/2 - 2
            ballY = virtual_height/2 - 2

            -- given ball's x and y velocity a random starting value
            -- the and/or pattern here is Lua's way of accomplishing a ternary operation
            -- in other programming languages like C
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50)*1.5
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


    --[[
        Paddles and the ball are simply rectangles
    ]]
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)
    love.graphics.rectangle('fill', virtual_width - 10, player2Y, 5, 20)

    love.graphics.rectangle('fill', ballX, ballY, 4, 4)

    push:apply('end')
end