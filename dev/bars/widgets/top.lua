
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local widgets = {}

widgets['mytextclock'] = wibox.widget.textclock()

return widgets
