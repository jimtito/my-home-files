-- {{{ License
--
-- Implementation of vaiopower widget.
--   * Manuel F. <manelfauvell@gmail.com>

-- This work is licensed under the Creative Commons Attribution-Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- }}}

-- {{{ Fanspeed
-- Widget icon
fanicon       = widget({ type = "imagebox", name = "fanicon" })
-- Register widget
vicious.register(fanicon, vicious.widgets.vaiopower, 
     function (widget, args)
	  debug = args[5]
	  if   args[5] == 0 then 
	    fanicon.image=image(confdir.. "/icons/fan4.png")
	  elseif args[5] > 191 and args[5] <= 255 then 
	    fanicon.image=image(confdir.. "/icons/fan.png")
	  elseif args[5] > 127 and args[5] <= 191 then
	    fanicon.image=image(confdir.. "/icons/fan1.png")
	  elseif args[5] > 64 and args[5] <= 127 then
	    fanicon.image=image(confdir.. "/icons/fan2.png")
	  elseif args[5] > 0 and args[5] <= 64 then
	    fanicon.image=image(confdir.. "/icons/fan3.png")
	  else
	    fanicon.image=image(nil)
	  end
      end, 
      31)
-- }}}