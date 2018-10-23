Book = {
   position = { x = 0, y = 0 },
   width = 0,
   height = 0,
}

function Book:new(b)
   b = b or {}
   setmetatable(b, { __index = self })
   return b
end

function Book:draw()
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.rectangle(
      'line',
      self.position.x, self.position.y,
      self.width, self.height
   )
end

return Book
