local Camera = require 'camera'
local Map = require 'map'
local Menu = require 'menu'
local Room = require 'room'
local SharedState = require 'sharedstate'

local Controller = {
   mode = 0,
   modes = {
      MENU = 0,
      PLAY = 1,
   },
   initialSeed = 0,
   DEFAULT_SEED = 424242,
   touchables = nil,
   _touchableLeft = nil,
   _touchableRight = nil,
}

function Controller:reset()
   self.mode = Controller.modes.MENU
   self.initialSeed = 0
   self:_computeTouchables()
end

function Controller:update(dt)
   if self.mode == Controller.modes.PLAY then
      Camera:update(dt)
      if self._touchableRight then
         self._touchableRight.isAvailable = self:canAdvanceRight()
      end
      if self._touchableLeft then
         self._touchableLeft.isAvailable = self:canAdvanceLeft()
      end
   end
end

function Controller:mousemoved(...)
   if self.mode == Controller.modes.PLAY then
      Camera:mousemoved(...)
   end
end

function Controller:draw()
   if self.mode == Controller.modes.PLAY then
      love.graphics.push()
      love.graphics.translate(-Camera.x, -Camera.y)
      Room:draw()
      love.graphics.pop()
   elseif self.mode == Controller.modes.MENU then
      Menu:draw()
   end
end

function Controller:enterLibrary(initialSeed)
   self.mode = Controller.modes.PLAY
   initialSeed = initialSeed or Controller.DEFAULT_SEED
   self.initialSeed = initialSeed
   local rootExit = Exit:new({
         orientation = Exit.orientations.INIT,
         seedTo = initialSeed,
         seedFrom = 0,
   })
   Map:reset(initialSeed)
   self:nextRoom(rootExit)
end

function Controller:nextRoom(exitTaken)
   love.math.setRandomSeed(exitTaken.seedTo)
   Room:reset()
   Room:addExits(exitTaken)
   Camera:reset(exitTaken)
   self:_computeTouchables()
end

function Controller:canAdvanceRight()
   return Camera:isRightRoomEdge()
end

function Controller:canAdvanceLeft()
   return Camera:isLeftRoomEdge()
end

function Controller:_computeTouchables()
   self.touchables = {}
   self._touchableLeft = nil
   self._touchableRight = nil
   
   local leftExit, rightExit
   if self.mode == Controller.modes.PLAY then
      for idx, exit in pairs(Room.exits) do
         if exit.orientation == Exit.orientations.RIGHT then
            rightExit = exit
         end
         if exit.orientation == Exit.orientations.LEFT then
            leftExit = exit
         end
      end
   end
   if rightExit or self.mode == Controller.modes.MENU then
      self._touchableRight = {
         x = SharedState.viewport.width + 32,
         y = SharedState.viewport.height - 192,
         angle = 0,
         exit = rightExit,
         isAvailable = true,
      }
      table.insert(self.touchables, self._touchableRight)
   end
   if leftExit then
      self._touchableLeft = {
         x = -32,
         y = SharedState.viewport.height - 192,
         angle = math.pi,
         exit = leftExit,
         isAvailable = true,
      }
      table.insert(self.touchables, self._touchableLeft)
   end
end

return Controller
