local SupportSegment = require 'supportsegment'

Support = {
   position = { x = 0, y = 0 },
   width = 0,
   height = 0,
   orientation = 0,
   orientations = {
      CENTER = 1,
      LEFT = 2,
      RIGHT = 3,
   },
   style = 0,
   styles = {
      RECT = 1,
      SMALL_BASE = 2,
      LARGE_BASE = 3,
   },
   NUM_STYLES = 3,
   _segments = {},
   _numSegments = {},
}

function Support:new(t)
   t = t or {}
   setmetatable(t, { __index = self })
   t:_reset()
   return t
end

function Support:draw()
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.push()
   love.graphics.translate(self.position.x, self.position.y)
   self:_drawSegments()
   love.graphics.scale(-1, 1) -- all supports are y-axis symmetrical
   self:_drawSegments()
   love.graphics.pop()
end

function Support:_drawSegments()
   love.graphics.push()
   for ii = 1, self._numSegments do
      self._segments[ii]:draw()
      love.graphics.translate(0, self._segments[ii].height)
   end
   love.graphics.pop()
end

function Support:_reset()
   self._numSegments = 0
   self._segments = {}
   if self.style < 1 then self.style = Support.styles.RECT end
   if self.baseStyle < 1 then self.baseStyle = SupportSegment.styles.RECT end
   
   if self.style == Support.styles.RECT then
      self:_addSegment({
         width = self.width,
         height = self.height,
      })
   elseif self.style == Support.styles.SMALL_BASE then
      local baseWidth, baseHeight = math.ceil(self.width * 0.8), 6
      self:_addSegment({
         width = self.width,
         height = self.height - baseHeight,
      })
      self:_addSegment({
         width = baseWidth,
         height = baseHeight,
         style = self.baseStyle,
      })
   elseif self.style == Support.styles.LARGE_BASE then
      local baseWidth, baseHeight = math.ceil(self.width * 1.2), 8
      self:_addSegment({
         width = self.width,
         height = self.height - baseHeight,
      })
      self:_addSegment({
         width = baseWidth,
         height = baseHeight,
         style = self.baseStyle,
      })
   end
end

function Support:_addSegment(s)
   self._numSegments = self._numSegments + 1
   self._segments[self._numSegments] = SupportSegment:new(s)
end

return Support
