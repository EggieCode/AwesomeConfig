local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
require("functions")
local top_widgets = nil

if DEV then
	top_widgets = require("dev.bars.widgets.top")
else
	top_widgets = require("bars.widgets.top")
end


awful.screen.connect_for_each_screen(function(s)
    s.top = {}

    local left_layout = wibox.layout.fixed.horizontal()
    local right_layout = wibox.layout.fixed.horizontal()
    local layout = wibox.layout.align.horizontal()

    s.mypromptbox = awful.widget.prompt()
    s.mylayoutbox = awful.widget.layoutbox(s)

    s.top.box = awful.widget.layoutbox(s)
    s.top.bar = awful.wibar({ position = "top", screen = s })


    s.top.taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    s.top.tasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    s.top.box:buttons(awful.util.table.join(
       awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
       awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end)
    ))

    left_layout:add(mylauncher)
    left_layout:add(create_margin_widget(5,5))
    left_layout:add(s.top.taglist)
    left_layout:add(wibox.container.margin(s.mypromptbox, 5, 5))

    -- Widgets that are aligned to the right
    if s.index == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(top_widgets.mytextclock)
    right_layout:add(wibox.widget.textbox(" S: " .. s.index .. "  "))
    right_layout:add(s.top.box)

    -- Now bring it all together (with the tasklist in the middle)
    layout:set_left(left_layout)
    layout:set_middle(s.top.tasklist)
    layout:set_right(right_layout)

    -- Widgets that are aligned to the left
    s.top.bar:set_widget(layout)

end)

