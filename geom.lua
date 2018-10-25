Geom = {}

function Geom.distance2(pos1, pos2)
   return Geom.distance(pos1.x, pos1.y, pos2.x, pos2.y)
end

function Geom.distance(x1, y1, x2, y2)
   local dx, dy = x2 - x1, y2 - y1
   return math.sqrt(dx * dx + dy * dy)
end

return Geom
