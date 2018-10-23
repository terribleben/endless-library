local SharedState = require 'sharedstate'
local Bookcase = require 'bookcase'
local Desk = require 'desk'

Room = {
   _bookcases = {},
   _numBookcases = 0,
   _desks = {},
   _numDesks = 0,
}

function Room:reset()
   self._bookcases = {}
   self._numBookcases = 0
   self._numDesks = 0
   self._desks = {}
   local pRoomLayout = love.math.random()
   -- todo: formalize room layouts a bit more
   if pRoomLayout < 0.3 then
      self:_addUniformBookcases(0, SharedState.viewport.width)
   elseif pRoomLayout < 0.7 then
      self:_addRandomBookcases(0, SharedState.viewport.width, true)
   elseif pRoomLayout < 0.8 then
      local x, width = self:_addDesk()
      self:_addRandomBookcases(0, x, true)
      self:_addRandomBookcases(x + width, SharedState.viewport.width, true)
   else
      self:_addRandomBookcases(0, SharedState.viewport.width, false)
   end
end

function Room:draw()
   for ii = 1, self._numBookcases do
      self._bookcases[ii]:draw()
   end
   for ii = 1, self._numDesks do
      self._desks[ii]:draw()
   end   
end

function Room:_addDesk()
   local width, height = 200, 75
   local x = love.math.random() * (SharedState.viewport.width - width)
   self._numDesks = self._numDesks + 1
   self._desks[self._numDesks] = Desk:new({
         position = { x = x, y = SharedState.viewport.height - height },
         width = width,
         height = height,
   })
   return x, width
end

function Room:_addUniformBookcases(xBegin, xEnd)
   local width, height = Bookcase.randomWidth(), 150 + 25 * love.math.random(4)
   local spacing = 5 * math.random(0, 6)
   local numBookcases = math.floor((xEnd - xBegin) / (width + spacing))

   -- append numBookcases new cases
   for ii = 1, numBookcases do
      self._numBookcases = self._numBookcases + 1
      self._bookcases[self._numBookcases] = Bookcase:new({
         position = { x = 0, y = SharedState.viewport.height - height },
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

function Room:_addRandomBookcases(xBegin, xEnd, allowEmpty)
   local x, width = self:_addRandomBookcase(xBegin, xEnd, allowEmpty)
   if width > 0 then
      self:_addRandomBookcases(xBegin, x, allowEmpty)
      self:_addRandomBookcases(x + width, xEnd, allowEmpty)
   end
end

-- add one bookcase somewhere between xBegin and xEnd
-- or none if nothing fits.
-- return the x, width of the resulting bookcase; or zero width if none is created.
function Room:_addRandomBookcase(xBegin, xEnd, allowEmpty)
   if allowEmpty and love.math.random() < 0.2 then
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
            position = { x = x, y = SharedState.viewport.height - height },
            width = width,
            height = height,
      })
 
   return x, width
end

return Room
