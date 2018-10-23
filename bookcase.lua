local Shelf = require 'shelf'

Bookcase = {
   position = { x = 0, y = 0 },
   width = 0,
   height = 0,
   sizes = {
      NARROW = 75,
      MEDIUM = 175,
      WIDE = 375,
      GRAND = 700,
   },
   _shelves = {},
   _numShelves = 0,
}

function Bookcase:new(b)
   b = b or {}
   setmetatable(b, { __index = self })
   b:_reset()
   return b
end

function Bookcase.randomWidth()
   local width
   local ii = love.math.random(1, 4)
   if ii == 1 then width = Bookcase.sizes.NARROW
   elseif ii == 2 then width = Bookcase.sizes.MEDIUM
   elseif ii == 3 then width = Bookcase.sizes.WIDE
   else width = Bookcase.sizes.GRAND
   end
   return width
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
   self._shelves = {}
   self._numShelves = 0
   local pShelfBehavior = love.math.random()
   if pShelfBehavior < 0.5 then
      self:_addUniformShelves(0, self.height)
   elseif pShelfBehavior < 0.75 then
      local division = self.height * (0.25 + 0.5 * love.math.random())
      self:_addUniformShelves(0, division)
      self:_addUniformShelves(division, self.height)
   else
      self:_addRandomShelves(0, self.height)
   end
end

function Bookcase:_addUniformShelves(yStart, yEnd)
   local numShelves = 1 + love.math.random(5)
   local shelfHeight = (yEnd - yStart) / numShelves
   while shelfHeight > Shelf.MAX_HEIGHT do
      numShelves = numShelves + 1
      shelfHeight = (yEnd - yStart) / numShelves
   end
   while shelfHeight < Shelf.MIN_HEIGHT do
      numShelves = numShelves - 1
      shelfHeight = (yEnd - yStart) / numShelves
   end
   for ii = 1, numShelves do
      self._numShelves = self._numShelves + 1
      self._shelves[self._numShelves] =
         Shelf:new({
               position = { x = 0, y = yStart + (shelfHeight * (ii - 1)) },
               width = self.width,
               height = shelfHeight,
         })
   end
end

function Bookcase:_addRandomShelves(yStart, yEnd)
   local y = yEnd
   while y > Shelf.MIN_HEIGHT do
      local shelfHeight = Shelf.MIN_HEIGHT + (Shelf.MAX_HEIGHT - Shelf.MIN_HEIGHT) * love.math.random()
      if y - shelfHeight > yStart then
         self._numShelves = self._numShelves + 1
      self._shelves[self._numShelves] =
         Shelf:new({
               position = { x = 0, y = y - shelfHeight },
               width = self.width,
               height = shelfHeight,
         })
      end
      y = y - shelfHeight
   end
end

return Bookcase
