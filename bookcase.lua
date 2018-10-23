local Shelf = require 'shelf'

Bookcase = {
   position = { x = 0, y = 0 },
   width = 0,
   height = 0,
   _shelves = {},
   _numShelves = 0,
}

function Bookcase:new(b)
   b = b or {}
   setmetatable(b, { __index = self })
   b:_reset()
   return b
end

function Bookcase:draw()
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.push()
   love.graphics.translate(self.position.x, self.position.y)
   love.graphics.rectangle(
      'line',
      0, 0,
      self.width, self.height
   )
   for ii = 1, self._numShelves do
      self._shelves[ii]:draw()
   end
   love.graphics.pop()
end

function Bookcase:_reset()
   -- for now, uniform shelves
   local numShelves = 2 + love.math.random(3)
   local shelfHeight = self.height / numShelves
   self._shelves = {}
   self._numShelves = 0
   for ii = 1, numShelves do
      self._numShelves = self._numShelves + 1
      self._shelves[self._numShelves] =
         Shelf:new({
               position = { x = 0, y = shelfHeight * (ii - 1) },
               width = self.width,
               height = shelfHeight,
         })
   end
end

return Bookcase
