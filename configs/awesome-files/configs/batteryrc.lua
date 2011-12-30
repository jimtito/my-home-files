-- {{{ License
--
-- Implementation of battery widget.
--   * Manuel F. <manelfauvell@gmail.com>

-- This work is licensed under the Creative Commons Attribution-Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- }}}

-- {{{ Battery state
-- Widget icon
baticon       = widget({ type = "imagebox", name = "baticon" })
-- Register widget
vicious.register(baticon, vicious.widgets.bat, 
     function (widget, args)
	  levelbat= args[2]
	  timebat = args[3]
	  if   args[1] == "⌁" then 
	    baticon.image=image(confdir.. "/icons/battery/ac.png")
	    statebat = "Charged"
	  elseif args[1] == "+" then
	    statebat = "Charging"
	    if args[2] == 100 then
	      baticon.image=image(confdir.. "/icons/battery/ac.png")
	      statebat = "Charged"
	    elseif args[2] > 90 and args[2] < 100 then 
	      baticon.image=image(confdir.. "/icons/battery/char1.png")
	    elseif args[2] > 80 and args[2] <= 90 then
	      baticon.image=image(confdir.. "/icons/battery/char2.png")
	    elseif args[2] > 70 and args[2] <= 80 then
	      baticon.image=image(confdir.. "/icons/battery/char3.png")
	    elseif args[2] > 60 and args[2] <= 70 then
	      baticon.image=image(confdir.. "/icons/battery/char4.png")
	    elseif args[2] > 50 and args[2] <= 60 then
	      baticon.image=image(confdir.. "/icons/battery/char5.png")
	    elseif args[2] > 40 and args[2] <= 50 then
	      baticon.image=image(confdir.. "/icons/battery/char6.png")
	    elseif args[2] > 30 and args[2] <= 40 then
	      baticon.image=image(confdir.. "/icons/battery/char7.png")
	    elseif args[2] > 20 and args[2] <= 30 then
	      baticon.image=image(confdir.. "/icons/battery/char8.png")
	    elseif args[2] > 10 and args[2] <= 20 then
	      baticon.image=image(confdir.. "/icons/battery/char9.png")
	    else
	      baticon.image=image(confdir.. "/icons/battery/char10.png")
	    end
	  else
	    statebat= "Discharging"
	    if args[2] > 90 then 
	      baticon.image=image(confdir.. "/icons/battery/bat1.png")
	    elseif args[2] > 80 and args[2] <= 90 then
	      baticon.image=image(confdir.. "/icons/battery/bat2.png")
	    elseif args[2] > 70 and args[2] <= 80 then
	      baticon.image=image(confdir.. "/icons/battery/bat3.png")
	    elseif args[2] > 60 and args[2] <= 70 then
	      baticon.image=image(confdir.. "/icons/battery/bat4.png")
	    elseif args[2] > 50 and args[2] <= 60 then
	      baticon.image=image(confdir.. "/icons/battery/bat5.png")
	    elseif args[2] > 40 and args[2] <= 50 then
	      baticon.image=image(confdir.. "/icons/battery/bat6.png")
	    elseif args[2] > 30 and args[2] <= 40 then
	      baticon.image=image(confdir.. "/icons/battery/bat7.png")
	    elseif args[2] > 20 and args[2] <= 30 then
	      baticon.image=image(confdir.. "/icons/battery/bat8.png")
	    elseif args[2] > 10 and args[2] <= 20 then
	      baticon.image=image(confdir.. "/icons/battery/bat9.png")
	    elseif args[2] > 5 and args[2] <= 10 then
	      baticon.image=image(confdir.. "/icons/battery/bat10.png")
	    else
	      baticon.image=image(confdir.. "/icons/battery/bat11.png")
	      naughty.notify({ title      = "Battery Warning"
                                , text       = "Battery low! "..args[2].."% left!"
                                , timeout    = 5
                                , position   = "top_right"
                                , fg         = beautiful.fg_focus
                                , bg         = beautiful.bg_focus
                           })
	    end
	  end
      end, 
      23, "BAT1")


baticon:add_signal('mouse::enter', function ()
			   batinfo = { naughty.notify({ title      = "Battery"
                                , text       = "Level: "..levelbat.."% left!\nState: "..statebat.."\nTime: "..timebat
                                , timeout    = 5
                                , position   = "top_right"
                                , fg         = beautiful.fg_focus
                                , bg         = beautiful.bg_focus
				})
			   } end )

baticon:add_signal('mouse::leave', function () naughty.destroy(batinfo[1]) end)

-- }}}
