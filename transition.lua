local SharedState = require 'sharedstate'

Transition = {
   TIME_OUT = 0.6,
   TIME_IN = 0.4,
   _state = 0,
   _timer = 0,
   _states = {
      INACTIVE = 0,
      ACTIVE_OUT = 1,
      ACTIVE_IN = 2,
   },
}

function Transition.getTotalTime()
   return Transition.TIME_OUT + Transition.TIME_IN
end

function Transition:start()
   self._state = Transition._states.ACTIVE_OUT
   self._timer = Transition.TIME_OUT
end

function Transition:update(dt)
   if self._state > 0 then
      self._timer = self._timer - dt
      if self._timer <= 0 then
         self:_advanceState()
      end
   end
end

function Transition:draw()
   if self._state > 0 then
      if self._state == Transition._states.ACTIVE_OUT then
         love.graphics.setColor(0, 0, 0, 1.0 - (self._timer / Transition.TIME_OUT))
      elseif self._state == Transition._states.ACTIVE_IN then
         love.graphics.setColor(0, 0, 0, self._timer / Transition.TIME_IN)
      end
      love.graphics.rectangle(
         'fill',
         0, 0,
         SharedState.viewport.width, SharedState.viewport.height
      )
   end
end

function Transition:_advanceState()
   if self._state == Transition._states.ACTIVE_OUT then
      self._state = Transition._states.ACTIVE_IN
      self._timer = Transition.TIME_IN
   elseif self._state == Transition._states.ACTIVE_IN then
      self._state = Transition._states.INACTIVE
      self._timer = 0
   end
end

return Transition
