------------------------------------------------------------------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2010 Manuel F. <manelfauvell@gmail.com>
-------------------------------------------------------------------------------------------------------------------

-- {{{ Grab environment
local tonumber = tonumber
local setmetatable = setmetatable
local io = { 
	open = io.open,
	popen = io.popen
}
local string = { find = string.find }
-- }}}

-- Sonybright vicious. Provides state of brightness for sony vaio laptops with dual vga intel/nvidia.
module("vicious.widgets.sonybright")

function worker (format)

     local bright = -1
     local f = io.popen("lspci | grep VGA")
     local hard = f:read("*all")
     f:close()

     if string.find(hard, "nVidia", 0, true) then
	  h = io.open("/tmp/bright")
	  bright = tonumber(h:read("*all"))
	  h:close()
     else
	  g = io.open("/sys/class/backlight/sony/actual_brightness")
	  bright = tonumber(g:read("*all"))
	  g:close()
     end
     
     return {bright}
end

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
