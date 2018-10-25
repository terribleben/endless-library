local Exit = require 'exit'
local Geom = require 'geom'
local SharedState = require 'sharedstate'
local Room = require 'room'

Touchables = {
   _isMouseActive = false,
   _mouseTimer = 0,
   _opacity = 0,
   MOUSE_TIMER_MAX = 3,
   _touchables = {},
}

function Touchables:reset()
   self._touchables = {}
   local leftExit, rightExit
   for idx, exit in pairs(Room.exits) do
      if exit.orientation == Exit.orientations.RIGHT then
         rightExit = exit
      end
      if exit.orientation == Exit.orientations.LEFT then
         leftExit = exit
      end
   end
   if rightExit then
      table.insert(self._touchables, {
         x = SharedState.viewport.width + 32,
         y = SharedState.viewport.height - 192,
         angle = 0,
         exit = rightExit,
      })
   end
   if leftExit then
      table.insert(self._touchables, {
         x = -32,
         y = SharedState.viewport.height - 192,
         angle = math.pi,
         exit = leftExit,
      })
   end
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
end

function Touchables:draw()
   love.graphics.setColor(0, 1, 1, self._opacity)
   for idx, touchable in pairs(self._touchables) do
      self:_drawArrow(touchable.x, touchable.y, 12, touchable.angle)
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
      SharedState:nextRoom(self._touchables[pressed].exit)
   end
end

function Touchables:_drawArrow(x, y, radius, angle)
   love.graphics.push()
   love.graphics.translate(x, y)
   love.graphics.rotate(angle)
   love.graphics.circle('fill', 0, 0, radius, 3)
   love.graphics.pop()
end

function Touchables:_indexOfTouchablePressed(touchInViewport)
   for idx, touchable in pairs(self._touchables) do
      if Geom.distance2(touchInViewport, touchable) <= 12 then
         return idx
      end
   end
   return -1
end

return Touchables
