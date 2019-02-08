
local wibox = require("wibox")
local awful = require("awful")
require("awful.widget")
local bat = require("lain.widget.bat")
local markup = require("lain.util.markup")
local separators = require("lain.util.separators")
local spotify_widget = nil
if DEV then
    local bot_widgets = require("dev.bars.widgets.bottom")
    spotify_widget = require("dev.bars.widgets.spotify")
else
    local bot_widgets = require("bars.widgets.bottom")
    spotify_widget = require("bars.widgets.spotify")
    require("lain")
end

bottom_wibox = {}
for s = 1, screen.count() do

    bottom_wibox[s] = awful.wibar({ position = "bottom", screen = s })
    local mybattery = bat {
        ac = 'AC',
        timeout = 10,
        settings = function()
            if bat_now.status ~= "N/A" then
                widget.forced_width = 130
                widget.align = 'left'
                if bat_now.ac_status == 1 then
                    widget:set_markup(markup.font(theme.font, "AC : " .. bat_now.perc .. "% | " .. bat_now.time))
                    return
                elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                else
                end
                widget:set_markup(markup.font(theme.font, "BAT: " .. bat_now.perc .. "% | " .. bat_now.time))
            else
                widget:set_markup()
            end
        end
    }

    local left_layout = wibox.layout.fixed.horizontal()
    local left_layout2 = wibox.layout.fixed.horizontal()
    local left_layout3 = wibox.layout.fixed.horizontal()
    local spacer = wibox.widget.textbox()
    spacer.forced_width = 5

    left_layout2.forced_width = 500
    left_layout2:add(cgraph)
    left_layout2:add(spacer)
    left_layout2:add(spotify_widget)

    left_layout3:add(mybattery.widget)

    left_layout:add(left_layout2)
    left_layout:add(left_layout3)

    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(diskwidget)

    local layout = wibox.layout.align.horizontal()

    layout:set_left(left_layout)
    layout:set_right(right_layout)

    bottom_wibox[s]:set_widget(layout)

end
