Window = {
   position = { x = 0, y = 0 },
   width = 0,
   height = 0,
   variety = {
      PANE_SIMPLE = 1,
      PANE_FACTORY = 2,
      PANE_ARCH = 3,
   },
   NUM_VARIETIES = 3,
}

function Window:new(t)
   t = t or {}
   setmetatable(t, { __index = self })
   t:_reset()
   return t
end

function Window.getCharacteristicSize(variety)
   local width, height = 0, 0
   if variety == Window.variety.PANE_SIMPLE
   or variety == Window.variety.PANE_FACTORY
   then
      width = 50 + 25 * love.math.random(0, 8)
      local ratio
      if width > 200 then
         ratio = 0.6 + 0.1 * love.math.random(0, 2)
      elseif width <= 100 then
         ratio = 1 + 0.5 * love.math.random(0, 3)
      else
         ratio = 0.6 + 0.1 * love.math.random(0, 4)
      end
      height = width * ratio
   elseif variety == Window.variety.PANE_ARCH then
      width = 75 + 25 * love.math.random(0, 2)
      height = 150 + 25 * love.math.random(0, 2)
   end
   return width, height
end

function Window:draw()
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.push()
   love.graphics.translate(self.position.x, self.position.y)
   love.graphics.rectangle(
      'line',
      0, 0,
      self.width, self.height
   )
   if self.variety == Window.variety.PANE_SIMPLE then
      love.graphics.line(
         0, self.height * 0.5,
         self.width, self.height * 0.5
      )
      love.graphics.line(
         self.width * 0.5, 0,
         self.width * 0.5, self.height
      )
   elseif self.variety == Window.variety.PANE_FACTORY then
      love.graphics.line(
         0, self._inset,
         self.width, self._inset
      )
      love.graphics.line(
         self._inset, 0,
         self._inset, self.height
      )
      love.graphics.line(
         self.width - self._inset, 0,
         self.width - self._inset, self.height
      )
   elseif self.variety == Window.variety.PANE_ARCH then
      love.graphics.line(
         self._inset, 0,
         self._inset, self.height
      )
      love.graphics.line(
         self.width - self._inset, 0,
         self.width - self._inset, self.height
      )
      love.graphics.arc(
         'line',
         self.width * 0.5, 0,
         self.width * 0.5, -- radius
         0, -math.pi,
         16
      )
      love.graphics.arc(
         'line',
         self.width * 0.5, 0,
         self._inset, -- radius
         0, -math.pi,
         16
      )
   end
   love.graphics.pop()
end

function Window:_reset()
   if self.variety == Window.variety.PANE_FACTORY then
      self._inset = math.min(self.width, self.height) * 0.15
   elseif self.variety == Window.variety.PANE_ARCH then
      self._inset = self.width * 0.25
   end
end

return Window
