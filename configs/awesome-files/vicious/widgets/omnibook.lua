------------------------------------------------------------------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2009 Manuel F. <manelfauvell@gmail.com>
-------------------------------------------------------------------------------------------------------------------

-- {{{ Grab environment
local tonumber = tonumber
local setmetatable = setmetatable
local helpers = require("vicious.helpers")
local string = {
    find = string.find,
    match = string.match
}
-- }}}

-- Omnibook vicious. Provides state of brightness, bluetooth and touchpad of omnibook module.
module("vicious.widgets.omnibook")

function worker (format)
     local omnibook = helpers.pathtotable("/proc/omnibook")
     local touch = "N/A"
     local blue = "N/A"
     local bright = -1

     if omnibook.touchpad then  
	statustouch = omnibook.touchpad
	if string.find(statustouch, "enable", 0, true) then
	  touch = "active"
	else
	  touch = "noactive"
	end
     else
	touch = "N/A"
     end

     if omnibook.bluetooth then
	statusblue = omnibook.bluetooth
	if string.find(statusblue, "enable", 0, true) then
	  blue = "active"
	else
	  blue = "noactive"
	end
     else
	blue = "N/A"
     end

     if omnibook.lcd then
	statusbright = omnibook.lcd
	bright = tonumber(string.match(statusbright, "([%d])% %("))
     else
	bright = -1
     end

     return {bright, touch, blue}
end

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
