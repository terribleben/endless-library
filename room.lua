local SharedState = require 'sharedstate'
local Bookcase = require 'bookcase'
local Desk = require 'desk'
local Exit = require 'exit'
local Map = require 'map'
local Window = require 'window'

Room = {
   _bookcases = {},
   _numBookcases = 0,
   _desks = {},
   _numDesks = 0,
   _windows = {},
   _numWindows = 0,
   exits = nil,
}

function Room:reset()
   self._bookcases = {}
   self._numBookcases = 0
   self._desks = {}
   self._numDesks = 0
   self._windows = {}
   self._numWindows = 0
   self.exits = {}
   
   local pRoomLayout = love.math.random()
   -- todo: formalize room layouts a bit more
   if pRoomLayout < 0.3 then
      self:_addUniformBookcases(0, SharedState.viewport.width)
   elseif pRoomLayout < 0.7 then
      self:_addRandomBookcases(0, SharedState.viewport.width, true)
   elseif pRoomLayout < 0.8 then
      local x, width = self:_addDesk()
      self:_addRandomBookcases(0, x, true)
      self:_addRandomBookcases(x + width, SharedState.viewport.width, true)
   else
      self:_addRandomBookcases(0, SharedState.viewport.width, false, true)
   end

   local pWindowLayout = love.math.random()
   if pWindowLayout < 0.1 then
      self:_addSingleWindow()
   elseif pWindowLayout < 0.3 then
      self:_addWindowRow()
   end
end

function Room:addExits(exitTaken)
   local currentSeed = exitTaken.seedTo
   local previousSeed, nextSeed = Map:getNeighborSeeds(currentSeed)
   local leftExit = Exit:new({
         orientation = Exit.orientations.LEFT,
         seedTo = previousSeed,
         seedFrom = currentSeed,
   })
   local rightExit = Exit:new({
         orientation = Exit.orientations.RIGHT,
         seedTo = nextSeed,
         seedFrom = currentSeed,
   })
   if previousSeed == 0 then
      -- initial room just has a right exit by default
      table.insert(self.exits, rightExit)
   else
      table.insert(self.exits, leftExit)
      table.insert(self.exits, rightExit)
   end
end

function Room:draw()
   for ii = 1, self._numWindows do
      self._windows[ii]:draw()
   end
   for ii = 1, self._numBookcases do
      self._bookcases[ii]:draw()
   end
   for ii = 1, self._numDesks do
      self._desks[ii]:draw()
   end   
end

function Room:_addSingleWindow()
   local variety = love.math.random(1, Window.NUM_VARIETIES)
   local width, height = Window.getCharacteristicSize(variety)
   local x = love.math.random() * (SharedState.viewport.width - width)
   local y = 50 + 50 * love.math.random(0, 4)
   return self:_addWindow({
         position = { x = x, y = y },
         width = width,
         height = height,
         variety = variety,
   })
end

function Room:_addWindowRow()
   local variety = love.math.random(1, Window.NUM_VARIETIES)
   local width, height = Window.getCharacteristicSize(variety)
   local spacing = 10 + 10 * love.math.random(0, 3)
   local maxNumWindows = math.floor(SharedState.viewport.width / (width + spacing))
   local numWindows = love.math.random(2, maxNumWindows)
   local totalWidth = (width * numWindows) + (spacing * (numWindows - 1))
   local xStart = (SharedState.viewport.width * 0.5) - (totalWidth * 0.5)
   local y = 50 + 50 * love.math.random(0, 4)
   for ii = 0, numWindows - 1 do
      self:_addWindow({
            position = { x = xStart + (ii * (width + spacing)), y = y },
            width = width,
            height = height,
            variety = variety,
      })
   end
   return xStart, totalWidth
end

function Room:_addWindow(w)
   self._numWindows = self._numWindows + 1
   self._windows[self._numWindows] = Window:new(w)
   return x, width
end

function Room:_addDesk()
   local width, height = 200, 75
   local x = love.math.random() * (SharedState.viewport.width - width)
   self._numDesks = self._numDesks + 1
   self._desks[self._numDesks] = Desk:new({
         position = { x = x, y = SharedState.viewport.height - height },
         width = width,
         height = height,
   })
   return x, width
end

function Room:_addUniformBookcases(xBegin, xEnd)
   local width, height = Bookcase.randomWidth(), 150 + 25 * love.math.random(4)
   local spacing = 5 * math.random(0, 6)
   local numBookcases = math.floor((xEnd - xBegin) / (width + spacing))

   -- append numBookcases new cases
   for ii = 1, numBookcases do
      self._numBookcases = self._numBookcases + 1
      self._bookcases[self._numBookcases] = Bookcase:new({
         position = { x = 0, y = SharedState.viewport.height - height },
         width = width,
         height = height,
      })
   end

   -- space evenly
   local totalWidth = (numBookcases * width) + ((numBookcases - 1) * spacing)
   local xOffset = ((xEnd - xBegin) - totalWidth) * 0.5
   for ii = 0, numBookcases - 1 do
      self._bookcases[self._numBookcases - ii].position.x =
         (ii * (width + spacing)) + xBegin + xOffset
   end
      
end

function Room:_addRandomBookcases(xBegin, xEnd, allowEmpty, isRoot)
   local x, width = self:_addRandomBookcase(xBegin, xEnd, allowEmpty and not isRoot)
   if width > 0 then
      self:_addRandomBookcases(xBegin, x, allowEmpty)
      self:_addRandomBookcases(x + width, xEnd, allowEmpty)
   end
end

-- add one bookcase somewhere between xBegin and xEnd
-- or none if nothing fits.
-- return the x, width of the resulting bookcase; or zero width if none is created.
function Room:_addRandomBookcase(xBegin, xEnd, allowEmpty)
   if allowEmpty and love.math.random() < 0.2 then
      return xEnd, 0
   end
   if xEnd - xBegin < Bookcase.sizes.NARROW then
      return xEnd, 0
   end
   
   local x, width
   repeat
      width = Bookcase.randomWidth()
   until xBegin + width < xEnd
   
   x = xBegin + love.math.random() * (xEnd - xBegin - width)

   self._numBookcases = self._numBookcases + 1
   local height = 150 + 25 * love.math.random(4)
   self._bookcases[self._numBookcases] = 
      Bookcase:new({
            position = { x = x, y = SharedState.viewport.height - height },
            width = width,
            height = height,
      })
 
   return x, width
end

return Room
