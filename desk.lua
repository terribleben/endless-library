Desk = {
   position = { x = 0, y = 0 },
   width = 0,
   height = 0,
   thickness = 0,
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
   -- todo: different legs
   love.graphics.rectangle(
      'line',
       self.width * 0.5 -4, self.thickness,
      8, self.height - self.thickness
   )
   love.graphics.pop()
end

function Desk:_reset()
   self.thickness = 8 * love.math.random(1, 3)
end

return Desk
