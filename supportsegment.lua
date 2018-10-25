SupportSegment = {
   width = 0,
   height = 0,
   style = 0,
   styles = {
      RECT = 1,
      ELLIPSOID = 2,
      LAMP_TRAP = 1001, -- only available to lamp
   },
   NUM_STYLES = 2,
}

function SupportSegment:new(t)
   t = t or {}
   setmetatable(t, { __index = self })
   t:_reset()
   return t
end

function SupportSegment:draw()
   love.graphics.setColor(1, 1, 1, 1)
   if self.style == SupportSegment.styles.RECT then
      love.graphics.line(
         0, 0,
         self.width * -0.5, 0,
         self.width * -0.5, self.height,
         0, self.height
      )
   elseif self.style == SupportSegment.styles.ELLIPSOID then
      local xJoin = math.ceil(self.width * 0.5 - self.height * 0.5)
      love.graphics.arc(
         'line',
         xJoin, self.height * 0.5,
         self.height * 0.5,
         math.pi * 0.5, math.pi * -0.5,
         8
      )
      love.graphics.line(
         0, 0,
         xJoin, 0
      )
      love.graphics.line(
         0, self.height,
         xJoin, self.height
      )
      love.graphics.setColor(0, 0, 0, 1)
      love.graphics.rectangle('fill', -(xJoin + 1), 0, (xJoin + 1) * 2, self.height)
   elseif self.style == SupportSegment.styles.LAMP_TRAP then
      love.graphics.line(
         0, 0,
         self.width * -0.2, 0,
         self.width * -0.5, self.height,
         0, self.height
      )
   end
end

function SupportSegment:_reset()
   -- todo: different segments and styles
   if self.style < 1 then self.style = SupportSegment.styles.RECT end
end

return SupportSegment
