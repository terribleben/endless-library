Book = {
   position = { x = 0, y = 0 },
   width = 0,
   height = 0,
   angle = 0,
   PULP_HEIGHT = 30,
   PAPERBACK_HEIGHT = 42,
}

function Book:new(b)
   b = b or {}
   setmetatable(b, { __index = self })
   return b
end

function Book:draw()
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.push()
   love.graphics.translate(self.position.x, self.position.y)
   love.graphics.rotate(self.angle)
   love.graphics.rectangle(
      'line',
      -self.width * 0.5, -self.height * 0.5,
      self.width, self.height
   )
   love.graphics.pop()
end

return Book
