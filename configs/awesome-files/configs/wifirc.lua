-- {{{ License
--
-- Implementacion of wifi widget
--   * Manuel F. <manelfauvell@gmail.com>

-- This work is licensed under the Creative Commons Attribution-Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- }}}


-- {{{ Wifi widget
-- Wifi icon
wifiicon = widget({ type = "imagebox", name = "wifiicon"})
-- Register widget
vicious.register(wifiicon,vicious.widgets.wifi,
      function (widget, args)
	  essid = args['{ssid}']
	  link = args['{link}']
	  rate = args['{rate}']
	  if args['{acti}'] == 1 then
	    if args['{conn}'] == 1 then
	      if args['{link}'] >= 75 then
		wifiicon.image=image(confdir.."/icons/wifi.png")
	      elseif args['{link}'] < 75 and args['{link}'] >= 50 then
		wifiicon.image=image(confdir.."/icons/wifi2.png")
	      elseif args['{link}'] < 50 and args['{link}'] >= 25 then
		wifiicon.image=image(confdir.."/icons/wifi3.png")
	      else
		wifiicon.image=image(confdir.."/icons/wifi4.png")
	      end
	    else
	      wifiicon.image=image(confdir.."/icons/wifino.png")
	    end
	  else
	      wifiicon.image=image(nil)
	  end
      end, 61, "wlan0")

wifiicon:buttons(awful.util.table.join(
			    awful.button({ }, 1, function () awful.util.spawn("wicd-kde", false) end)))

wifiicon:add_signal('mouse::enter', function ()
			   wifiinfo = { naughty.notify({ title      = "Network:"
                                , text       = "ESSID: "..essid.."\nLink quality: "..link.."%\nRate: "..rate
                                , timeout    = 5
                                , position   = "top_right"
                                , fg         = beautiful.fg_focus
                                , bg         = beautiful.bg_focus
				})
			   } end )

wifiicon:add_signal('mouse::leave', function () naughty.destroy(wifiinfo[1]) end)

-- }}}