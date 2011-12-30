---------------------------
-- Default awesome themes --
---------------------------

themes = {}
confdir = awful.util.getdir("config")


themes.font          = "sans 8"

themes.bg_normal     = "#000000"
themes.bg_focus      = "#310404"
themes.bg_urgent     = "#ff0000"
themes.bg_minimize   = "#444444"

themes.fg_normal     = "#999999"
themes.fg_focus      = "#aeaeae"
themes.fg_urgent     = "#ffffff"
themes.fg_minimize   = "#ffffff"

themes.border_width  = "1"
themes.border_normal = "#000000"
themes.border_focus  = "#310404"
themes.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- Example:
--themes.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
themes.taglist_squares_sel   = confdir.. "/themes/roig/taglist/squarefw.png"
themes.taglist_squares_unsel = confdir.. "/themes/roig/taglist/squarew.png"

themes.tasklist_floating_icon = confdir.. "/themes/roig/tasklist/floatingw.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
themes.menu_submenu_icon = confdir.. "/themes/roig/submenu.png"
themes.menu_height = "15"
themes.menu_width  = "100"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--themes.bg_widget = "#cc0000"

-- Define the image to load
themes.titlebar_close_button_normal = confdir.. "/themes/roig/titlebar/close_normal.png"
themes.titlebar_close_button_focus  = confdir.. "/themes/roig/titlebar/close_focus.png"

themes.titlebar_ontop_button_normal_inactive = confdir.. "/themes/roig/titlebar/ontop_normal_inactive.png"
themes.titlebar_ontop_button_focus_inactive  = confdir.. "/themes/roig/titlebar/ontop_focus_inactive.png"
themes.titlebar_ontop_button_normal_active = confdir.. "/themes/roig/titlebar/ontop_normal_active.png"
themes.titlebar_ontop_button_focus_active  = confdir.. "/themes/roig/titlebar/ontop_focus_active.png"

themes.titlebar_sticky_button_normal_inactive = confdir.. "/themes/roig/titlebar/sticky_normal_inactive.png"
themes.titlebar_sticky_button_focus_inactive  = confdir.. "/themes/roig/titlebar/sticky_focus_inactive.png"
themes.titlebar_sticky_button_normal_active = confdir.. "/themes/roig/titlebar/sticky_normal_active.png"
themes.titlebar_sticky_button_focus_active  = confdir.. "/themes/roig/titlebar/sticky_focus_active.png"

themes.titlebar_floating_button_normal_inactive = confdir.. "/themes/roig/titlebar/floating_normal_inactive.png"
themes.titlebar_floating_button_focus_inactive  = confdir.. "/themes/roig/titlebar/floating_focus_inactive.png"
themes.titlebar_floating_button_normal_active = confdir.. "/themes/roig/titlebar/floating_normal_active.png"
themes.titlebar_floating_button_focus_active  = confdir.. "/themes/roig/titlebar/floating_focus_active.png"

themes.titlebar_maximized_button_normal_inactive = confdir.. "/themes/roig/titlebar/maximized_normal_inactive.png"
themes.titlebar_maximized_button_focus_inactive  = confdir.. "/themes/roig/titlebar/maximized_focus_inactive.png"
themes.titlebar_maximized_button_normal_active = confdir.. "/themes/roig/titlebar/maximized_normal_active.png"
themes.titlebar_maximized_button_focus_active  = confdir.. "/themes/roig/titlebar/maximized_focus_active.png"

-- You can use your own command to set your wallpaper
themes.wallpaper_cmd = { "awsetbg " ..confdir.. "/themes/roig/fons.jpg" }

-- You can use your own layout icons like this:
themes.layout_fairh = confdir.. "/themes/roig/layouts/fairhw.png"
themes.layout_fairv = confdir.. "/themes/roig/layouts/fairvw.png"
themes.layout_floating  = confdir.. "/themes/roig/layouts/floatingw.png"
themes.layout_magnifier = confdir.. "/themes/roig/layouts/magnifierw.png"
themes.layout_max = confdir.. "/themes/roig/layouts/maxw.png"
themes.layout_fullscreen = confdir.. "/themes/roig/layouts/fullscreenw.png"
themes.layout_tilebottom = confdir.. "/themes/roig/layouts/tilebottomw.png"
themes.layout_tileleft   = confdir.. "/themes/roig/layouts/tileleftw.png"
themes.layout_tile = confdir.. "/themes/roig/layouts/tilew.png"
themes.layout_tiletop = confdir.. "/themes/roig/layouts/tiletopw.png"
themes.layout_spiral  = confdir.. "/themes/roig/layouts/spiralw.png"
themes.layout_dwindle = confdir.. "/themes/roig/layouts/dwindlew.png"

themes.awesome_icon = confdir.. "/themes/roig/awesome16.png"

return themes
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
