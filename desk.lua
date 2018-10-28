local Lamp = require 'lamp'
local Support = require 'support'

Desk = {
   position = { x = 0, y = 0 },
   width = 0,
   height = 0,
   thickness = 0,
   _supports = nil,
   _numSupports = 0,
   _lamp = nil,
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
   if self._lamp ~= nil then
      self._lamp:draw()
   end
   love.graphics.pop()
end

function Desk:_reset()
   self._supports = {}
   self._numSupports = 0
   
   self.thickness = 8 * love.math.random(1, 3)
   local numSupports = love.math.random(1, 2)
   local supportStyle = love.math.random(1, Support.NUM_STYLES)
   local supportBaseStyle = love.math.random(1, SupportSegment.NUM_STYLES)
   if numSupports == 1 then
      self:_addSupport(self.width * 0.5, self.thickness, supportStyle, supportBaseStyle, Support.orientations.CENTER)
   elseif numSupports == 2 then
      self:_addSupport(self.thickness, self.thickness, supportStyle, supportBaseStyle, Support.orientations.LEFT)
      self:_addSupport(self.width - self.thickness, self.thickness, supportStyle, supportBaseStyle, Support.orientations.RIGHT)
   end

   if love.math.random() < 0.6 then
      self._lamp = Lamp:new({
            position = { x = love.math.random(10, self.width - 10), y = -48 },
            width = 36,
            height = 48,
      })
   end
end

function Desk:_addSupport(x, width, style, baseStyle, orientation)
   self._numSupports = self._numSupports + 1
   self._supports[self._numSupports] = Support:new({
         position = { x = x, y = self.thickness },
         width = self.thickness,
         height = self.height - self.thickness,
         orientation = orientation,
         style = style,
         baseStyle = baseStyle,
   })
   return x, width
end

return Desk
