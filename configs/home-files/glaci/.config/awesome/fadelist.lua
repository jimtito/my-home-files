----------------------------------------------------------------
-- Small pop-up taglist that displays for a limited time
----------------------------------------------------------------
-- Lucas de Vries <lucas@glacicle.org>
-- Licensed under the WTFPL version 2
--   * http://sam.zoy.org/wtfpl/COPYING
----------------------------------------------------------------
-- To use this module add:
--   require("fadelist")
-- to the top of your rc.lua, and call it:
--   fadelist(time, screen)
--
-- Parameters:
--   time   - Amount of seconds to display the box (default: 1)
--            Use time=0 to toggle the display status.
--   screen - Screen (optional), mouse.screen by default
----------------------------------------------------------------

-- Grab environment
local ipairs = ipairs
local pairs = pairs
local awful = require("awful")
local beautiful = require("beautiful")
local setmetatable = setmetatable
local capi = {
    mouse = mouse,
    client = client,
    screen = screen,
    wibox = wibox,
    timer = timer,
}

-- Fadelist: Small pop-up taglist that displays for a limited time
module("fadelist")

local wiboxes = {}
local data = {}

local function update(sc)
    -- Calculate geometry
    local margin = beautiful.fadelist_margin or 4
    local width = 0
    local height = 0

    for i,w in ipairs(data[sc].tlist) do
        if w.extents then
            local ext = w:extents()
            width = width+ext.width

            if height < ext.height then
                height = ext.height
            end
        end
    end

    -- Set geometry
    wiboxes[sc]:geometry({
        width = width,
        height = height+margin*2,
        x = capi.screen[sc].workarea.width/2-width/2,
        y = 0,
    })
end

local function show(sc)
    -- Show
    wiboxes[sc].ontop = true
    wiboxes[sc].screen = sc
    data[sc].visible = true

    -- Update
    update(sc)
end

local function hide(sc)
    -- Hide
    wiboxes[sc].screen = nil
    data[sc].visible = false
end

function display(time, s)
    if time == nil then time = 1 end
    local sc = s or capi.mouse.screen

    if not wiboxes[sc] then
        wiboxes[sc] = capi.wibox({
            fg = beautiful.fadelist_fg or beautiful.fg_normal,
            bg = beautiful.fadelist_bg or beautiful.bg_normal,
            border_width = beautiful.fadelist_border_width or beautiful.border_width,
            border_color = beautiful.fadelist_border_color or beautiful.border_color,
        })

        data[sc] = {visible=false, timer=nil}
        data[sc].tlist = awful.widget.taglist(sc, awful.widget.taglist.label.all)
        wiboxes[sc].screen = nil

        wiboxes[sc].widgets = {
            data[sc].tlist,

            layout=awful.widget.layout.horizontal.leftright
        }

        local uc = function () update(sc) end
        capi.client.add_signal("focus", uc)
        capi.client.add_signal("unfocus", uc)
        awful.tag.attached_add_signal(sc, "property::selected", uc)
        awful.tag.attached_add_signal(sc, "property::icon", uc)
        awful.tag.attached_add_signal(sc, "property::hide", uc)
        awful.tag.attached_add_signal(sc, "property::name", uc)
        capi.screen[sc]:add_signal("tag::attach", uc)
        capi.screen[sc]:add_signal("tag::detach", uc)
        capi.client.add_signal("new", function(c)
            c:add_signal("property::urgent", uc)
            c:add_signal("property::screen", uc)
            c:add_signal("tagged", uc)
            c:add_signal("untagged", uc)
        end)
        capi.client.add_signal("unmanage", uc)
    end

    if time == 0 then
        if data[sc].timer then
            data[sc].timer:stop()
            data[sc].timer = nil
            data[sc].visible = false
        end

        if data[sc].visible then
            hide(sc)
        else
            show(sc)
        end
    elseif not data[sc].visible or data[sc].timer then
        -- Show
        show(sc)

        -- Kill previous timer
        if data[sc].timer then
            data[sc].timer:stop()
        end

        -- Hide timer
        data[sc].timer = capi.timer{ timeout=time }
        data[sc].timer:add_signal("timeout", function()
            hide(sc)
            data[sc].timer:stop()
            data[sc].timer = nil
        end)
        data[sc].timer:start()
    end
end

setmetatable(_M, { __call = function(_, ...) return display(...) end })
