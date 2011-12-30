-- {{{ License
--
-- Implementation of mail widget
--   * Manuel F. <manelfauvell@gmail.com>

-- This work is licensed under the Creative Commons Attribution-Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- }}}


-- {{{ Mail widget
-- Init widget
 mailwidget = widget({ type = "imagebox", name = "mailwidget"})

-- Register widget

 vicious.register(mailwidget,vicious.widgets.mdir,
      function (widget, args)
	if args[1] == 0 then
	  mailwidget.image=image(nil)
	else
	  mailwidget.image=image(confdir.."/icons/mailsi.png")
	end
      end, 301, "/home/fauvell/Mail/inbox")

-- }}}
