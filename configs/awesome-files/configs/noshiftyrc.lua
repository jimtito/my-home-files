-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Widget library
require("vicious")
-- Dynamic tagging
require("eminent")

-- Load Debian menu entries
--require("debian.menu")

-- Variable with the config directory
confdir = awful.util.getdir("config")

-- Custom theme
beautiful.init( confdir.."/themes/oscur/theme.lua")


-- {{{ Variable definitions
-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
browser ="uzbl"

-- Aliases
install = terminal .. " -name install -e aptitude"
mixer = terminal .. " -name mixer -e alsamixer"
ncmpc = terminal .. " -name ncmpc -e ncmpc"
vim = terminal .. " -name vim -e vim"
mc = terminal.. " -name mc -e mc"
kismet = terminal.. " -name kismet -e sudo kismet"
messenger = terminal.. " -name centerim -e centerim-utf8"


-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,  --1
    awful.layout.suit.tile.left, --2
    awful.layout.suit.tile.bottom, --3
    awful.layout.suit.tile.top, --4
    awful.layout.suit.fair, --5
    awful.layout.suit.fair.horizontal, --6
    awful.layout.suit.spiral, --7
    awful.layout.suit.spiral.dwindle, --8
    awful.layout.suit.max, --9
    awful.layout.suit.max.fullscreen,  --10
    awful.layout.suit.magnifier, --11
    awful.layout.suit.floating --12
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
tags.settings = {
    { name = "main",  layout = layouts[1]  },
    { name = "www", layout = layouts[9]  },
    { name = "im",   layout = layouts[1]  },
    { name = "doc",  layout = layouts[1]  },
    { name = "admin",    layout = layouts[3]  },
    { name = "multi",     layout = layouts[3]  },
    { name = "net",     layout = layouts[3]  },
    { name = "vbox",   layout = layouts[3]  },
    { name = "other", layout = layouts[1]  }
}

for s = 1, screen.count() do
    tags[s] = {}
    for i, v in ipairs(tags.settings) do
        tags[s][i] = tag({ name = v.name })
        tags[s][i].screen = s
        awful.tag.setproperty(tags[s][i], "layout", v.layout)
    end
    tags[s][1].selected = true
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit },
   { "suspend", "sudo pm-suspend -quirk-s3-mode" },
   { "hibernate", "sudo pm-hibernate" },
   { "reboot", "sudo shutdown -r now" },
   { "halt", "sudo shutdown -h now" }
}

adminmenu = {
   { "install", install },
   { "file manager", "dolphin" },
   { "mc", mc },
   { "mixer", mixer }
}

docmenu = {
   { "writer", "kwrite" },
   { "kate", kate },
   { "spreadsheet", "kspread" },
   { "vim", vim },
   { "okular", "okular" },
   { "inkscape", "inkscape" }
}

netmenu = {
   { "ssh fixe", fixe },
   { "ssh server", server },
   { "ssh router", router }, 
   { "kismet", kismet },
   { "kmldonkey", "kmldonkey" }
}

sciencemenu = {
   { "kstars", "kstars" },
   { "stellarium", "stellarium" }
}

mediamenu = {  
   { "ncmpc", ncmpc },
   { "kaffeine", "kaffeine" }
}

wwwmenu = {
   { "arora", "arora" }, 
   { "konqueror", "konqueror"},
   { "centerim", messenger}
}


mymainmenu = awful.menu.new({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
					{ "documents", docmenu },
					{ "net", netmenu },
					{ "www", wwwmenu },
					{ "media", mediamenu },
					{ "science", sciencemenu },
					{ "admin", adminmenu },
					{ "open terminal", terminal }
                                      }
                            })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" }, "%H:%M ")

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mywibox2 ={}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

-- Reusable separators.
spacer = widget({ type = "textbox", name = "spacer" })
separator = widget({ type = "textbox", name = "separator" })
spacer.text = " "
separator.text = "|"

