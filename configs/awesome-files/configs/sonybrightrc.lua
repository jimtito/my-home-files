-- {{{ License
--
-- Implementation of sonybright widget
--   * Manuel F. <manelfauvell@gmail.com>

-- This work is licensed under the Creative Commons Attribution-Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- }}}

-- {{{ sonybright widget
-- Brightness icon
brighticon = widget({ type = "imagebox", name = "brighticon"})
-- Register widget
vicious.register(brighticon,vicious.widgets.sonybright,
      function (widget, args)
	  if args[1] == 0 then
	    brighticon.image=image(confdir.."/icons/brightness/brightness8.png")
	  elseif args[1] == 1 then
	    brighticon.image=image(confdir.."/icons/brightness/brightness7.png")
	  elseif args[1] == 2 then
	    brighticon.image=image(confdir.."/icons/brightness/brightness6.png")
	  elseif args[1] == 3 then
	    brighticon.image=image(confdir.."/icons/brightness/brightness5.png")
	  elseif args[1] == 4 then
	    brighticon.image=image(confdir.."/icons/brightness/brightness4.png")
	  elseif args[1] == 5 then
	    brighticon.image=image(confdir.."/icons/brightness/brightness3.png")
	  elseif args[1] == 6 then
	    brighticon.image=image(confdir.."/icons/brightness/brightness2.png")
	  elseif args[1] == 7 then
	    brighticon.image=image(confdir.."/icons/brightness/brightness1.png")
	  else
	    brighticon.image=image(confdir.."/icons/blank.png")
	  end
      end, 11)
brighticon:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.util.spawn("updatebrightness -max", false) end),
			   awful.button({ }, 3, function () awful.util.spawn("updatebrightness -min", false) end)))
--			   awful.button({ }, 4, function () awful.util.spawn("updatebrightness up", false) end),
--			   awful.button({ }, 5, function () awful.util.spawn("updatebrightness down", false) end)))
-- }}}
