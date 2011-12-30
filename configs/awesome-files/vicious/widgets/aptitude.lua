-- Licensed under the GNU General Public License v2
--  * (c) 2010, Manuel F. <manelfauvell@gmail.com>
---------------------------------------------------

-- {{{ Grab environment
local tonumber = tonumber
local io = { popen = io.popen }
local setmetatable = setmetatable
local string = {
    find = string.find,
    match = string.match
}
-- }}}

-- Aptitude
module("vicious.widgets.aptitude")


-- {{{ Aptitude widget type
local function worker(format)
    local f = io.popen("aptitude search ~U | wc -l")
    local act = tonumber(f:read("*all"))
    f:close()
    return {act}
end

-- }}}

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
