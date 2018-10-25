local Room = require 'room'
local SharedState = require 'sharedstate'
local Touchables = require 'touchables'

G_VIEWPORT_BUFFER = 96
G_INITIAL_SEED = 424242

function love.load()
   _reset(G_INITIAL_SEED)
end

function love.draw()
   love.graphics.push()
   -- transform to viewport coords
   love.graphics.translate(SharedState.screen.width * 0.5, SharedState.screen.height * 0.5)
   love.graphics.translate(SharedState.viewport.x, SharedState.viewport.y)
   Room:draw()
   _drawViewportBorder()
   Touchables:draw()
   love.graphics.pop()
end

function love.update(dt)
   Touchables:update(dt)
end

function love.mousemoved(...)
   Touchables:mousemoved(...)
end

function love.mousepressed(...)
   Touchables:mousepressed(...)
end

function _reset(initialSeed)
   SharedState:reset(initialSeed)
end

function _drawViewportBorder()
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.rectangle(
      'line',
      0, 0,
      SharedState.viewport.width, SharedState.viewport.height
   )
   love.graphics.setColor(0, 0, 0, 1)
   love.graphics.rectangle(
      'fill',
         -G_VIEWPORT_BUFFER, 0,
      G_VIEWPORT_BUFFER, SharedState.viewport.height
   )
   love.graphics.rectangle(
      'fill',
      SharedState.viewport.width, 0,
      G_VIEWPORT_BUFFER, SharedState.viewport.height
   )
   love.graphics.rectangle(
      'fill',
      -G_VIEWPORT_BUFFER, -G_VIEWPORT_BUFFER,
      SharedState.viewport.width + 2.0 * G_VIEWPORT_BUFFER, G_VIEWPORT_BUFFER
   )
   love.graphics.rectangle(
      'fill',
      -G_VIEWPORT_BUFFER, SharedState.viewport.height,
      SharedState.viewport.width + 2.0 * G_VIEWPORT_BUFFER, G_VIEWPORT_BUFFER
   )
end