-- {{{ Battery state
-- Widget icon
baticon       = widget({ type = "imagebox", name = "baticon" })
-- Register widget
vicious.register(baticon, vicious.widgets.bat, 
     function (widget, args)
	  levelbat= args[2]
	  if   args[1] == "⌁" then 
	    baticon.image=image(confdir.. "/icons/battery/ac.png")
	    statebat = "Charged"
	  elseif args[1] == "+" then
	    statebat = "Charging"
	    if args[2] > 90 then 
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
                                , text       = "Battery low! "..args[1].."% left!"
                                , timeout    = 5
                                , position   = "top_right"
                                , fg         = beautiful.fg_focus
                                , bg         = beautiful.bg_focus
                           })
	    end
	  end
      end, 
      23, "BAT1")
baticon:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () naughty.notify({ title      = "Battery"
                                , text       = "Level: "..levelbat.."% left!\nState: "..statebat
                                , timeout    = 5
                                , position   = "top_right"
                                , fg         = beautiful.fg_focus
                                , bg         = beautiful.bg_focus
                           }) end)))
-- }}}

-- {{{ Volume state
-- Widget
volicon	= widget({ type = "imagebox", name = "volicon" })
-- Register widget
vicious.register(volicon, vicious.widgets.volume, 
      function (widget, args)
	  if args[1] == 0 then 
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
			   awful.button({ }, 3, function () awful.util.spawn("updatebrightness assing minimo", false) end),
			   awful.button({ }, 4, function () awful.util.spawn("updatebrightness up", false) end),
			   awful.button({ }, 5, function () awful.util.spawn("updatebrightness down", false) end)))
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
      end, 61, "wlan0")
wifiicon:buttons(awful.util.table.join(
			    awful.button({ }, 1, function () naughty.notify({ title      = "Network:"
                                , text       = "ESSID: "..essid.."\nLink quality: "..link.."%\nRate: "..rate
                                , timeout    = 5
                                , position   = "top_right"
                                , fg         = beautiful.fg_focus
                                , bg         = beautiful.bg_focus
                           }) end)))
-- }}}


    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    mywibox2[s] = awful.wibox({ position = "bottom", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
	s == 1 and mysystray or nil,
        mylayoutbox[s],
        mytextclock,
	spacer,
	separator,
	spacer,
	brighticon,
	spacer,
	volicon,
	spacer,
	baticon,
	spacer,
	wifiicon,
	spacer,
	blueicon,
	spacer,
	touchicon,
	spacer,
        layout = awful.widget.layout.horizontal.rightleft
    }
    mywibox2[s].widgets = {
	s == 1 or nil,
	mytasklist[s],
	layout = awful.widget.layout.horizontal.rightleft
    }      
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:toggle()        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

-- Programs
    awful.key({modkey,		  }, "n",     function () awful.util.spawn("arora", false) end),
    awful.key({modkey,	"Shift"	  }, "n",     function () awful.util.spawn("konqueror", false) end),
    awful.key({modkey,	"Control" }, "n",     function () awful.util.spawn("iceweasel", false) end),
    awful.key({modkey, 		  }, "p",     function () awful.util.spawn("okular", false) end),
    awful.key({modkey,		  }, "a",     function () awful.util.spawn("dolphin", false) end),
    awful.key({modkey,	"Shift"	  }, "a",     function () awful.util.spawn(mc, false) end),
    awful.key({modkey,		  }, "e",     function () awful.util.spawn("kate", false) end),
    awful.key({modkey,	"Control" }, "e",     function () awful.util.spawn("kwrite", false) end),
    awful.key({modkey,	"Shift"	  }, "e",     function () awful.util.spawn(vim, false) end),
    awful.key({modkey,		  }, "t",     function () awful.util.spawn("oocalc", false) end),
    awful.key({modkey,		  }, "s",     function () awful.util.spawn("kstars", false) end),
    awful.key({modkey,	"Shift"	  }, "s",     function () awful.util.spawn("stellarium", false) end),
    awful.key({modkey,		  }, "v",     function () awful.util.spawn("kaffeine", false) end),
    awful.key({modkey,		  }, "i",     function () awful.util.spawn(install, false) end),
    awful.key({modkey,		  }, "-",     function () awful.util.spawn(kismet, false) end),
    awful.key({modkey,		  }, "d",     function () awful.util.spawn("kmldonkey", false) end),
    awful.key({modkey,		  }, "z",     function () awful.util.spawn(mixer, false) end),
    awful.key({modkey,		  }, "y",     function () awful.util.spawn(ncmpc, false) end),
    awful.key({modkey,		  }, ",",     function () awful.util.spawn(messenger, false) end),
    awful.key({modkey,		  }, "o",     function () awful.util.spawn("inkscape", false) end),
    awful.key({modkey,	"Shift"	  }, "o",     function () awful.util.spawn("gimp", false) end),
    awful.key({modkey,		  }, "r",     function () awful.util.spawn("virtualbox", false) end),
    awful.key({modkey,		  },"F8",     function () awful.util.spawn("stopbluetooth", false) end),
    awful.key({modkey,		  },"F9",     function () awful.util.spawn("stoptouchpad", false) end),
    awful.key({modkey,		  }, ".",     function () awful.util.spawn("kmymoney", false) end),
    awful.key({modkey,		  }, "ñ",     function () awful.util.spawn("wesnoth", false) end),

   -- Multimedia keys
    awful.key({			  }, "#121",     function () awful.util.spawn("amixer -q sset Master toggle", false) end),
    awful.key({			  }, "#122",     function () awful.util.spawn("amixer -q sset Master 1%-",false) end),
    awful.key({			  }, "#123",     function () awful.util.spawn("amixer -q sset Master 1%+",false) end),
--    awful.key({			  }, "#180",	 function () awful.util.spawn("xlock -mode blank") end),
--    awful.key({			  }, "#172",	 function () mpd ("pause", mpdwidget,mpdicon) end),
--    awful.key({			  }, "#174",	 function () mpd ("stop", mpdwidget,mpdicon) end),
--    awful.key({			  }, "#173",	 function () mpd ("prev", mpdwidget,mpdicon) end),
--    awful.key({			  }, "#171",	 function () mpd ("next", mpdwidget,mpdicon) end),

  -- Prompt
     -- manual

    awful.key({ modkey }, 	     "F1",    function () awful.prompt.run({ prompt = "Manual: " }, mypromptbox[mouse.screen].widget,
						  function (host) awful.util.spawn( terminal.. " -e man " .. host, false) end)
					      end),

      -- exe
    
    awful.key({ modkey },            "F2",     function () mypromptbox[mouse.screen]:run() end),
    
      -- calculate 

    awful.key({ modkey }, 	     "F3",    function () awful.prompt.run({ prompt = "Calculate: " }, mypromptbox[mouse.screen].widget,
						  function (expr)
						      awful.util.spawn_with_shell("echo '" .. expr .. ' = ' .. awful.util.eval("return (" .. expr .. ")") .. "' | xmessage -center -timeout 10 -file -", false)
						  end)
					      end),
    
      -- spanish dictionary

    awful.key({ modkey },   	      "F4",    function () awful.prompt.run({ prompt = "Spanish dictionary: " }, mypromptbox[mouse.screen].widget,
                                                  function (swords)
                                                    awful.util.spawn_with_shell(confdir.."/scripts/dictspanish " .. swords .. " | xmessage -center -timeout 20 -file -", false)
						  end)
					      end),

      -- english dictionary

    awful.key({ modkey, "Shift" },    "F4",    function () awful.prompt.run({ prompt = "English dictionary: " }, mypromptbox[mouse.screen].widget,
                                                  function (ewords)
                                                    awful.util.spawn_with_shell(confdir.."/scripts/dictenglish " .. ewords .. " | xmessage -center -timeout 20 -file -", false)
						  end)
					      end),

      --uzbl prompt with history

    awful.key({ modkey }, 	      "F5",    function () 
						      awful.prompt.run({ prompt = "Browser: " }, 
						      mypromptbox[mouse.screen].widget,
						      function (host) awful.util.spawn( browser.. " " .. host, false) end, 
						      awful.completion.shell, awful.util.getdir("cache") .. "/history_browser")
					       end),

      --uzbl prompt to searh in google

    awful.key({ modkey, "Shift" },    "F5",    function ()
						       awful.prompt.run({ prompt = "Search in google: " }, 
						       mypromptbox[mouse.screen].widget,
						       function (command)
							  awful.util.spawn( browser.. " 'http://www.google.es/search?hl=es&source=hp&q="..command.."&btnG=Buscar+con+Google&meta=&aq=f&oq='", false)
						       end)
						end),

      -- SSH prompt.

    awful.key({ modkey }, 	      "F6",    function () 
						      awful.prompt.run({ prompt = "ssh: " }, 
						      mypromptbox[mouse.screen].widget,
						      function (host) awful.util.spawn( terminal.. " -name ssh -e ssh " .. host, false) end, 
						      awful.completion.shell, awful.util.getdir("cache") .. "/history_ssh")
					       end),


      --Lua prompt

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
 )

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, i,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, i,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, i,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, i,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
--    { rule = { class = "MPlayer" },
--      properties = { floating = true } },
--    { rule = { class = "pinentry" },
--      properties = { floating = true } },
--    { rule = { class = "gimp" },
--      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
      { rule = { class = "Xmessage", instance = "xmessage", name = "xmessage" },
       properties = { floating = true } },
      { rule = { class = "Arora" },
       properties = { tag = tags[1][2],switchtotag = true } },
      { rule = { class = "Konqueror" },
       properties = { tag = tags[1][2],switchtotag = true } },
      { rule = { name = "uzbl" },
       properties = { tag = tags[1][2],switchtotag = true } },
      { rule = { name = "Iceweasel" },
       properties = { tag = tags[1][2],switchtotag = true } },
      { rule = { name = "centerim" },
       properties = { tag = tags[1][3],switchtotag = true } },
      { rule = { class = "Okular" },
       properties = { tag = tags[1][4],switchtotag = true } },
      { rule = { class = "Kwrite" },
       properties = { tag = tags[1][4],switchtotag = true } },
      { rule = { class = "Kate" },
       properties = { tag = tags[1][4],switchtotag = true } },
      { rule = { name = "Calc" },
       properties = { tag = tags[1][4],switchtotag = true } },
      { rule = { name = "vim" },
       properties = { tag = tags[1][4],switchtotag = true } },
      { rule = { name = "aptitude" },
       properties = { tag = tags[1][5],switchtotag = true } },
      { rule = { class = "Dolphin" },
       properties = { tag = tags[1][5],switchtotag = true } },
      { rule = { name = "mc" },
       properties = { tag = tags[1][5],switchtotag = true } },
      { rule = { class = "Kaffeine" },
       properties = { tag = tags[1][6],switchtotag = true } },
      { rule = { name = "mixer" },
       properties = { tag = tags[1][6],switchtotag = true } },
      { rule = { name = "ncmpc" },
       properties = { tag = tags[1][6],switchtotag = true } },
      { rule = { class = "Gimp" },
       properties = { tag = tags[1][6],switchtotag = true } },
      { rule = { name = "ssh" },
       properties = { tag = tags[1][7],switchtotag = true } },
      { rule = { class = "Kmldonkey" },
       properties = { tag = tags[1][7],switchtotag = true } },
      { rule = { instance = "kismet" },
       properties = { tag = tags[1][7],switchtotag = true } },
      { rule = { class = "Linuxdcpp" },
       properties = { tag = tags[1][7],switchtotag = true } },
      { rule = { class = "VirtualBox" },
       properties = { tag = tags[1][8],switchtotag = true } },
      { rule = { class = "Kstars" },
       properties = { tag = tags[1][9],switchtotag = true } },
      { rule = { class = "Stellarium" },
       properties = { tag = tags[1][9],switchtotag = true } },
      { rule = { instance = "wesnoth" },
       properties = { tag = tags[1][9],switchtotag = true } },
      { rule = { class = "Kmymoney" },
       properties = { tag = tags[1][9],switchtotag = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
