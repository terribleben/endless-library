local Touchables = {
   _isMouseActive = false,
   _mouseTimer = 0,
   opacity = 0,
   MOUSE_TIMER_MAX = 3,
}

function Touchables:reset()
   self._mouseTimer = 0
   self._isMouseActive = false
   self.opacity = 0
end

function Touchables:update(dt)
   if self._mouseTimer > 0 then
      self._mouseTimer = self._mouseTimer - dt
      if self._mouseTimer <= 0 then
         self._mouseTimer = 0
         self._isMouseActive = false
      end
   end

   if self._isMouseActive and self.opacity < 1 then
      self.opacity = self.opacity + (1.0 - self.opacity) * 0.1
   elseif not self._isMouseActive and self.opacity > 0 then
      self.opacity = self.opacity + (0 - self.opacity) * 0.025
   end
end

function Touchables:mousemoved(...)
   self._isMouseActive = true
   self._mouseTimer = self.MOUSE_TIMER_MAX
end

function Touchables:mousepressed(x, y, ...)
   self._isMouseActive = true
   self._mouseTimer = self.MOUSE_TIMER_MAX
end

function Touchables:drawArrow(x, y, radius, angle)
   love.graphics.push()
   love.graphics.translate(x, y)
   love.graphics.rotate(angle)
   love.graphics.circle('fill', 0, 0, radius, 3)
   love.graphics.pop()
end

return Touchables
