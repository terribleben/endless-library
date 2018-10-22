local SharedState = require 'sharedstate'
local Bookcase = require 'bookcase'

Room = {
   bookcase = nil,
}

function Room:reset()
   self.bookcase = Bookcase:new({
         position = { x = 500, y = SharedState.viewport.height - 200 },
         width = 150,
         height = 200,
   })
end

function Room:draw()
   self.bookcase:draw()
end

return Room
