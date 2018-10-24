local SharedState = require 'sharedstate'
local Room = require 'room'

function love.load()
   love.math.setRandomSeed(42)
   _reset()
end

function love.draw()
   love.graphics.push()
   -- transform to viewport coords
   love.graphics.translate(SharedState.screen.width * 0.5, SharedState.screen.height * 0.5)
   love.graphics.translate(SharedState.viewport.x, SharedState.viewport.y)
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.rectangle(
      'line',
      0, 0,
      SharedState.viewport.width, SharedState.viewport.height
   )
   Room:draw()
   love.graphics.pop()
end

function love.update(dt)
end

function love.keypressed(key, ...)
   if key == 'space' then
      local seed = math.random(99999) -- not using love's implementation
      love.math.setRandomSeed(seed)
      print('rendering room with seed: ', seed)
      _reset()
   end
end

function _reset()
   SharedState:reset()
   Room:reset()
end
