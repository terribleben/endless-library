local Menu = {
}

function Menu:draw()
   love.graphics.print('endless library', 64, 64)
   love.graphics.print('hover your mouse past the edge to move', 64, 96)
   love.graphics.print('click arrows to enter', 64, 128)
end

return Menu
