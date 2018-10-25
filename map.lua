local bit = require 'bit'

Map = {
   initialSeed = 0,
   nodes = nil,
}

local MapNode = {
   id = 0,
   accumulatedId = 0,
   previousId = 0,
   nextId = 0,
}

function MapNode:new(t)
   t = t or {}
   setmetatable(t, { __index = self })
   return t
end

function Map:reset(initialSeed)
   self.nodes = {}
   self.initialSeed = initialSeed
   self:_addNode({
         id = initialSeed,
         accumulatedId = initialSeed,
   })
end

-- return previous, next
function Map:getNeighborSeeds(seed)
   local node = self.nodes[seed]
   if node ~= nil then
      if node.nextId == 0 then
         love.math.setRandomSeed(node.accumulatedId)
         local nextId = love.math.random(1, 99999)
         self:_addNode({
               id = nextId,
               accumulatedId = bit.bxor(node.accumulatedId, nextId),
               previousId = node.id,
         })
         node.nextId = nextId
      end
      return node.previousId, node.nextId
   end
   -- TODO: if we dont have this seed we could incrementally get here
   -- from root.
   return 0, 0
end

function Map:_addNode(node)
   self.nodes[node.id] = MapNode:new(node)
end

return Map
