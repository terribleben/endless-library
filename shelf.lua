Shelf = {
   position = { x = 0, y = 0 },
   width = 0,
   height = 0,
}

function Shelf:new(s)
   s = s or {}
   setmetatable(s, { __index = self })
   return s
end

function Shelf:draw()
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.line(
      self.position.x, self.position.y + self.height,
      self.position.x + self.width, self.position.y + self.height
   )
end

return Shelf
