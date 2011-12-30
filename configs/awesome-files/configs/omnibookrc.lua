-- {{{ License
--
-- Implementation of omnibook widget
--   * Manuel F. <manelfauvell@gmail.com>

-- This work is licensed under the Creative Commons Attribution-Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- }}}


-- {{{ Omnibook widget
-- Touchpad icon
touchicon = widget({ type = "imagebox", name = "touchicon"})
-- Bluetooth icon
blueicon = widget({ type = "imagebox", name = "blueicon"})
-- Brightness icon
brighticon = widget({ type = "imagebox", name = "brighticon"})
-- Register widget
vicious.register(touchicon,vicious.widgets.omnibook,
      function (widget, args)
	  if args[2] == "active" then 
	    touchicon.image=image(confdir.."/icons/touch.png")
	  elseif args[2] == "noactive" then
	    touchicon.image  = image(confdir.."/icons/touchno.png")
	  else
	    touchicon.image = image(confdir.."/icons/blank.png")
	  end
	  if args[3] == "active" then 
	    blueicon.image=image(confdir.."/icons/blue.png")
	  elseif args[3] == "noactive" then
	    blueicon.image  = image(confdir.."/icons/blueno.png")
	  else
	    blueicon.image = image(confdir.. "/icons/blank.png")
	  end
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
blueicon:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.util.spawn("stopbluetooth", false) end)))
brighticon:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.util.spawn("updatebrightness assing maximo", false) end),
			   awful.button({ }, 3, function () awful.util.spawn("updatebrightness assing minimo", false) end)))
			   awful.button({ }, 4, function () awful.util.spawn("updatebrightness up", false) end),
			   awful.button({ }, 5, function () awful.util.spawn("updatebrightness down", false) end)))
-- }}}
