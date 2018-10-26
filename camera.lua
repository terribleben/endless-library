local SharedState = require 'sharedstate'
local Room = require 'room'

Camera = {
   x = 0,
   y = 0,
   _vx = 0,
   _vy = 0,
   _mouseRegion = 0,
   mouseRegions = {
      NONE = 0,
      RIGHT = 1,
      LEFT = 2,
   },
}

function Camera:reset()
   self.x = 0
   self.y = 0
   self._mouseRegion = Camera.mouseRegions.NONE
end

function Camera:mousemoved(x, y, ...)
   local t = {
      x = x - SharedState.screen.width * 0.5 - SharedState.viewport.x,
      y = y - SharedState.screen.height * 0.5 - SharedState.viewport.y,
   }
   if t.x >= SharedState.viewport.width
      and t.y > 0
      and t.y <= SharedState.viewport.height
   then
      self._mouseRegion = Camera.mouseRegions.RIGHT
   elseif t.x <= 0
      and t.y > 0
      and t.y <= SharedState.viewport.height
   then
      self._mouseRegion = Camera.mouseRegions.LEFT
   else
      self._mouseRegion = Camera.mouseRegions.NONE
   end
end

function Camera:update(dt)
   if self._mouseRegion == Camera.mouseRegions.RIGHT then
      self._vx = self._vx + 0.25
      if self._vx > 4 then self._vx = 6 end
   elseif self._mouseRegion == Camera.mouseRegions.LEFT then
      self._vx = self._vx - 0.25
      if self._vx < -4 then self._vx = -6 end
   else
      self._vx = self._vx * 0.85
      if math.abs(self._vx) < 0.1 then
         self._vx = 0
      end
   end

   self.x = self.x + self._vx
   self.y = self.y + self._vy

   if self.x > Room.width - SharedState.viewport.width then
      self.x = Room.width - SharedState.viewport.width
   end
   if self.x < 0 then
      self.x = 0
   end
end

function Camera:isRightRoomEdge()
   return self.x >= Room.width - SharedState.viewport.width
end

function Camera:isLeftRoomEdge()
   return self.x <= 0
end

return Camera
