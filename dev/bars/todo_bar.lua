local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local naughty = require("naughty")
json = require("json")
require("functions")
local top_widgets = nil

local status_buttons = {
    selected = readall('/home/egbert/dev/maxserv-stoplicht/current_profile.txt'),
    buttons = {
    }
}

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

function add_button(id, text, txtcolor, bgcolor, selected)
    local layout = wibox.layout.align.horizontal()
    local status_box = wibox.widget.textbox('<span foreground="' .. txtcolor .. '">' .. text .. '</span>')
    --local selected_box = wibox.widget.textbox('<span foreground="' .. txtcolor .. '">&#10003;</span>')
    local selected_box = wibox.widget.textbox('<span foreground="' .. txtcolor .. '"></span>')
    layout:set_right(selected_box)

    layout:set_middle(status_box)

    local c_margin= wibox.container.margin(layout,5, 5, 5, 5)
    local bg = wibox.container.background(c_margin, bgcolor)

    status_buttons.buttons[id] = {
        button_box = bg,
        selected_box = selected_box
    }
    return bg, selected_box
end

function update_selected()
    status_buttons.selected = readall('/home/egbert/dev/maxserv-stoplicht/current_profile.txt')
    for name, button in pairs(status_buttons.buttons) do
        if status_buttons.selected == name then
            button.selected_box.markup = '<span foreground="#0000CC">&#10003;</span>'
        else
            button.selected_box.markup = '<span foreground="#0000CC"></span>'

        end
    end
end

local bar_todo = awful.wibar({
    position = "right",
    screen = 1,
    width = 300,
    stretch = true,
    visible = true
})
local bar_todo_wrapper = wibox.layout.fixed.vertical()
local todo = wibox.layout.fixed.vertical()
local buttons = wibox.layout.flex.horizontal()

button_green, green_selected_box = add_button('green','Green', 'black', '#45f442')
button_yellow, yellow_selected_box = add_button('yellow', 'Yellow', 'white', '#ed9f31')
button_red, red_selected_box = add_button('red', 'Red', 'white', '#ef5345')

for name, button in pairs(status_buttons.buttons) do
    button.button_box:buttons(awful.util.table.join(
        awful.button({ }, 1, change_stoplight(name))
    ))
end

buttons:add(button_green)
buttons:add(button_yellow)
buttons:add(button_red)

bar_todo_wrapper:add(wibox.container.margin(buttons, 0, 0, 0, 10))
bar_todo_wrapper:add(wibox.container.margin(todo, 0, 0, 0, 10))

todo:add(wibox.widget.textbox('<span size="x-large">Todo Today</span>'))
todo:add(wibox.widget.textbox('<span>Standup Jira Team</span>'))
todo:add(wibox.widget.textbox('<span>Meeting Ops</span>'))

bar_todo:set_widget(wibox.container.margin(bar_todo_wrapper, 5, 5, 5, 5))

globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, "F1", function ()
        bar_todo.visible = not bar_todo.visible
        update_selected()
    end),
    awful.key({ modkey }, "F2", function ()
        bar_todo.visible = true
        update_selected()
        awful.prompt.run({
            prompt = "Add todo: "
        }, awful.screen.focused(). mypromptbox.widget, function (data)
            todo:add(wibox.widget.textbox('<span>'..data..'</span>'))
        end)
    end)
)
update_selected()

