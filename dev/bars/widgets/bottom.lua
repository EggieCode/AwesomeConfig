local wibox = require("wibox")
local awful = require("awful")

require("awful.widget")
local naughty = require("naughty")
vicious = require("vicious")
require("vicious.widgets")



ctext = wibox.widget.textbox()
cgraph = wibox.widget.graph()
cgraph:set_width(100):set_height(10)
cgraph:set_stack(true):set_max_value(100)
cgraph:set_background_color("#494B4F")
cgraph:set_stack_colors({ "#FF5656", "#88A175", "#AECF96" })
vicious.register(ctext, vicious.widgets.cpu,
	function (widget, args)
		cgraph:add_value(args[2], 1) -- Core 1, color 1
		cgraph:add_value(args[3], 2) -- Core 2, color 2
		cgraph:add_value(args[4], 3) -- Core 3, color 3
		return ""
	end, 3)



diskwidget = wibox.widget.textbox()

--diskwidget:set_width(100)
vicious.register(diskwidget, vicious.widgets.fs, "HOME: ${/home used_gb}GB/${/home size_gb}GB", 60)
diskwidget = wibox.container.margin(diskwidget, 0, 5)
