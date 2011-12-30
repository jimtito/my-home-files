-- {{{ License
--
-- Implementation of touchpad widget
--   * Manuel F. <manelfauvell@gmail.com>

-- This work is licensed under the Creative Commons Attribution-Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- }}}

-- {{{ Touchpad widget
-- Touchpad icon
touchicon = widget({ type = "imagebox", name = "touchicon"})
-- Register widge
vicious.register(touchicon,vicious.widgets.touchpad,
      function (widget, args)
	  if args[1] == "active" then 
	    touchicon.image=image(confdir.."/icons/touch.png")
	  elseif args[1] == "noactive" then
	    touchicon.image  = image(confdir.."/icons/touchno.png")
	  else
	    touchicon.image = image(confdir.."/icons/blank.png")
	  end
      end, 11)
-- }}}