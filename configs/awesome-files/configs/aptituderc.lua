-- {{{ License
--
-- Implementation of aptitude widget
--   * Manuel F. <manelfauvell@gmail.com>

-- This work is licensed under the Creative Commons Attribution-Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- }}}


-- {{{ Aptitude widget
-- Init widget
aptwidget = widget({ type = "imagebox", name = "aptwidget"})

-- Register widget
vicious.register(aptwidget,vicious.widgets.aptitude,
      function (widget, args)
	aptupdate = args[1]
	if args[1] == 0 then
	  aptwidget.image=image(nil)
	else
	  aptwidget.image=image(confdir.."/icons/aptsi.png")
	end
      end,511)

aptwidget:add_signal('mouse::enter', function ()
			   aptinfo = { naughty.notify({ title      = "Updates:"
                                , text       = aptupdate.." packages."
                                , timeout    = 5
                                , position   = "top_right"
                                , fg         = beautiful.fg_focus
                                , bg         = beautiful.bg_focus
				})
			   } end )

aptwidget:add_signal('mouse::leave', function () naughty.destroy(aptinfo[1]) end)

--}}}