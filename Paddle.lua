--[[
    -- Paddle Class --

    Author: Ali Alparslan
    ali.alparslan@outlook.com

    It represents a paddle that can move up and down. 
    It is used in the main program to direct the ball to the opponent.

    Note: This class's original owner is Colten Ogden.
                                cogden@cs50.harvard.edu
    I'm just trying to learn some game development stuff from his GD50 class.
]]

Paddle = Class{}
--[[
    The 'init' function on our class is called just once, when the object is first created.
    Used to set up all variables in the class and get it redy for use.

    Our Paddle should take an X and a Y, for positioning, 
    as well as a width and a height for its dimensions.

    Note that 'self' is a reference to *this* object, whichever object is instantiated 
    at the time this function is called. Different objects can have their own x, y, width 
    and height values, thus serving aws containers for data. In this sense, they are very
    similar to structs in C.
]]
function Paddle:init(x, y, width, height)
    self.x = x 
    self.y = y 
    self.width = width
    self.height = height
    self.dy = 0
end

function Paddle:update(dt)
    -- math.max and math.min are for not to exceed the secreen boundaries
    if self.dy < 0 then
        self.y = math.max(0, self.dy*dt)
    else
        self.y = math.min(virtual_height - self.height, self.y + self.dy*dt)
    end
end

--[[
    To be called by our main function in `love.draw`, ideally. Uses
    LÖVE2D's `rectangle` function, which takes in a draw mode as the first
    argument as well as the position and dimensions for the rectangle. To
    change the color, one must call `love.graphics.setColor`. As of the
    newest version of LÖVE2D, you can even draw rounded rectangles!
]]
function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end