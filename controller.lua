local Map = require 'map'
local Menu = require 'menu'
local Room = require 'room'
local SharedState = require 'sharedstate'
local Transition = require 'transition'
local Touchables = require 'touchables'

local Controller = {
   mode = 0,
   modes = {
      MENU = 0,
      PLAY = 1,
   },
   initialSeed = 0,

   _isTransitioning = false,
   _transitionTimer = 0,
   _transitionDestination = 0,
}

function Controller:reset()
   self.mode = Controller.modes.MENU
   self.initialSeed = 0
   Touchables:reset()
   Menu:reset()
   Menu.touchDelegate = self
   self:_resetTransition()
end

function Controller:update(dt)
   Touchables:update(dt)
   if self.mode == Controller.modes.PLAY then
      Room:update(dt)
   end

   if self._isTransitioning then
      self._transitionTimer = self._transitionTimer - dt
      if self._transitionTimer <= 0 then
         self:_transitionFinished()
      end
   end
end

function Controller:mousemoved(...)
   Touchables:mousemoved(...)
   self:_getTouchResponder():mousemoved(...)
end

function Controller:mousepressed(...)
   Touchables:mousepressed(...)
   self:_getTouchResponder():mousepressed(...)
end

function Controller:draw()
   if self.mode == Controller.modes.PLAY then
      Room:draw()
   elseif self.mode == Controller.modes.MENU then
      Menu:draw()
   end
end

function Controller:drawTouchables()
   if not self._isTransitioning then
      self:_getTouchResponder():drawTouchables(Touchables.opacity)
   end
end

function Controller:enterLibrary(initialSeed)
   self.mode = Controller.modes.PLAY
   initialSeed = initialSeed or Menu.DEFAULT_SEED
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
   Room.touchDelegate = self
end

function Controller:exitLibrary()
   self:reset()
end

function Controller:_getTouchResponder()
   if self.mode == Controller.modes.PLAY then
      return Room
   elseif self.mode == Controller.modes.MENU then
      return Menu
   end
end

function Controller:touchablePressed(touchable)
   self._isTransitioning = true
   self._transitionTimer = Transition.TIME_OUT
   self._transitionDestination = touchable.exit
   Transition:start()
end

function Controller:_transitionFinished()
   self._isTransitioning = false
   self._transitionTimer = 0
   if self.mode == Controller.modes.MENU then
      self:enterLibrary(Menu.seed)
   else
      if self._transitionDestination.seedTo == 0 then
         self:exitLibrary()
      else
         self:nextRoom(self._transitionDestination)
      end
   end
   self:_resetTransition()
end

function Controller:_resetTransition()
   self._isTransitioning = false
   self._transitionTimer = 0
   self._transitionDestination = nil
end

return Controller
