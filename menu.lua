local Geom = require 'geom'
local Touchables = require 'touchables'
local SharedState = require 'sharedstate'

local Menu = {
   touchable = nil,
   touchDelegate = nil,
}

function Menu:reset()
   self.touchable = {
      x = SharedState.viewport.width + 32,
      y = SharedState.viewport.height - 192,
      radius = 12,
   }
   self.touchDelegate = nil
end

function Menu:draw()
   love.graphics.print('endless library', 64, 64)
   love.graphics.print('hover your mouse past the edge to move', 64, 96)
   love.graphics.print('click arrows to enter', 64, 128)
end

function Menu:mousemoved(...)
end

function Menu:mousepressed(x, y)
   local touchInViewport = {
      x = x - SharedState.screen.width * 0.5 - SharedState.viewport.x,
      y = y - SharedState.screen.height * 0.5 - SharedState.viewport.y,
   }
   if Geom.distance2(touchInViewport, { x = self.touchable.x, y = self.touchable.y }) <= 12 then
      self.touchDelegate:touchablePressed(self.touchable)
   end
end

function Menu:drawTouchables(opacity)
   love.graphics.setColor(0, 1, 1, opacity)
   Touchables:drawArrow(self.touchable.x, self.touchable.y, self.touchable.radius, 0)
end

return Menu
