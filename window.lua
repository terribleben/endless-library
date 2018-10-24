Window = {
   position = { x = 0, y = 0 },
   width = 0,
   height = 0
}

function Window:new(t)
   t = t or {}
   setmetatable(t, { __index = self })
   t:_reset()
   return t
end

function Window:draw()
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.push()
   love.graphics.translate(self.position.x, self.position.y)
   love.graphics.rectangle(
      'line',
      0, 0,
      self.width, self.height
   )
   love.graphics.pop()
end

function Window:_reset()

end

return Window

