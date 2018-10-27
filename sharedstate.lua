local SharedState = {
   screen = { width = 0, height = 0 },
   viewport = { x = 0, y = 0, width = 0, height = 0 },
}

function SharedState:reset()
   self:_reset()
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
