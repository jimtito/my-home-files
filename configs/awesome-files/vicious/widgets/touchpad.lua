------------------------------------------------------------------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2010 Manuel F. <manelfauvell@gmail.com>
-------------------------------------------------------------------------------------------------------------------

-- {{{ Grab environment
local tonumber = tonumber
local setmetatable = setmetatable
local io = { popen = io.popen }
local string = { find = string.find }
-- }}}

-- Touchpad vicious. Provides state of touchpad synaptic.
module("vicious.widgets.touchpad")

function worker (format)

     local touch = "active"
     local f = io.popen("synclient -l | grep TouchpadOff")
     local state = f:read("*all")
     f:close()

     if string.find(state, "0", 0, true) then
	  touch = "active"
     else
	  touch = "noactive"
     end
     
     return {touch}
end

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
