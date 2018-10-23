local SharedState = require 'sharedstate'
local Bookcase = require 'bookcase'

Room = {
   _bookcases = {},
   _numBookcases = 0,
}

function Room:reset()
   self._bookcases = {}
   self._numBookcases = 0
   local pRoomLayout = love.math.random()
   if pRoomLayout < 0.3 then
      self:_addUniformBookcases()
   elseif pRoomLayout < 0.8 then
      self:_addRandomBookcases(0, SharedState.viewport.width, true)
   else
      self:_addRandomBookcases(0, SharedState.viewport.width, false)
   end
end

function Room:draw()
   for ii = 1, self._numBookcases do
      self._bookcases[ii]:draw()
   end
end

function Room:_addUniformBookcases(xBegin, xEnd)
   -- todo
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
      local ii = love.math.random(1, 4)
      if ii == 1 then width = Bookcase.sizes.NARROW
      elseif ii == 2 then width = Bookcase.sizes.MEDIUM
      elseif ii == 3 then width = Bookcase.sizes.WIDE
      else width = Bookcase.sizes.GRAND
      end
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
