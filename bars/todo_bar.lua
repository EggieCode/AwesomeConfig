local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local naughty = require("naughty")
json = require("json")
require("functions")
local top_widgets = nil

function change_stoplight(light)
	return function()
        awful.spawn.easy_async_with_shell("/home/egbert/dev/maxserv-stoplicht/change-stoplight.sh " .. light, function(output)
            res = json.decode(output)
            if res['success'] then
                fg = '#030303'
                bg = '#f3f3f3'
            else
                fg = '#dd0000'
                bg = '#111111'
            end
            naughty.notify({
                preset = {
                    title   = res['message'],
                    timeout = 10,
                    fg      = fg,
                    bg      = bg
                },
            })
            update_selected()
        end)
    end
end

function create_button(text, txtcolor, bgcolor, selected)
    local layout = wibox.layout.align.horizontal()
    local status_box = wibox.widget.textbox('<span foreground="' .. txtcolor .. '">' .. text .. '</span>')
    --local selected_box = wibox.widget.textbox('<span foreground="' .. txtcolor .. '">&#10003;</span>')
    local selected_box = wibox.widget.textbox('<span foreground="' .. txtcolor .. '"></span>')
    layout:set_right(selected_box)

    layout:set_middle(status_box)

    local c_margin= wibox.container.margin(layout,5, 5, 5, 5)
    local bg = wibox.container.background(c_margin, bgcolor)

    return bg, selected_box
end

function update_selected() 
    current_stoplight_status = readall('/home/egbert/dev/maxserv-stoplicht/current_profile.txt')

    if current_stoplight_status == 'red' then
        red_selected_box.markup = '<span foreground="#0000CC">&#10003;</span>'
        yellow_selected_box.markup = '<span foreground="#0000CC"></span>'
        green_selected_box.markup = '<span foreground="#0000CC"></span>'
    end
    if current_stoplight_status == 'yellow' then
        yellow_selected_box.markup = '<span foreground="#0000CC">&#10003;</span>'
        red_selected_box.markup = '<span foreground="#0000CC"></span>'
        green_selected_box.markup = '<span foreground="#0000CC"></span>'

    end
    if current_stoplight_status == 'green' then
        green_selected_box.markup = '<span foreground="#0000CC">&#10003;</span>'
        red_selected_box.markup = '<span foreground="#0000CC"></span>'
        yellow_selected_box.markup = '<span foreground="#0000CC"></span>'
    end
end

local bar_todo = awful.wibar({
    position = "right",
    screen = 1,
    width = 300,
    stretch = true,
    visible = true
})

local todo = wibox.layout.fixed.vertical()
local buttons = wibox.layout.flex.horizontal()

button_green, green_selected_box = create_button('Green', 'black', '#45f442')
button_yellow, yellow_selected_box = create_button('Yellow', 'white', '#ed9f31')
button_red, red_selected_box = create_button('Red', 'white', '#ef5345')

button_green:buttons(awful.util.table.join(
    awful.button({ }, 1, change_stoplight('green'))
))
button_yellow:buttons(awful.util.table.join(
    awful.button({ }, 1, change_stoplight('yellow'))
))
button_red:buttons(awful.util.table.join(
    awful.button({ }, 1, change_stoplight('red'))
))


buttons:add(button_green)
buttons:add(button_yellow)
buttons:add(button_red)

todo:add(wibox.container.margin(buttons, 0, 0, 0, 10))
todo:add(wibox.widget.textbox('<span size="x-large">Todo Today</span>'))
todo:add(wibox.widget.textbox('<span>Standup Jira Team</span>'))
todo:add(wibox.widget.textbox('<span>Meeting Ops</span>'))

bar_todo:set_widget(wibox.container.margin(todo, 5, 5, 5, 5))

globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, "F1", function ()
        bar_todo.visible = not bar_todo.visible
        update_selected()
    end)
)

update_selected()
