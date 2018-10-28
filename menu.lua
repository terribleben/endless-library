local Geom = require 'geom'
local Touchables = require 'touchables'
local SharedState = require 'sharedstate'

local Menu = {
   _touchables = nil,
   _menuItems = nil,
   touchDelegate = nil,
   seed = 424242,
   DEFAULT_SEED = 424242,
}

function Menu:reset()
   self._touchables = {}
   table.insert(self._touchables, {
      x = SharedState.viewport.width + 32,
      y = SharedState.viewport.height - 192,
      radius = 12,
      angle = 0,
   })
   self.touchDelegate = nil
   self._menuItems = {
      'increase seed',
      'decrease seed',
      'random seed'
   }
end

function Menu:draw()
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.print('endless library', 64, 64)
   love.graphics.print('hover your mouse past the edge to move', 64, 96)
   love.graphics.print('click arrows to enter', 64, 128)

   love.graphics.print('seed: ' .. self.seed, 64, 256)
   love.graphics.setColor(0, 1, 1, 1)
   for idx, item in pairs(self._menuItems) do
      love.graphics.print(item, 96, 256 + (32 * idx))
   end
end

function Menu:mousemoved(...)
end

function Menu:mousepressed(x, y)
   local touchInViewport = {
      x = x - SharedState.screen.width * 0.5 - SharedState.viewport.x,
      y = y - SharedState.screen.height * 0.5 - SharedState.viewport.y,
   }
   local pressed = self:_indexOfTouchablePressed(touchInViewport)
   if pressed >= 0 then
      local touchablePressed = self._touchables[pressed]
      self.touchDelegate:touchablePressed(touchablePressed)
      return
   end

   -- menu items
   for idx, item in pairs(self._menuItems) do
      if touchInViewport.x > 90 and touchInViewport.x < 200
         and touchInViewport.y >= 256 + (32 * idx)
         and touchInViewport.y < 256 + (32 * (idx + 1))
      then
         if idx == 1 then
            self.seed = self.seed + 1
         elseif idx == 2 then
            self.seed = self.seed - 1
         elseif idx == 3 then
            self.seed = math.random(1, 999999)
         end
         if self.seed < 1 then self.seed = 999999 end
         if self.seed > 999999 then self.seed = 1 end
      end
   end
end

function Menu:drawTouchables(opacity)
   love.graphics.setColor(0, 1, 1, opacity)
   for idx, touchable in pairs(self._touchables) do
      Touchables:drawArrow(touchable.x, touchable.y, 12, touchable.angle)
   end
end

function Menu:_indexOfTouchablePressed(touchInViewport)
   for idx, touchable in pairs(self._touchables) do
      if Geom.distance2(touchInViewport, touchable) <= touchable.radius then
         return idx
      end
   end
   return -1
end

return Menu
