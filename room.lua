local SharedState = require 'sharedstate'
local Exit = require 'exit'
local Map = require 'map'
local Window = require 'window'
local Zone = require 'zone'

Room = {
   exits = nil,
   width = 0,
   height = 0,
   _zones = nil,
   _numZones = 0,
   _windows = nil,
   _numWindows = 0,
}

function Room:reset()
   self._zones = {}
   self._numZones = 0
   self._windows = {}
   self._numWindows = 0
   self.exits = {}

   local pRoomSize = love.math.random()
   local minWidth = math.max(800, SharedState.viewport.width)
   if pRoomSize < 0.4 then
      -- chamber
      self.width = minWidth
   elseif pRoomSize < 0.8 then
      -- room
      self.width = minWidth + 100 * love.math.random(2, 7)
   else
      -- hall
      self.width = 2000 + 200 * love.math.random(0, 5)
   end
   self.height = SharedState.viewport.height
   
   -- local pRoomLayout = love.math.random()
   -- todo: formalize room layouts a bit more
   -- todo: multiple zones
   self:_addZone({
         position = { x = 0, y = 0 },
         width = self.width,
         height = self.height,
   })
 
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
   for ii = 1, self._numZones do
      self._zones[ii]:draw()
   end
end

function Room:_addSingleWindow()
   local variety = love.math.random(1, Window.NUM_VARIETIES)
   local width, height = Window.getCharacteristicSize(variety)
   local x = love.math.random() * (self.width - width)
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
   local maxNumWindows = math.floor(self.width / (width + spacing))
   local numWindows = love.math.random(2, maxNumWindows)
   local totalWidth = (width * numWindows) + (spacing * (numWindows - 1))
   local xStart = (self.width * 0.5) - (totalWidth * 0.5)
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
end

function Room:_addZone(z)
   self._numZones = self._numZones + 1
   self._zones[self._numZones] = Zone:new(z)
end

return Room
