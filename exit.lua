Exit = {
   orientation = 0,
   orientations = {
      INIT = 1,
      LEFT = 2,
      RIGHT = 3,
      DOOR = 4,
   },
   seedFrom = 0,
   seedTo = 0,
}

function Exit:new(t)
   t = t or {}
   setmetatable(t, { __index = self })
   t:_reset()
   return t
end

function Exit:_reset()
end

function Exit.complement(exit)
   local inverse
   if exit.orientation == Exit.orientations.LEFT then
      inverse = Exit.orientations.RIGHT
   elseif exit.orientation == Exit.orientations.RIGHT then
      inverse = Exit.orientations.LEFT
   elseif exit.orientation == Exit.orientations.DOOR then
      inverse = Exit.orientations.DOOR
   end
   return Exit:new({
         orientation = inverse,
         seedFrom = exit.seedTo,
         seedTo = exit.seedFrom,
   })
end

return Exit
