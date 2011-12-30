----------------------------------------------------------------
-- Set quickmarks to windows for rapid jumping
----------------------------------------------------------------
-- Lucas de Vries <lucas@glacicle.org>
-- Licensed under the WTFPL version 2
--   * http://sam.zoy.org/wtfpl/COPYING
----------------------------------------------------------------
-- To use this module add:
--   require("quickmarks")
-- to the top of your rc.lua, and call it:
--
-- quickmarks.set(client, key)
---- Set quickmark for <key> to <client>.
--
-- quickmarks.get(key)
---- Get client with quickmark set to <key>.
--
-- quickmarks.iset([client])
---- Wait for the next keypress, then bind a quickmark for that
---- key to either the currently focused client or the client
---- given as an argument.
--
-- quickmarks.focus(key)
---- Focus the client that is bound to the quickmark for <key>.
--
-- quickmarks.ifocus()
---- Wait for the next keypress, then focus the client that is
---- bound to the quickmark for that key.
--
----------------------------------------------------------------

-- Grab environment
local ipairs = ipairs
local pairs = pairs
local awful = require("awful")
local capi = {
    mouse = mouse,
    client = client,
    screen = screen,
    wibox = wibox,
    timer = timer,
    keygrabber = keygrabber,
}

-- Quickmarks: Rapid client focus jumping by hotkey
module("quickmarks")

local marks = {}
local currentclient = nil
local lastclient = nil

local function focusclient(client)
    -- Focus screen
    capi.mouse.screen = client.screen

    -- Focus tag
    awful.tag.viewonly(client:tags()[1])

    -- Focus window
    capi.client.focus = client
end

function set(client, key)
    -- Set client
    marks[key] = client
end

function get(key)
    -- Get client
    return marks[key]
end

function focus(key)
    -- Get client
    if key == "^^" then
        client = lastclient
    else
        client = get(key)
    end

    if not client then
        return 1
    end

    -- Check if we already have the client focussed
    if capi.client.focus == client and lastclient then
        -- Focus last focused client
        focusclient(lastclient)
    else
        -- Focus found client
        focusclient(client)
    end
end


function iset(client)
    local cl = client or capi.client.focus

    capi.keygrabber.run(
    function(modifiers, key, event)
        -- Ignore everything but keypresses from normal keys
        if event ~= "press"
           or key == "Control_L"
           or key == "Control_R"
           or key == "Super_L"
           or key == "Super_R"
           or key == "Shift_L"
           or key == "Shift_R"
           or key == "Hyper_L"
           or key == "Hyper_R"
           or key == "Alt_L"
           or key == "Alt_R"
           or key == "Meta_L"
           or key == "Meta_R"
           or key == "ISO_Level3_Shift"
        then return true end

        -- Check for shift
        for i,mod in ipairs(modifiers) do
            if mod == "Shift" then
                key = key:upper()
            end
        end

        -- Set key
        set(cl, key)
        return false
    end)
end

function ifocus()
    local shifted = false

    capi.keygrabber.run(
    function(modifiers, key, event)
        -- Ignore everything but keypresses from normal keys
        if event ~= "press"
           or key == "Control_L"
           or key == "Control_R"
           or key == "Super_L"
           or key == "Super_R"
           or key == "Shift_L"
           or key == "Shift_R"
           or key == "Hyper_L"
           or key == "Hyper_R"
           or key == "Alt_L"
           or key == "Alt_R"
           or key == "Meta_L"
           or key == "Meta_R"
           or key == "ISO_Level3_Shift"
        then return true end

        -- Check for shift
        for i,mod in ipairs(modifiers) do
            if mod == "Shift" then
                key = key:upper()
            end
        end

        -- Focus to key
        focus(key)
        return false
    end)
end


-- Keep track of globally previously focused
capi.client.add_signal("focus", function (c)
    lastclient = currentclient
    currentclient = c
end)

capi.client.add_signal("unmanage", function (c)
    if lastclient == c then
        lastclient = nil
    end

    if currentclient == c then
        lastclient = nil
    end
end)
