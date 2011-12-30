--------------------------------
-- GGLucas' Awesome-3 Lua Config
-- Version 3
--------------------------------

-- {{{ Library includes
-- Awful: Standard awesome library
require("awful")
require("awful.rules")
require("awful.autofocus")

-- Eminent: Effortless wmii-style dynamic tagging
require("eminent")

-- Beautiful: Theming capabilities
require("beautiful")

-- Scratch: Dropdown and scratchpad manager
require("scratch")

-- Fadelist: Pop-up taglist
require("fadelist")

-- Naughty: Notification library
require("naughty")

-- Rodentbane: Utilities for controlling the cursor
require("rodentbane")

-- Quickmarks: Rapid client focus jumping by hotkey
require("quickmarks")

-- Advprompt: A more advanced prompt that can display output
require("advprompt")
-- }}}
-- {{{ Configuration
-- Beautiful colors
beautiful.init(os.getenv("HOME").."/.config/awesome/theme.lua")

-- Amount of lower row screens
lower_screens = 4

-- Applications
terminal = "urxvtc"
terminal_full = "/usr/bin/urxvtc"

apps = {
    -- Terminal to use
    terminal = terminal,
    terminal_full = terminal_full,

    -- Open a terminal with tmux
    tmux = terminal.." -e tmux -2 attach -t ranger",

    -- Open filemanager
    filemanager = terminal.." -e ranger /data",

    -- Open htop
    htop = terminal.." -e htop",

    -- Open webbrowser
    browser = "fx",

    -- Suspend activity
    system_suspend = "system_suspend 1",

    -- Displays and music off
    system_silent = "system_suspend 0",

    -- Turn off displays
    displays_off = "system_suspend 2",

    -- Shutdown system
    shutdown = "sudo halt",

    -- Toggle music
    mpd_toggle = "mpc_toggle",

    -- Start all applications
    startapps = "startapps",
}

-- Advprompt
advprompt.term = apps.terminal.." -e /bin/bash -c \"source .bashrc; %s; bash\""
advprompt.shell = "/bin/bash -c \"source .bashrc; exec %s\""
-- }}}
-- {{{ Utility functions
dropdown = {}
settings = {}
util = {
    -- {{{ Tag based
    tag = {
        getidx = function (i, sc)
            local tags = screen[sc or mouse.screen]:tags()
            local sel = awful.tag.selected(sc)
            for k, t in ipairs(tags) do
                if t == sel then
                    return tags[awful.util.cycle(#tags, k + i)]
                end
            end
        end,

        resetwfact = function ()
            tag = awful.tag.selected()
            clients = tag:clients()
            num = #clients-awful.tag.getnmaster(tag)
            fact = 1/num

            for i,c in ipairs(clients) do
                if c ~= awful.client.getmaster(c.screen) then
                    awful.client.setwfact(fact, c)
                end
            end
        end,
    },
    -- }}}
    -- {{{ Client based
    client = {
        movetonexttag = function (c)
            awful.client.movetotag(util.tag.getidx(1), c)
        end,

        movetoprevtag = function (c)
            awful.client.movetotag(util.tag.getidx(-1), c)
        end,

        focusraise_idx = function (idx)
            awful.client.focus.byidx(idx)
            if client.focus and awful.client.property.get(client.focus, "floating") then
                client.focus:raise()
            end
        end,

        setfloatgeom = function (x, y, width, height)
            awful.client.floating.set(client.focus, true)

            client.focus:geometry({
                x = x,
                y = y,
                width = width,
                height = height
            })
        end,

        togglemax = function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical = not c.maximized_vertical
        end,
    },
    -- }}}
    -- {{{ Screen based
    screen = {
        -- Run a function on all screens
        do_all = function (func)
            for s=1, screen.count() do
                func(screen[s])
            end
        end,

        -- Run a function on all lower screens
        do_lower = function (func)
            for s=1, lower_screens do
                func(screen[s])
            end
        end,

        -- Focus numbered screen
        focus = function (screen)
            mouse.screen = screen

            local c = awful.client.focus.history.get(screen, 0)
            if c then
                mouse.coords({ x = c:geometry().x+6,
                               y = c:geometry().y+4
                            })
                client.focus = c
            end
        end,

        -- Focus previous screen
        focusprev = function ()
            local capiscreen = screen
            local screen = mouse.screen

            if capiscreen.count() == 2 then
                screen = 1+(screen%2)
            else
                if screen == 1 then
                    screen = 4
                elseif screen == 5 then
                    screen = 6
                elseif screen == 6 then
                    screen = 5
                else
                    screen = screen - 1
                end
            end

            mouse.screen = screen

            local c = awful.client.focus.history.get(screen, 0)
            if c then
                mouse.coords({ x = c:geometry().x+6,
                               y = c:geometry().y+4
                            })
                client.focus = c
            end
        end,

        -- Focus next screen
        focusnext = function ()
            local capiscreen = screen
            local screen = mouse.screen

            if capiscreen.count() == 2 then
                screen = 1+(screen%2)
            else
                if screen == 4 then
                    screen = 1
                elseif screen == 5 then
                    screen = 6
                elseif screen == 6 then
                    screen = 5
                else
                    screen = screen + 1
                end
            end
                
            mouse.screen = screen

            local c = awful.client.focus.history.get(screen, 0)
            if c then
                mouse.coords({ x = c:geometry().x+6,
                               y = c:geometry().y+4
                            })
                client.focus = c
            end
        end,

        -- Focus screen in row up
        focusnextrow = function ()
            local screen = mouse.screen

            if screen == 5 then
                screen = 1
            elseif screen == 6 then
                screen = 2
            elseif screen == 1 or screen == 4 then
                screen = 5
            elseif screen == 2 or screen == 3 then
                screen = 6
            end

            mouse.screen = screen

            local c = awful.client.focus.history.get(screen, 0)
            if c then
                mouse.coords({ x = c:geometry().x+6,
                               y = c:geometry().y+4
                            })
                client.focus = c
            end
        end,
    },
    -- }}}
    -- {{{ Cursor based
    banish = function (c, padd)
        if padd == nil then padd = 6 end
        local client = c or client.focus
        local coords = client:geometry()

        mouse.coords({ x=coords.x+coords.width-padd, y=coords.y+coords.height-padd})
    end,
    -- }}}
    -- {{{ Prompts / wiboxes

    -- }}}
    -- {{{ Spawn based
    -- Spawn on all screens
    spawn_all = function(app)
        for s=1, screen.count() do
            mouse.screen = s
            awful.util.spawn(app)
        end
    end,

    -- Spawn on lower screens
    spawn_lower = function(app)
        for s=1, lower_screens do
            mouse.screen = s
            awful.util.spawn(app)
        end
    end,
    -- }}}
    -- {{{ Quickmarks based
    -- Send a list of commands to weechat
    weechat_send = function (commands)
        cmds = ""

        for i,cm in ipairs(commands) do
            if i > 1 then
                cmds = cmds.."\\n"
            end

            cmds = cmds.."*"..cm
        end

        awful.util.spawn_with_shell("echo -e '"..cmds.."' > ~/.weechat/*fifo*")
    end,

    -- Focus a particular weechat window
    weechat_window = function(num)
        if num < 5 then
            -- Focus window
            if quickmarks.get("i") ~= client.focus then
                quickmarks.focus("i")
            end

            -- Go to an established position
            cmd = {"/window left", "/window left", "/window left",
                   "/window left", "/window down"}

            -- Select window
            if num == 1 then
                table.insert(cmd, "/window up")
            elseif num == 2 then
                table.insert(cmd, "/window up")
                table.insert(cmd, "/window right")
            elseif num == 4 then
                table.insert(cmd, "/window right")
            end

            util.weechat_send(cmd)
        else
            -- Focus window
            if quickmarks.get("d") ~= client.focus then
                quickmarks.focus("d")
            end

            -- Go to an established position
            cmd = {"/window right", "/window right", "/window right",
            "/window right", "/window up", "/window up", "/window up"}

            -- Select window
            if num == 5 then
                table.insert(cmd, "/window left")
            elseif num == 8 then
                table.insert(cmd, "/window down")
                table.insert(cmd, "/window right")
                table.insert(cmd, "/window up")
            elseif num == 7 then
                table.insert(cmd, "/window left")
                table.insert(cmd, "/window down")
            end

            util.weechat_send(cmd)
        end
    end,

    -- Quickmarks in default desktop layout
    defquickmarks = function ()
        --- Set correct geometry on irc windows
        clients = awful.client.visible(5)
        awful.client.floating.set(clients[1], true)
        clients[1]:geometry({ x = 0, y = 0,
            width = 3360, height = 1050 })

        clients = awful.client.visible(6)
        awful.client.floating.set(clients[1], true)
        clients[1]:geometry({ x = -1680, y = 0,
            width = 3360, height = 1050 })

        -- Quickmarks
        -- 1: Firefox
        quickmarks.set(awful.client.visible(1)[1], "u")
        quickmarks.set(awful.client.visible(1)[1], "j")
        quickmarks.set(awful.client.visible(1)[2], "k")
        -- 2: Main terms
        quickmarks.set(awful.client.visible(2)[1], "h")
        quickmarks.set(awful.client.visible(2)[2], "w")
        quickmarks.set(awful.client.visible(2)[3], "v")
        -- 3: Monitors+mail
        quickmarks.set(awful.client.visible(3)[1], "t")
        quickmarks.set(awful.client.visible(3)[2], "n")
        quickmarks.set(awful.client.visible(3)[3], "s")
        -- 4: Torrent+rss+mpd
        quickmarks.set(awful.client.visible(4)[1], "a")
        quickmarks.set(awful.client.visible(4)[2], "o")
        quickmarks.set(awful.client.visible(4)[3], "e")
        -- 5/6: irc
        quickmarks.set(awful.client.visible(5)[1], "i")
        quickmarks.set(awful.client.visible(6)[1], "d")
    end,
    -- }}}
    -- {{{ Clients to launch at startup
    startup = function ()
        awful.util.spawn_with_shell(apps.startapps)
        for s=1, screen.count() do
            awful.client.visible(s)[1]:kill()
        end
    end,
    -- }}}
    -- {{{ Notification based
    -- Notify mpd status
    notify_mpd = function ()
        fd = io.popen("mpc_show")
        info = fd:read()
        fd:close()

        naughty.notify {title="Now Playing", text=info, timeout=5, screen=mouse.screen}
    end,

    -- Clear all notifications
    notify_clear = function ()
        -- Mail
        mailnotify_set(0)

        -- Notifications
        for s = 1, screen.count() do
            for p,pos in pairs(naughty.notifications[s]) do
                for i,notification in pairs(naughty.notifications[s][p]) do
                    naughty.destroy(notification)
                end
            end
        end
    end,
    -- }}}
    -- {{{ Other functionality
    -- Toggle notifications displaying
    notify_toggle = function ()
        if settings._naughty_notify == nil then
            settings._popup_allowed = true
            settings._naughty_notify = naughty.notify
            settings._naughty_stub = function(args)end
        end

        if settings._naughty_notify == naughty.notify then
            naughty.notify = settings._naughty_stub
            settings._popup_allowed = false
        else 
            naughty.notify = settings._naughty_notify
            settings._popup_allowed = true
        end
    end,

    -- Show fadelist only when enabled
    fadelist = function (...)
        if settings._popup_allowed 
        or settings._popup_allowed == nil then
            fadelist(...)
        end
    end,

    -- Toglge mpd volume between high and low
    mpd_togglevolume_high_low =  function ()
        if settings._mpd_volume == nil then
            settings._mpd_volume = 74
        end

        if settings._mpd_volume == 74 then
            awful.util.spawn_with_shell("mpc volume 30")
            settings._mpd_volume = 30
        elseif settings._mpd_volume == 30 then
            awful.util.spawn_with_shell("mpc volume 74")
            settings._mpd_volume = 74
        end
    end,

    -- Toggle between number or symbol row keymap
    toggle_numbers = function ()
        if settings._numbers then
            settings._numbers = false
            awful.util.spawn_with_shell("xmodmap ~/.xkb/xmm/nonumbers")
        else 
            settings._numbers = true
            awful.util.spawn_with_shell("xmodmap ~/.xkb/xmm/numbers")
        end
    end,

    -- Toggle weechat away
    weechat_away = function (set)
        if set then
            util.weechat_send({"/away -all away"})
        else 
            util.weechat_send({"/away -all"})
        end
    end,
    -- }}}
}
-- }}}
-- {{{ Tags
tags = {}
for s = 1, screen.count() do
    -- Figure out layout to use
    if s == 3 then
        layout = awful.layout.suit.tile.left
    else
        layout = awful.layout.suit.spiral.dwindle
    end

    -- Create tags
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8 }, s, layout)
end

-- }}}
-- {{{ Keybindings
-- Global keybindings
bindings = {
    -- {{{ Spawn applications
    spawn = {
        -- Open terminal
        [{"Mod4", ";"}] = apps.terminal,

        -- Open terminal with tmux
        [{"Mod4", "b"}] = apps.tmux,

        -- Open file manager
        [{"Mod4", "e"}] = apps.filemanager,
    },
    -- }}}
    -- {{{ Commands to run
    cmd = {
        -- Toggle music
        [{"Mod4", "."}] = apps.mpd_toggle,

        -- Shutdown machine
        [{"Mod4", "Shift", "Pause"}] = apps.shutdown,

        -- Switch keymap
        [{"Mod4", "KP_Add"}] = "setxkbmap us && xmodmap ~/.xkb/xmm/caps_escape",
        [{"Mod4", "KP_Enter"}] = "hdv",

        -- Suspend all activity
        [{"Mod4", "F1"}] = apps.system_suspend,

        -- Turn displays off
        [{"Mod4", "F2"}] = apps.system_silent,

        -- Turn displays off
        [{"Mod4", "F5"}] = apps.displays_off,

        -- Toggle Line In mute
        [{"Mod4", "F8"}] = "amixer set Line toggle",

        -- Toggle Mic mute
        [{"Mod4", "o"}] = "toggle_mic",
    },
    -- }}}
    -- {{{ Functions to run on screens
    screen = {
        -- Tag selection
        [{"Mod4", "w"}] = awful.tag.viewnext,
        [{"Mod4", "v"}] = awful.tag.viewprev,

        -- Toggle fadelist display
        [{"Mod4", "\\"}] = function(s) fadelist(0, s and s.index or nil) end,

        -- Toggle scratchpad
        [{"Mod4", "s"}] = scratch.pad.toggle,
    },
    -- }}}
    -- {{{ Misc functions
    root = {
        -- Drop-down urxvtc terminal
        [{"Mod4", "a"}] = {scratch.drop, apps.terminal},

        -- Pull-left urxvtc terminal
        [{"Mod4", "Shift", "a"}] = {scratch.drop, apps.terminal_full, "top", "right", 0.5, 1},

        -- Open spawn prompt
        [{"Mod4", ","}] = {advprompt},

        -- Close all output notifications
        [{"Mod4", "Shift", ","}] = util.notify_clear,

        -- Show MPD currently playing song
        [{"Mod4", "p"}] = util.notify_mpd,

        -- Start rodentbane cursor navigation
        [{"Mod4", "r"}] = rodentbane.start,

        -- Start rodentbane cursor navigation in recall mode
        [{"Mod4", "Shift", "r"}] = {rodentbane.start, false, true},

        -- Warp pointer to top left of the screen
        [{"Mod4", "Mod1", "$"}] = {mouse.coords, {x = 0, y = 0}},

        -- Window focus
        [{"Mod4", "t"}] = {util.client.focusraise_idx, 1},
        [{"Mod4", "n"}] = {util.client.focusraise_idx, -1},

        -- Quickmarks
        [{"Mod4", "-"}] = quickmarks.ifocus,
        [{"Mod4", "Shift", "-"}] = quickmarks.iset,

        -- Easy quickmark access with Mod4+Alt_r+Homerow
        [{"Mod1", "Mod5", "a"}] = {quickmarks.focus, "a"},
        [{"Mod1", "Mod5", "o"}] = {quickmarks.focus, "o"},
        [{"Mod1", "Mod5", "e"}] = {quickmarks.focus, "e"},
        [{"Mod1", "Mod5", "u"}] = {quickmarks.focus, "u"},
        [{"Mod1", "Mod5", "i"}] = {quickmarks.focus, "i"},
        [{"Mod1", "Mod5", "d"}] = {quickmarks.focus, "d"},
        [{"Mod1", "Mod5", "h"}] = {quickmarks.focus, "h"},
        [{"Mod1", "Mod5", "t"}] = {quickmarks.focus, "t"},
        [{"Mod1", "Mod5", "n"}] = {quickmarks.focus, "n"},
        [{"Mod1", "Mod5", "s"}] = {quickmarks.focus, "s"},
        [{"Mod1", "Mod5", "w"}] = {quickmarks.focus, "w"},
        [{"Mod1", "Mod5", "v"}] = {quickmarks.focus, "v"},
        [{"Mod1", "Mod5", "j"}] = {quickmarks.focus, "j"},
        [{"Mod1", "Mod5", "k"}] = {quickmarks.focus, "k"},

        -- Irc quickmarks that focus a particular weechat window
        [{"Mod1", "Mod5", "Shift", ","}] = {util.weechat_window, 1},
        [{"Mod1", "Mod5", "Shift", "."}] = {util.weechat_window, 2},
        [{"Mod1", "Mod5", "Shift", "c"}] = {util.weechat_window, 5},
        [{"Mod1", "Mod5", "Shift", "r"}] = {util.weechat_window, 6},

        [{"Mod1", "Mod5", "Shift", "o"}] = {util.weechat_window, 3},
        [{"Mod1", "Mod5", "Shift", "e"}] = {util.weechat_window, 4},
        [{"Mod1", "Mod5", "Shift", "t"}] = {util.weechat_window, 7},
        [{"Mod1", "Mod5", "Shift", "n"}] = {util.weechat_window, 8},

        -- Quickmark "^^" is a shortcut for "globally last focussed client."
        [{"Mod1", "Mod5", "-"}] = {quickmarks.focus, "^^"},

        -- Number "Quickmarks" to focus a particular screen
        [{"Mod1", "Mod5", "#10"}] = {util.screen.focus, 4},
        [{"Mod1", "Mod5", "#11"}] = {util.screen.focus, 1},
        [{"Mod1", "Mod5", "#12"}] = {util.screen.focus, 2},
        [{"Mod1", "Mod5", "#13"}] = {util.screen.focus, 3},
        [{"Mod1", "Mod5", "#20"}] = {util.screen.focus, 5},
        [{"Mod1", "Mod5", "#21"}] = {util.screen.focus, 6},

        -- Switch between layouts
        [{"Mod4", "'"}] = {awful.layout.set, awful.layout.suit.max},
        [{"Mod4", "q"}] = {awful.layout.set, awful.layout.suit.spiral.dwindle},
        [{"Mod4", "j"}] = {awful.layout.set, awful.layout.suit.tile},
        [{"Mod4", "k"}] = {awful.layout.set, awful.layout.suit.tile.left},
        [{"Mod4", "x"}] = {awful.layout.set, awful.layout.suit.tile.bottom},

        -- Switch between mwfact modes
        [{"Mod4", "Shift", "'"}] = {awful.tag.setmwfact, 0.5},
        [{"Mod4", "Shift", "q"}] = {awful.tag.setmwfact, 0.618033988769},

        -- Increase or decrease mwfact
        [{"Mod4", "Mod1", "Shift", "h"}] = {awful.tag.incmwfact, -0.05},
        [{"Mod4", "Mod1", "Shift", "l"}] = {awful.tag.incmwfact, 0.05},

        -- Increase or decrease wfact
        [{"Mod4", "Shift", "h"}] = {awful.client.incwfact, -0.05},
        [{"Mod4", "Shift", "l"}] = {awful.client.incwfact, 0.05},

        -- Reset wfact
        [{"Mod4", "Control", "h"}] = util.tag.resetwfact,

        -- Increase or decrease the number of master windows
        [{"Mod4", "Mod1", "'"}] = {awful.tag.incnmaster, -1},
        [{"Mod4", "Mod1", "q"}] = {awful.tag.incnmaster, 1},

        -- Screen focus
        [{"Mod4", "h"}] = util.screen.focusprev,
        [{"Mod4", "l"}] = util.screen.focusnext,
        [{"Mod4", "g"}] = util.screen.focusnextrow,

        -- Toggle notifications displaying
        [{"Mod4", "F10"}] = util.notify_toggle,

        -- Toggle between low and high mpd volumes
        [{"Mod4", "F11"}] = util.mpd_togglevolume_high_low,

        -- Toggle between numbers and special characters by default on number row
        [{"Mod4", "F12"}] = util.toggle_numbers,

        -- Start a set of common clients with quickmarks
        [{"Mod4", "BackSpace"}] = util.startup,

        -- Set quickmarks
        [{"Mod4", "Return"}] = util.defquickmarks,

        -- Toggle away on weechat
        [{"Mod4", "F3"}] = {util.weechat_away, true},
        [{"Mod4", "F4"}] = {util.weechat_away, false},

        -- Restart awesome
        [{"Mod4", "Mod1", "r"}] = awful.util.restart,
    },
    -- }}}
    -- {{{ Client bindings
    client = {
        -- Set scratchpad
        [{"Mod4", "Shift", "s"}] = scratch.pad.set,

        -- Toggle fullscreen
        [{"Mod4", "f"}] = {"+fullscreen"},

        -- Close window
        [{"Mod4", "$"}] = {":kill"},

        -- Redraw client
        [{"Mod4", "/"}] = {":redraw"},

        -- Redraw client
        [{"Mod4", "m"}] = util.client.togglemax,

        -- Window swapping
        [{"Mod4", "Shift", "t"}] = {awful.client.swap.byidx, 1},
        [{"Mod4", "Shift", "n"}] = {awful.client.swap.byidx, -1},

        -- Toggle floating
        [{"Mod4", "c"}] = awful.client.floating.toggle,

        -- Move to tag
        [{"Mod4", "Shift", "w"}] = util.client.movetonexttag,
        [{"Mod4", "Shift", "v"}] = util.client.movetoprevtag,

        -- Geometry for screenjoins
        [{"Mod4", "+"}] = {util.client.setfloatgeom, 0, 0, 3360, 1050},
        [{"Mod4", "]"}] = {util.client.setfloatgeom, -1680, 0, 3360, 1050},
    },
    -- }}}

    root_buttons = awful.util.table.join(
        awful.button({}, 3, function () awful.util.spawn(apps.terminal) end)
    ),

    client_buttons = awful.util.table.join(
        awful.button({}, 1, function (c) client.focus = c; c:raise() end),
        awful.button({"Mod4",}, 1, awful.mouse.client.move),
        awful.button({"Mod4",}, 3, awful.mouse.client.resize)
    ), 
}

---- {{{ Set up number bindings
for i=1, #tags[1]  do
    -- Switch to tag number
    bindings.root[{"Mod4", "#"..i+9}] = function()
        awful.tag.viewonly(tags[mouse.screen][i])
    end

    -- Toggle tag display
    bindings.root[{"Mod4", "Control", "#"..i+9}] = function()
        awful.tag.viewtoggle(tags[client.focus.screen][i])
    end

    -- Move client to tag number
    bindings.client[{"Mod4", "Shift", "#"..i+9}] = function()
        awful.client.movetotag(tags[client.focus.screen][i])
    end

    -- Toggle client on tag number
    bindings.client[{"Mod4", "Control", "Shift", "#"..i+9}] = function(c)
        awful.client.toggletag(tags[client.focus.screen][i])
        client.focus = c
    end

    -- Switch all screens to tag number
    bindings.root[{"Mod4", "Mod1", "#"..i+9}] = function()
        for s=1, screen.count() do
            awful.tag.viewonly(tags[s][i])
        end
    end

    -- Switch bottom 4 screens to tag number
    bindings.root[{"Mod4", "Mod1", "Shift", "#"..i+9}] = function()
        for s=1, 4 do
            awful.tag.viewonly(tags[s][i])
        end
    end
end
---- }}}
---- {{{ Set up keybindings - Code
    --- Add specific bindings into root bindings array
    -- Spawn applications
    for keys, cmd in pairs(bindings.spawn) do
        -- Get keys for all displays
        keys_all = awful.util.table.clone(keys)
        table.insert(keys_all, 1, "Mod1")

        -- Get keys for bottom displays
        keys_bottom = awful.util.table.clone(keys_all)
        table.insert(keys_bottom, 1, "Shift")

        -- Add bindings
        bindings.root[keys] = {awful.util.spawn, cmd}
        bindings.root[keys_all] = {util.spawn_all, cmd}
        bindings.root[keys_bottom] = {util.spawn_lower, cmd}
    end

    -- Run commands
    for keys, cmd in pairs(bindings.cmd) do
        -- Add bindings
        bindings.root[keys] = {awful.util.spawn_with_shell, cmd}
    end

    -- Run a function on a screen
    for keys, cmd in pairs(bindings.screen) do
        -- Get keys for all displays
        keys_all = awful.util.table.clone(keys)
        table.insert(keys_all, 1, "Mod1")

        -- Get keys for bottom displays
        keys_bottom = awful.util.table.clone(keys_all)
        table.insert(keys_bottom, 1, "Shift")

        -- Add bindings
        bindings.root[keys] = cmd
        bindings.root[keys_all] = {util.screen.do_all, cmd}
        bindings.root[keys_bottom] = {util.screen.do_lower, cmd}
    end

    --- Setup root bindings
    -- Root binding table
    local rbinds = {}

    -- Bind all root bindings
    for keys, func in pairs(bindings.root) do
        -- Get regular key
        local actkey = keys[#keys]
        table.remove(keys, #keys)

        -- Get function to call
        if type(func) == "table" then
            -- Get arguments and function from table
            local args = func
            local ofunc = args[1]

            table.remove(args, 1)

            -- Create new function
            func = function ()
                ofunc(unpack(args))
            end
        end

        -- Create binding
        local bind = awful.key(keys, actkey, func) 

        -- Insert into table
        table.insert(rbinds, bind)
    end

    -- Bind
    root.keys(awful.util.table.join(unpack(rbinds)))

    --- Setup client bindings
    -- Client binding table
    local clientbinds = {}

    -- Bind all client bindings
    for keys, func in pairs(bindings.client) do
        -- Get regular key
        local actkey = keys[#keys]
        table.remove(keys, #keys)

        -- Get function to call
        if type(func) == "table" then
            -- Get arguments and function from table
            local args = func
            local ofunc = args[1]
            table.remove(args, 1)

            -- Create new function
            if type(ofunc) == "string" and ofunc:sub(1,1) == ":" then
                -- Insert placeholder for instance
                table.insert(args, 1, nil)

                -- Method calls
                func = function (c)
                    -- Insert instance into table
                    args[1] = c

                    -- Call
                    c[ofunc:sub(2)](unpack(args))
                end
            elseif type(ofunc) == "string" and ofunc:sub(1,1) == "+" then
                -- Toggle an attribute
                func = function (c)
                    c[ofunc:sub(2)] = not c[ofunc:sub(2)]
                end
            elseif type(ofunc) == "string" and ofunc:sub(1,1) == "." then
                -- Set an attribute
                func = function (c)
                    c[ofunc:sub(2)] = args[1]
                end
            else
                -- Regular function
                func = function (c)
                    ofunc(unpack(args))
                end
            end
        end

        -- Create binding
        local bind = awful.key(keys, actkey, func) 

        -- Insert into table
        table.insert(clientbinds, bind)
    end

    clientbinds = awful.util.table.join(unpack(clientbinds))

    -- Root buttons
    root.buttons(bindings.root_buttons)
---- }}}
-- }}}
-- {{{ Rules
awful.rules.rules = {
    {
        -- Default client attributes
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            buttons = bindings.client_buttons,
            size_hints_honor = false,
            focus = true,
            keys = clientbinds,
        },
    },

    {
        -- Float the GIMP
        rule = { class = "GIMP", },
        properties = { floating = true, },
    },

    {
        rule = { class = "Boecks", },
        properties = { floating = true, },
    },
}
-- }}}
-- {{{ Naughty settings
-- No padding
naughty.config.padding = 0

-- No spacing
naughty.config.spacing = -1

-- Lower timeout
naughty.config.presets.normal.timeout = 3

-- Normal colours
naughty.config.presets.normal.bg = "#444444"
naughty.config.presets.normal.fg = "#ffffff"
naughty.config.presets.normal.border_color = "#ffffff"
-- Critical colours
naughty.config.presets.critical.bg = "#ee2222"
naughty.config.presets.critical.fg = "#ffffff"
naughty.config.presets.critical.border_color = "#ff6666"

-- Regular font
naughty.config.presets.normal.font = "Terminus 10"

-- }}}
-- {{{ Mail notifier box
-- Create wibox
mailnotify = wibox({
    fg = beautiful.fg_urgent,
    bg = beautiful.bg_urgent,
    border_width = 1,
    border_color = "#ffffff",
})

-- Set geometry
mailnotify:geometry({ x = 0, y = 0, height = 20, width = 220 })
mailnotify.ontop = true
mailnotify.screen = nil

-- Create textbox
mailnotify_text = widget({ type = "textbox" })

-- Add textbox to wibox
mailnotify.widgets = {mailnotify_text, 
    layout = awful.widget.layout.horizontal.leftright}

function mailnotify_set(num)
    if num ~= 0 then
        mailnotify_text.text = "-*- Unread Mail: -["..num.."]- -*-"
        mailnotify.screen = client.focus.screen
    else
        mailnotify.screen = nil
    end
end
-- }}}
-- {{{ Listen to remote code over tempfile
remotefile = timer { timeout = 1 }
remotefile:add_signal("timeout", function()
    local file = io.open('/tmp/awesome-remote')
    local exe = {}

    if file then
        -- Read all code
        for line in file:lines() do
            table.insert(exe, line)
        end

        -- Close and delete file
        file:close()
        os.remove('/tmp/awesome-remote')

        -- Execute code
        for i, code in ipairs(exe) do
            loadstring(code)()
        end
    end
end)

remotefile:start()
-- }}}
-- {{{ Signals
-- Client manage
client.add_signal("manage", function (c, startup)
    -- Floating windows are always above the rest
    c:add_signal("property::floating", function (c)
        c.above = awful.client.property.get(c, "floating") and true or false
    end)

    if not startup then
        -- Set the windows at the slave,
        awful.client.setslave(c)
    end
end)

-- Client focus
client.add_signal("focus", function(c)
    -- Set border color
    c.border_color = beautiful.border_focus

    -- Update screen focus
    if mailnotify.screen then mailnotify.screen = c.screen end
end)

-- Client unfocus
client.add_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)
-- }}}

-- vim: set ft=lua fdm=marker:
