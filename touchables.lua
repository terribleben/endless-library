local Controller = require 'controller'
local Exit = require 'exit'
local Geom = require 'geom'
local SharedState = require 'sharedstate'
local Room = require 'room'
local Transition = require 'transition'

Touchables = {
   _isMouseActive = false,
   _mouseTimer = 0,
   _opacity = 0,
   _isTransitioning = false,
   _transitionTimer = 0,
   _transitionDestination = 0,
   MOUSE_TIMER_MAX = 3,
}

function Touchables:reset()
   self._isTransitioning = false
   self._transitionTimer = 0
   self._transitionDestination = 0
end

function Touchables:update(dt)
   if self._mouseTimer > 0 then
      self._mouseTimer = self._mouseTimer - dt
      if self._mouseTimer <= 0 then
         self._mouseTimer = 0
         self._isMouseActive = false
      end
   end

   if self._isMouseActive and self._opacity < 1 then
      self._opacity = self._opacity + (1.0 - self._opacity) * 0.1
   elseif not self._isMouseActive and self._opacity > 0 then
      self._opacity = self._opacity + (0 - self._opacity) * 0.025
   end

   if self._isTransitioning then
      self._transitionTimer = self._transitionTimer - dt
      if self._transitionTimer <= 0 then
         self:_transitionFinished()
      end
   end
end

function Touchables:draw()
   if not self._isTransitioning then
      love.graphics.setColor(0, 1, 1, self._opacity)
      for idx, touchable in pairs(Controller.touchables) do
         if touchable.isAvailable then
            self:_drawArrow(touchable.x, touchable.y, 12, touchable.angle)
         end
      end
   end
end

function Touchables:mousemoved(...)
   self._isMouseActive = true
   self._mouseTimer = self.MOUSE_TIMER_MAX
end

function Touchables:mousepressed(x, y, ...)
   self._isMouseActive = true
   self._mouseTimer = self.MOUSE_TIMER_MAX
   
   local touchInViewport = {
      x = x - SharedState.screen.width * 0.5 - SharedState.viewport.x,
      y = y - SharedState.screen.height * 0.5 - SharedState.viewport.y,
   }
   local pressed = self:_indexOfTouchablePressed(touchInViewport)
   if pressed >= 0 then
      local touchablePressed = Controller.touchables[pressed]
      if touchablePressed.isAvailable then
         self._isTransitioning = true
         self._transitionTimer = Transition.TIME_OUT
         self._transitionDestination = touchablePressed.exit
         Transition:start()
      end
   end
end

function Touchables:_transitionFinished()
   self._isTransitioning = false
   self._transitionTimer = 0
   if Controller.mode == Controller.modes.MENU then
      Controller:enterLibrary()
   else
      Controller:nextRoom(self._transitionDestination)
   end
   self:reset()
end

function Touchables:_drawArrow(x, y, radius, angle)
   love.graphics.push()
   love.graphics.translate(x, y)
   love.graphics.rotate(angle)
   love.graphics.circle('fill', 0, 0, radius, 3)
   love.graphics.pop()
end

function Touchables:_indexOfTouchablePressed(touchInViewport)
   for idx, touchable in pairs(Controller.touchables) do
      if Geom.distance2(touchInViewport, touchable) <= 12 then
         return idx
      end
   end
   return -1
end

return Touchables
