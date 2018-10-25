local SupportSegment = require 'supportsegment'

Lamp = {
   position = { x = 0, y = 0 },
   width = 0,
   height = 0,
   _segments = nil,
   _numSegments = 0,
}

function Lamp:new(t)
   t = t or {}
   setmetatable(t, { __index = self })
   t:_reset()
   return t
end

function Lamp:draw()
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.push()
   love.graphics.translate(self.position.x, self.position.y)
   self:_drawSegments()
   love.graphics.scale(-1, 1) -- all supports are y-axis symmetrical
   self:_drawSegments()
   love.graphics.pop()
end

function Lamp:_drawSegments()
   love.graphics.push()
   for ii = 1, self._numSegments do
      self._segments[ii]:draw()
      love.graphics.translate(0, self._segments[ii].height)
   end
   love.graphics.pop()
end

function Lamp:_reset()
   self._numSegments = 0
   self._segments = {}
   
   local baseWidth, baseHeight =
      self.baseWidth or self.width * 0.8,
      self.baseHeight or math.ceil(self.height * (0.1 + 0.05 * math.random(0, 2)))
   local shadeHeight = math.ceil(self.height * (0.4 + 0.1 * math.random(0, 3)))
   local neckWidth = self.neckWidth or self.width * (0.2 + 0.1 * math.random(0, 2))
   self:_addSegment({
         width = self.width,
         height = shadeHeight,
         style = SupportSegment.styles.LAMP_TRAP,
   })
   self:_addSegment({
         width = neckWidth,
         height = self.height - baseHeight - shadeHeight,
   })
   self:_addSegment({
         width = baseWidth,
         height = baseHeight,
         style = SupportSegment.styles.RECT,
   })
end

function Lamp:_addSegment(s)
   self._numSegments = self._numSegments + 1
   self._segments[self._numSegments] = SupportSegment:new(s)
end

return Lamp
