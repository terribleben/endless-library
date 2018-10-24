SupportSegment = {
   width = 0,
   height = 0,
   style = 0,
   styles = {
      RECT = 1,
   }
}

function SupportSegment:new(t)
   t = t or {}
   setmetatable(t, { __index = self })
   t:_reset()
   return t
end

function SupportSegment:draw()
   -- TODO: many styles
   if self.style == SupportSegment.styles.RECT then
      love.graphics.line(
         0, 0,
         self.width * -0.5, 0,
         self.width * -0.5, self.height,
         0, self.height
      )
   end
end

function SupportSegment:_reset()
   -- todo: different segments and styles
   self.style = SupportSegment.styles.RECT
end

return SupportSegment
