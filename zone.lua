local SharedState = require 'sharedstate'
local Bookcase = require 'bookcase'
local Desk = require 'desk'
local Exit = require 'exit'
local Map = require 'map'

Zone = {
   position = { x = 0, y = 0 },
   width = 0,
   height = 0,
   _bookcases = {},
   _numBookcases = 0,
   _desks = {},
   _numDesks = 0,
}


function Zone:new(t)
   t = t or {}
   setmetatable(t, { __index = self })
   t:_reset()
   return t
end

function Zone:_reset()
   self._bookcases = {}
   self._numBookcases = 0
   self._desks = {}
   self._numDesks = 0
   
   local pZoneLayout = love.math.random()
   -- todo: formalize zone layouts a bit more
   if pZoneLayout < 0.3 then
      self:_addUniformBookcases(0, self.width)
   elseif pZoneLayout < 0.7 then
      self:_addRandomBookcases(0, self.width, true, true)
   elseif pZoneLayout < 0.85 then
      local x, width = self:_addDesk()
      self:_addRandomBookcases(0, x, true)
      self:_addRandomBookcases(x + width, self.width, true)
   else
      self:_addRandomBookcases(0, self.width, false, true)
   end
end

function Zone:draw()
   love.graphics.push()
   love.graphics.translate(self.position.x, self.position.y)
   -- TODO: draw floor
   for ii = 1, self._numBookcases do
      self._bookcases[ii]:draw()
   end
   for ii = 1, self._numDesks do
      self._desks[ii]:draw()
   end
   love.graphics.pop()
end

function Zone:_addDesk()
   local width, height = 200, 75
   local x = love.math.random() * (self.width - width)
   self._numDesks = self._numDesks + 1
   self._desks[self._numDesks] = Desk:new({
         position = { x = x, y = self.height - height },
         width = width,
         height = height,
   })
   return x, width
end

function Zone:_addUniformBookcases(xBegin, xEnd)
   local width, height = Bookcase.randomWidth(), 150 + 25 * love.math.random(4)
   local spacing = 5 * math.random(0, 6)
   local numBookcases = math.floor((xEnd - xBegin) / (width + spacing))

   -- append numBookcases new cases
   for ii = 1, numBookcases do
      self._numBookcases = self._numBookcases + 1
      self._bookcases[self._numBookcases] = Bookcase:new({
         position = { x = 0, y = self.height - height },
         width = width,
         height = height,
      })
   end

   -- space evenly
   local totalWidth = (numBookcases * width) + ((numBookcases - 1) * spacing)
   local xOffset = ((xEnd - xBegin) - totalWidth) * 0.5
   for ii = 0, numBookcases - 1 do
      self._bookcases[self._numBookcases - ii].position.x =
         (ii * (width + spacing)) + xBegin + xOffset
   end
      
end

function Zone:_addRandomBookcases(xBegin, xEnd, allowEmpty, isRoot)
   local x, width = self:_addRandomBookcase(xBegin, xEnd, allowEmpty and not isRoot)
   if width > 0 then
      self:_addRandomBookcases(xBegin, x, allowEmpty)
      self:_addRandomBookcases(x + width, xEnd, allowEmpty)
   end
end

-- add one bookcase somewhere between xBegin and xEnd
-- or none if nothing fits.
-- return the x, width of the resulting bookcase; or zero width if none is created.
function Zone:_addRandomBookcase(xBegin, xEnd, allowEmpty)
   if allowEmpty and love.math.random() < 0.15 then
      return xEnd, 0
   end
   if xEnd - xBegin < Bookcase.sizes.NARROW then
      return xEnd, 0
   end
   
   local x, width
   repeat
      width = Bookcase.randomWidth()
   until xBegin + width < xEnd
   
   x = xBegin + love.math.random() * (xEnd - xBegin - width)

   self._numBookcases = self._numBookcases + 1
   local height = 150 + 25 * love.math.random(4)
   self._bookcases[self._numBookcases] = 
      Bookcase:new({
            position = { x = x, y = self.height - height },
            width = width,
            height = height,
      })
 
   return x, width
end

return Zone
