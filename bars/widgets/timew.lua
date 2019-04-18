local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local naughty = require("naughty")
local gears = require("gears")
local json = require("json")

local layout = wibox.layout.flex.horizontal()
local textbox = wibox.widget.textbox('')

function update()

    awful.spawn.easy_async_with_shell("timew export today", function(output)
        logs = json.decode(output)
        if #logs == 0 then
            textbox.text = 'No current timelog.'
            return
        end
        textbox.text = 'No current timelog.'

    end)
end

layout:add(textbox)
update()
return layout
