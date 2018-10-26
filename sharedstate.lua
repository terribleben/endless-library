local Map = require 'map'

SharedState = {
   screen = { width = 0, height = 0 },
   viewport = { x = 0, y = 0, width = 0, height = 0 },
   initialSeed = 0,
}

function SharedState:reset(initialSeed)
   self:_reset()
   self.initialSeed = initialSeed
   local rootExit = Exit:new({
         orientation = Exit.orientations.INIT,
         seedTo = initialSeed,
         seedFrom = 0,
   })
   Map:reset(initialSeed)
   self:nextRoom(rootExit)
end

function SharedState:nextRoom(exitTaken)
   love.math.setRandomSeed(exitTaken.seedTo)
   Room:reset()
   Room:addExits(exitTaken)
   Touchables:reset()
   Camera:reset(exitTaken)
end

function SharedState:_reset()
   local width, height, flags = love.window.getMode()
   self.screen.width = width
   self.screen.height = height
   self.viewport.width = math.min(800, self.screen.width)
   self.viewport.height = math.min(600, self.screen.height)
   self.viewport.x = self.viewport.width * -0.5
   self.viewport.y = self.viewport.height * -0.5
end

return SharedState
