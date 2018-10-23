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
   local x = 0
   self._books = {}
   self._numBooks = 0
   -- TODO: 18 is currently max book width, centralize
   while x < self.width - 18 do
      local width, height = self:_getBookDimensions()
      self._numBooks = self._numBooks + 1
      self._books[self._numBooks] =
         Book:new({
               position = { x = x, y = self.height - height },
               width = width,
               height = height,
         })
      x = x + width
   end
end

function Shelf:_getBookDimensions()
   -- TODO: categories of book
   local width = 10 + 2 * love.math.random(4)
   local height = self.height * (0.6 + 0.1 * love.math.random(3))
   return width, height
end

return Shelf
