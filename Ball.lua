--[[
    -- Ball Class --

    Author: Ali Alparslan
    ali.alparslan@outlook.com

    Represents a ball that will bounce back and forth between 
    paddles and walls until it crosses the left or right border 
    of the screen, earning the opponent a point.
]]

Ball = Class{}

function Ball:init (x, y, width, height)
    self.x = x 
    self.y = y 
    self.width = width
    self.height = height

    -- these variables are for keeping track of our velocity on bothe the X and Y axis,
    -- since the ball can move in two dimensions
    self.dy = math.random(2) ==1 -100 or 100
    self.dx = math.random(-50, 50)
end

--[[
    place the ball in the middle of the screen with an initial random velocity on both axes.
]]

function Ball.reset()
    self.x = virtual_width/2 - 2
    self.y = virtual_height/2 - 2
    self.dy = math.random(2) ==1 -100 or 100
    self.dx = math.random(-50, 50)
end

--[[
    simply applyies velocity to position, scaled by deltaTime.
]]

function Ball:update(dt)
    self.x = self.x + self.dx*dt
    self.y = self.y + self.dy*dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end