local SharedState = require 'sharedstate'
local Bookcase = require 'bookcase'

Room = {
   _bookcases = {},
   _numBookcases = 0,
}

function Room:reset()
   self._bookcases = {}
   for ii = 1, 3 do
      self._numBookcases = self._numBookcases + 1
      local height = 150 + 25 * love.math.random(4)
      self._bookcases[self._numBookcases] = 
         Bookcase:new({
               position = { x = 50 + (175 * ii), y = SharedState.viewport.height - height },
               width = 150,
               height = height,
         })
   end
end

function Room:draw()
   for ii = 1, self._numBookcases do
      self._bookcases[ii]:draw()
   end
end

return Room
