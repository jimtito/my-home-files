----------------------------------------------------------------
    -- A more advanced prompt that can display output
----------------------------------------------------------------
-- Lucas de Vries <lucas@glacicle.org>
-- Licensed under the WTFPL version 2
--   * http://sam.zoy.org/wtfpl/COPYING
----------------------------------------------------------------

-- Grab environment
local ipairs = ipairs
local pairs = pairs
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")
local setmetatable = setmetatable
local loadstring = loadstring
local table = table
local capi = {
    mouse = mouse,
    client = client,
    screen = screen,
    wibox = wibox,
    timer = timer,
    widget = widget,
}
local os = { getenv = os.getenv }
local io = { popen = io.popen }

-- Advprompt: A more advanced prompt that can display output
module("advprompt")

shell = (os.getenv("SHELL") or "/bin/sh").." -c \"exec %s\""
term = "xterm -e \"%s\""

local notifications = {}
local promptbox = nil
local textbox = nil

local function run(cmd)
    char = cmd:sub(1,1)

    if char == ";" then
        cmd = cmd:sub(2)
        pipe = io.popen(shell:format(cmd))
        data = pipe:read("*all"):gsub("[^m]*m", "")
        pipe:close()

        naughty.notify { title = cmd, text = data, timeout = 0 }
    elseif char == ":" then
        cmd = cmd:sub(2)
        loadstring(cmd)()
    elseif char == "," then
        cmd = cmd:sub(2)
        awful.util.spawn(term:format(cmd))
    elseif char == "." then
        cmd = cmd:sub(2)
        awful.util.spawn(shell:format(cmd))
    else
        awful.util.spawn(cmd)
    end
end

local function prompt(width, height, margin)
    -- Get current screen
    local sc = capi.mouse.screen

    -- Create wibox
    if not promptbox then
        promptbox = capi.wibox({
            fg = beautiful.fg_prompt or beautiful.fg_normal,
            bg = beautiful.bg_prompt or beautiful.bg_normal,
            border_width = beautiful.border_width_prompt or beautiful.border_width,
            border_color = beautiful.border_focus_prompt or beautiful.border_focus,
        })

        -- Create textbox to type in
        textbox = capi.widget({
            type = "textbox",
        })

        -- Set margin
        margin = margin or {2, 8}
        margin_v = margin[1] or margin
        margin_h = margin[2] or margin

        -- Default geometry
        promptgeom = {
            width = width or 800+margin_h*2,
            height = height or 20+margin_v*2,
            x = capi.screen[sc].workarea.width/2-(width or (800+margin_h*2))/2,
            y = 0,
        }

        awful.widget.layout.margins[textbox] = {
            right = margin_h, left = margin_h,
        }

        promptbox.widgets = {textbox,
        layout = awful.widget.layout.horizontal.leftright}
        promptbox:geometry(promptgeom)
        promptbox.ontop = true
    end

    -- Show promptbox
    promptbox.screen = sc

    -- Run prompt
    awful.prompt.run({
        prompt = "",
    }, textbox, run,
    awful.completion.shell,
    awful.util.getdir("cache").."/history",
    50,
    function ()
        promptbox.screen = nil
    end)
end

setmetatable(_M, { __call = function(_, ...) return prompt(...) end })
