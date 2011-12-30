-- {{{ License
--
-- Implementation of volume widget
--   * Manuel F. <manelfauvell@gmail.com>

-- This work is licensed under the Creative Commons Attribution-Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- }}}


-- {{{ Volume state
-- Widget
volicon	= widget({ type = "imagebox", name = "volicon" })
-- Register widget
vicious.register(volicon, vicious.widgets.volume, 
      function (widget, args)
	  if args[1] == 0 or args[2] == "♩" then 
	    volicon.image=image(confdir.."/icons/vol-mute.png")
	  elseif args[1] > 66 then
	    volicon.image=image(confdir.."/icons/vol-hi.png")
	  elseif args[1] > 33 and args[1] <= 66 then
	    volicon.image=image(confdir.."/icons/vol-med.png")
	  else
	    volicon.image  = image(confdir.."/icons/vol-low.png")
	  end
      end, 
      2, "Master")
--Mouse buttons
volicon:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.util.spawn("amixer -q sset Master toggle", false) end),
                           awful.button({ }, 4, function () awful.util.spawn("amixer -q sset Master 1%+",false) end),
                           awful.button({ }, 5, function () awful.util.spawn("amixer -q sset Master 1%-",false) end)))
-- }}}