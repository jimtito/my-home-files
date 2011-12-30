-- {{{ License
--
-- Awesome configuration, using awesome 3.4.9 on Debian squeeze GNU/Linux
--   * Manuel F. <manelfauvell@gmail.com>

-- This work is licensed under the Creative Commons Attribution-Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- }}}


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
require("shifty")

-- Load Debian menu entries
--require("debian.menu")

-- Variable with the config directory
confdir = awful.util.getdir("config")

-- Custom theme
beautiful.init( confdir.."/themes/oscur/theme.lua")


-- {{{ Variable definitions
-- This is used later as the default terminal and editor to run.
--terminal = "termit"
terminal = "urxvt"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
browser ="luakit"

-- Aliases
install = terminal .. " -name install -e aptitude"
mixer = terminal .. " -name mixer -e alsamixer"
ncmpc = terminal .. " -name ncmpc -e ncmpc"
vim = terminal .. " -name vim -e vim"
mc = terminal.. " -name mc -e mc"
kismet = terminal.. " -name kismet -e sudo kismet"
messenger = terminal.. " -name centerim -e centerim-utf8"
irc = terminal.. " -name irc -e torify irssi"

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

--{{{ SHIFTY: configured tags
shifty.config.tags = {
["main"] = { layout = awful.layout.suit.tile, init = true, position = 1 },
["www"] = { layout = awful.layout.suit.max, init = true, position = 2 } ,
["im"] = { layout = awful.layout.suit.tile, position = 3 } ,
["in.ca"] = { layout = awful.layout.suit.tile, position = 3},
["doc"] = { layout = awful.layout.suit.tile, position = 4 } ,
["pdf"] = { layout = awful.layout.suit.tile, position = 4 } ,
["admin"] = { layout = awful.layout.suit.tile.bottom, position = 5 } ,
["multi"] = { layout = awful.layout.suit.tile.bottom, position = 6 } ,
["book"] = { layout = awful.layout.suit.max, position = 6 },
["img"] = { layout =  awful.layout.suit.tile, exclusive = false, position = 6, ncol = 3, mwfact = 0.75, nmaster = 1, slave = true },
["net"] = { layout = awful.layout.suit.tile.bottom, position = 7 } ,
["vbox"] = { layout = awful.layout.suit.bottom, position = 8 } ,
["other"] = { layout = awful.layout.suit.tile, position = 9} ,
["stars"] = { layout = awful.layout.suit.max, position = 9 } ,
}
--}}}

--{{{ SHIFTY: application matching rules
-- order here matters, early rules will be applied first
shifty.config.apps = {
	  { match = { "browser", "uzbl", "arora", "konqueror", "iceweasel", "luakit", "chromium"  } , tag = "www"    } ,
	  { match = { "centerim", "irc"				            } , tag = "im"   } ,
	  { match = { "choqok"						    } , tag = "in.ca" },
	  { match = { "kate", "vim", "kwrite", "calc", "kspread"		} , tag = "doc"   } ,
	  { match = { "apvlv", "okular"						} , tag = "pdf" } ,
	  { match = { "dolphin", "install", "mc"		            } , tag = "admin"   } ,
	  { match = { "kaffeine", "ncmpc", "mixer", "amarok"                } , tag = "multi"   } ,
	  { match = { "kmldonkey", "ssh", "kismet"	                    } , tag = "net"   } ,
	  { match = { "VirtualBox"			                    } , tag = "vbox"   } ,
	  { match = { "kmymoney", "wesnoth", "gourmet"         			} , tag = "other"   } ,
	  { match = { "kstars", "stellarium"					} , tag = "stars" } ,
	  { match = { "gimp", "krita"					    } , tag = "img"	} ,
	  { match = { "calibre"						    } , tag = "book"	} ,
}
--}}}

--{{{ SHIFTY: default tag creation rules
-- parameter description
--  * floatBars : if floating clients should always have a titlebar
--  * guess_name : wether shifty should try and guess tag names when creating new (unconfigured) tags
--  * guess_position: as above, but for position parameter
--  * run : function to exec when shifty creates a new tag
--  * remember_index: ?
--  * all other parameters (e.g. layout, mwfact) follow awesome's tag API
shifty.config.defaults={  
  layout = awful.layout.suit.tile.bottom, 
  ncol = 1, 
  mwfact = 0.50,
  floatBars=true,
  guess_name=true,
  guess_position=false,
}
--}}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }   
}

mymainmenu = awful.menu.new({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
					{ "open terminal", terminal },
					{ "suspend", "sudo pm-suspend -quirk-s3-mode" },
					{ "hibernate", "sudo pm-hibernate" },
					{ "reboot", "sudo shutdown -r now" },
					{ "halt", "sudo shutdown -h now" }
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

-- Functions general hardware

require("volumerc")

-- Functions laptop hardware

require("wifirc")

require("batteryrc")

--require("touchpadrc")

-- Functions software

require("mailrc")

-- Functions Debian

require("aptituderc")

-- Functions Toshiba a20O

--require("omnibookrc")

-- Functions Sony Vaio

require("sonybrightrc")

require("fanrc")

saveicon = widget({ type = "imagebox", name = "saveicon" })
saveicon.image=image(nil)

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
	s == 1 or nil,
        mylayoutbox[s],
        mytextclock,
	spacer,
	separator,
	spacer,
	baticon,
	spacer,
	brighticon,
	spacer,
	fanicon,
	spacer,
	volicon,
	spacer,
	wifiicon,
	spacer,
	aptwidget,
	spacer,
	mailwidget,
	spacer,
	saveicon,
        layout = awful.widget.layout.horizontal.rightleft
    }
    mywibox2[s].widgets = {
	s == 1 and mysystray or nil,
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
    awful.key({modkey,		  }, "n",     function () awful.util.spawn("luakit", false) end),
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
    awful.key({modkey,	"Shift"	  }, "y",     function () awful.util.spawn("amarok", false) end),
    awful.key({modkey,		  }, ",",     function () awful.util.spawn(messenger, false) end),
    awful.key({modkey,	"Shift"	  }, ",",     function () awful.util.spawn("choqok", false) end),
    awful.key({modkey,	"Control" }, ",",     function () awful.util.spawn(irc, false) end),
    awful.key({modkey,		  }, "o",     function () awful.util.spawn("inkscape", false) end),
    awful.key({modkey,	"Shift"	  }, "o",     function () awful.util.spawn("gimp", false) end),
    awful.key({modkey,		  }, "r",     function () awful.util.spawn("virtualbox", false) end),
    awful.key({modkey,		  }, ".",     function () awful.util.spawn("kmymoney", false) end),
    awful.key({modkey,		  }, "-",     function () awful.util.spawn("wesnoth-1.8", false) end),
    awful.key({modkey,		  }, "g",     function () awful.util.spawn("gourmet", false) end),

   -- Multimedia keys
    awful.key({			  }, "#121",     function () awful.util.spawn("amixer -q sset Master toggle", false) end),
    awful.key({			  }, "#122",     function () awful.util.spawn("amixer -q sset Master 5%-",false) end),
    awful.key({			  }, "#123",     function () awful.util.spawn("amixer -q sset Master 5%+",false) end),
    awful.key({			  }, "#156",	 function () awful.util.spawn("xlock -mode blank") end),
    awful.key({			  }, "#157",	 function () awful.util.spawn("sudo strongsave") end),
--    awful.key({			  }, "#174",	 function () mpd ("stop", mpdwidget,mpdicon) end),
--    awful.key({			  }, "#173",	 function () mpd ("prev", mpdwidget,mpdicon) end),
--    awful.key({			  }, "#171",	 function () mpd ("next", mpdwidget,mpdicon) end),

   -- Hardware keys
    awful.key({			  }, "#232",	 function () awful.util.spawn("updatebrightness -d", false) end),
    awful.key({			  }, "#233",	 function () awful.util.spawn("updatebrightness -u", false) end),
--    awful.key({modkey,		  },"F8",     function () awful.util.spawn("stopbluetooth", false) end),
--    awful.key({modkey,		  },"F9",     function () awful.util.spawn("stoptouchpad", false) end),

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

      --Browser prompt with history

    awful.key({ modkey }, 	      "F5",    function () 
						      awful.prompt.run({ prompt = "Browser: " }, 
						      mypromptbox[mouse.screen].widget,
						      function (host) awful.util.spawn( browser.. " " .. host, false) end, 
						      awful.completion.shell, awful.util.getdir("cache") .. "/history_browser")
					       end),

      --Browser prompt to searh in google

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

      -- Twidge prompt for indenti.ca

    awful.key({ modkey }, 	      "F7",    function () 
						      awful.prompt.run({ prompt = "Identi.ca: " }, 
						      mypromptbox[mouse.screen].widget,
						      function (message) awful.util.spawn( "twidge update '" .. message .. "'", false) end)
					       end),

      -- Pdf prompt.

    awful.key({ modkey }, 	      "F8",    function () 
						      awful.prompt.run({ prompt = "Open PDF: " }, 
						      mypromptbox[mouse.screen].widget,
						      function (host) awful.util.spawn("apvlv " .. host, false) end, 
						      awful.completion.shell, awful.util.getdir("cache") .. "/history_pdf")
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

--}}}

-- Compute the maximum number of digit we need, limited to 9
for i=1, ( shifty.config.maxtags or 9 ) do
    globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, i, function()
        awful.tag.viewonly(shifty.getpos(i)) end),
    awful.key({ modkey, "Control" }, i, function()
        this_screen = awful.tag.selected().screen
        t = shifty.getpos(i) 
        t.selected = not t.selected
    end),
    awful.key({ modkey, "Shift" }, i, function ()
        if client.focus then 
            local c = client.focus
            slave = not ( client.focus == awful.client.getmaster(mouse.screen))
            t = shifty.getpos(i)
            awful.client.movetotag(t,c)
            awful.tag.viewonly(t)
            if slave then awful.client.setslave(c) end
        end 
    end)
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

--{{{ SHIFTY: initialize shifty
shifty.config.clientkeys = clientkeys
shifty.taglist = mytaglist
shifty.init()
--}}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
      { rule = { class = "Xmessage", instance = "xmessage", name = "xmessage" },
       properties = { floating = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
