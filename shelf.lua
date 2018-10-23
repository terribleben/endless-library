local Book = require 'book'

Shelf = {
   position = { x = 0, y = 0 },
   width = 0,
   height = 0,
   _books = {},
   _numBooks = 0,
}

function Shelf:new(s)
   s = s or {}
   setmetatable(s, { __index = self })
   s:_reset()
   return s
end

function Shelf:draw()
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.push()
   love.graphics.translate(self.position.x, self.position.y)
   love.graphics.line(
      0, self.height,
      self.width, self.height
   )
   for ii = 1, self._numBooks do
      self._books[ii]:draw()
   end
   love.graphics.pop()
end

function Shelf:_reset()
   local x = 9 + love.math.random(8)
   local prevAngle = 0
   self._books = {}
   self._numBooks = 0
   -- TODO: 18 is currently max book width, centralize
   while x < self.width - 18 do
      local boundsWidth, angle = self:_addBooks(prevAngle, x)
      x = x + boundsWidth
      prevAngle = angle
   end
end

-- add one or more books to the shelf.
-- return the width occupied and the angle of the last book added.
function Shelf:_addBooks(prevAngle, x)
   local spaceAvailable = self.width - x
   if spaceAvailable >= Book.PAPERBACK_HEIGHT + 18 and love.math.random() < 0.02 then
      return self:_addBookStack(prevAngle, x)
   else
      return self:_addSingleBook(prevAngle, x)
   end
end

function Shelf:_addSingleBook(prevAngle, x)
   local width, height = self:_getBookDimensions()
   local angle = self:_getBookAngle(prevAngle)
   local absAngle = math.abs(angle)
   local boundsWidth, boundsHeight =
      width * math.cos(absAngle) + height * math.sin(absAngle),
      width * math.sin(absAngle) + height * math.cos(absAngle)
   local nextX
   if prevAngle == angle then nextX = x + width * 0.5 else nextX = x + boundsWidth * 0.5 end
   self._numBooks = self._numBooks + 1
   self._books[self._numBooks] =
      Book:new({
            position = { x = nextX, y = self.height - boundsHeight * 0.5 },
            width = width,
            height = height,
            angle = angle,
      })
   return boundsWidth, angle
end

function Shelf:_addBookStack(prevAngle, x)
   local stackHeight, maxWidth = 0, 0
   local stackSize = 0
   repeat
      local width, height = self:_getBookDimensions()
      local nextX = x + height * 0.5
      local currentStackWidth = height
      if currentStackWidth > maxWidth then
         maxWidth = currentStackWidth
      end
      self._numBooks = self._numBooks + 1
      self._books[self._numBooks] =
         Book:new({
               position = { x = nextX, y = self.height - width * 0.5 - stackHeight },
               width = width,
               height = height,
               angle = math.pi * 0.5,
         })
      stackHeight = stackHeight + width
      stackSize = stackSize + 1
      if love.math.random() < 0.15 then break end
   until stackHeight >= self.height - 18

   -- redistribute books horizontally based on width of stack
   for ii = 0, stackSize - 1 do
      local book = self._books[self._numBooks - ii]
      local diffFromMax = maxWidth - book.height
      if diffFromMax > 0 then
         local offset = diffFromMax * love.math.random()
         book.position.x = book.position.x + offset
      end
   end
   return maxWidth, 0
end

function Shelf:_getBookDimensions()
   local width, height
   local p = love.math.random()
   local fatness = love.math.random()
   if self.height > Book.PULP_HEIGHT and p < 0.5 then
      height = Book.PULP_HEIGHT
      width = 7 + 4 * fatness
   elseif self.height > Book.PAPERBACK_HEIGHT and p < 0.75 then
      height = Book.PAPERBACK_HEIGHT
      width = 7 + 4 * fatness
   else
      height = self.height * (0.6 + 0.1 * love.math.random(3))
      width = height * (0.15 + 0.2 * fatness)
   end
   return width, height
end

function Shelf:_getBookAngle(prevAngle)
   local pSwitch = love.math.random()
   if prevAngle == 0 then
      if pSwitch < 0.25 then
         -- start leaning
         return -0.1 + love.math.random() * 0.2
      else
         -- continue upright
         return 0
      end
   else
      if pSwitch < 0.5 then
         -- stop leaning
         return 0
      else
         -- continue leaning
         return prevAngle
      end
   end
end

return Shelf
