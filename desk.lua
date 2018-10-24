local Support = require 'support'

Desk = {
   position = { x = 0, y = 0 },
   width = 0,
   height = 0,
   thickness = 0,
   _supports = {},
   _numSupports = 0,
}

function Desk:new(t)
   t = t or {}
   setmetatable(t, { __index = self })
   t:_reset()
   return t
end

function Desk:draw()
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.push()
   love.graphics.translate(self.position.x, self.position.y)
   love.graphics.rectangle(
      'line',
      0, 0,
      self.width, self.thickness
   )
   for ii = 1, self._numSupports do
      self._supports[ii]:draw()
   end
   love.graphics.pop()
end

function Desk:_reset()
   self._supports = {}
   self._numSupports = 0
   
   self.thickness = 8 * love.math.random(1, 3)
   local numSupports = love.math.random(1, 2)
   local supportStyle = love.math.random(1, Support.NUM_STYLES)
   if numSupports == 1 then
      self:_addSupport(self.width * 0.5, self.thickness, supportStyle, Support.orientations.CENTER)
   elseif numSupports == 2 then
      self:_addSupport(self.thickness, self.thickness, supportStyle, Support.orientations.LEFT)
      self:_addSupport(self.width - self.thickness, self.thickness, supportStyle, Support.orientations.RIGHT)
   end
end

function Desk:_addSupport(x, width, style, orientation)
   self._numSupports = self._numSupports + 1
   self._supports[self._numSupports] = Support:new({
         position = { x = x, y = self.thickness },
         width = self.thickness,
         height = self.height - self.thickness,
         orientation = orientation,
         style = style,
   })
   return x, width
end

return Desk
