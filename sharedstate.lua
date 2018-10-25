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
         seedFrom = initialSeed,
   })
   love.math.setRandomSeed(initialSeed)
   print('resetting room with seed ', initialSeed)
   Room:reset()
   Room:addExits(rootExit)
   Touchables:reset()
end

function SharedState:nextRoom(exitTaken)
   -- right now a door is just a seed
   love.math.setRandomSeed(exitTaken.seedTo)
   print('exiting from seed ', exitTaken.seedFrom, ' to seed ', exitTaken.seedTo)
   Room:reset()
   Room:addExits(exitTaken)
   Touchables:reset()
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
