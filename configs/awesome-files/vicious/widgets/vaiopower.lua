------------------------------------------------------------------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2011 Manuel F. <manelfauvell@gmail.com>
-------------------------------------------------------------------------------------------------------------------

-- {{{ Grab environment
local tonumber = tonumber
local setmetatable = setmetatable
local helpers = require("vicious.helpers")
-- }}}

-- Vaiopower vicious. Shows information about power state of cd, wireless, bluetooth and audio. And fan speed too.
module("vicious.widgets.vaiopower")

function worker (format)

    local vaio = helpers.pathtotable("/sys/devices/platform/sony-laptop")
    
    if vaio.audiopower then
      audio = vaio.audiopower
    else
      audio = "N/A"
    end

    if vaio.bluetoothpower then
      blue = vaio.bluetoothpower
    else
      blue = "N/A"
    end

    if vaio.cdpower then
      cd = vaio.cdpower
    else
      cd = "N/A"
    end

    if vaio.wwanpower then
      wwan = vaio.wwanpower
    else
      wwan = "N/A"
    end

    if vaio.fanspeed then
      fan = tonumber(vaio.fanspeed)
    else
      fan = "N/A"
    end

    return {audio, blue, cd, wwan, fan}
end

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
