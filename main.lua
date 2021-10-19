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
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)   -- a larger font to see the score
    love.graphics.setFont(smallFont)

    sounds = {
        ['paddle'] = love.audio.newSource('sounds/Paddle.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/Score.wav', 'static'),
        ['wall'] = love.audio.newSource('sounds/Wall.wav', 'static')
    }


    -- initialize the window with virtual resulation
    push:setupScreen(virtual_width, virtual_height, window_width, window_height, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    player1Score = 0        -- initialize the score veirables
    player2Score = 0        -- we're gonna add the score on these

    -- either going to be 1 or 2; whomever is scored on gets to serve the following turn
    servingPlayer = 1

    -- initialize player paddles and ball
    player1 = Paddle(10, 20, 5, 20)
    player2 = Paddle(virtual_width - 10, virtual_height - 30, 5, 20)
    ball = Ball(virtual_width/2 - 2, virtual_height/2 - 2, 4, 4)

    -- game state variable used to transition between different parts of the game
    -- (used for beginning, menus, main game, high score list, etc.)
    -- we will use this to determine behavior during render and update
    gameState = 'start'
end

--[[
    Called by LÖVE whenever we resize the screen; here, we just to pass ,n the width and height to push 
    so our virtual resolution can be resized as needed.
]]
function love.resize(w, h)
    push:resize(w, h)
end

--[[
    Runs every frame, with "dt" passed in, our delte in seconds since the last
    frame, which LOVE2D supplies us.
]]
function love.update(dt)
    if gameState == 'serve' then
        --before switching to play, initialize ball's velocity based on player who last scored
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == 'play' then
        -- detect ball collision with paddles, reversing dx if true and slightly increasing it,
        -- then altering the dy based on the position of collision
        if ball:collides(player1) then
            ball.dx = -ball.dx*1.05
            ball.x = player1.x + 5

            -- keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds['paddle']:play()

        end

        if ball:collides(player2) then
            ball.dx = -ball.dx*1.05
            ball.x = player2.x - 4

            -- keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds['paddle']:play()

        end
        
        -- detect upper and lower screen boundary colision and reverse if collided
        if ball.y <= 0 then 
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall']:play()
        end

        if ball.y >= virtual_height - 4 then
            ball.y = virtual_height - 4
            ball.dy = -ball.dy
            sounds['wall']:play()
        end
    

        -- if we reach the left or right edge of the screen, go back to start and update the score
        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()
            
            -- if we have reached a score of 10, the game is over; 
            -- set the state to done so we can show the victory message
            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end

        if ball.x > virtual_width then
            servingPlayer = 2
            player1Score = player1Score + 1
            sounds['score']:play()

            
            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
    end
    
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

    -- update our ball based on its dx and dy anly if we are in play state;
    -- scale the velocity by dt so movement is framerate-independent
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
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            --game is simply in a restart phase here, but will set the serving player to the 
            -- opponent of whomever won for fairness!
            gameState = 'serve'
            ball:reset()

            --reset scores to 0
            player1Score = 0
            player2Score = 0

            -- decide serving player as the opposite of who won
            if winningPlayer == 1 then
                 servingPlayer = 2
            else 
                servingPlayer = 1
            end
        end        
    end
end

function love.draw()

    push:apply('start')        -- begin rendering at virtual resolution
    
    love.graphics.clear(40/255, 45/255, 53/255, 255/255)    -- clear the screen with a color that similar the original pong game
    
    -- welcome text on the top of the screen
    love.graphics.setFont(smallFont)
    
    displayScore()

    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong Game!', 0, 10, virtual_width, 'center')
        love.graphics.printf('Press Enter to Begin!', 0, 20, virtual_width, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player' .. tostring(servingPlayer) .. "'s serve!", 0, 10, virtual_width, 'center')
        love.graphics.printf('Press Enter to Serve!', 0, 20, virtual_width, 'center')
    elseif gameState == 'play' then
        -- no UI messages to display in play
    elseif gameState == 'done' then
        -- UI messages
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!', 0, 10, virtual_width, 'center')
    end
        
    player1:render()
    player2:render()
    ball:render()

    displayFPS()

    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

-- Simply draes the score to the screen
function displayScore()
    -- score text on the middle left and middle right
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), virtual_width/2 - 50, virtual_height/3)
    love.graphics.print(tostring(player2Score), virtual_width/2 + 30, virtual_height/3)
end

