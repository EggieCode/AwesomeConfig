local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local naughty = require("naughty")
local gears = require("gears")
local json = require("json")
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
            update_status_selected()
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

function update_status_selected()
    status_buttons.selected = readall('/home/egbert/dev/maxserv-stoplicht/current_profile.txt')
    for name, button in pairs(status_buttons.buttons) do
        if status_buttons.selected == name then
            button.selected_box.markup = '<span foreground="#0000CC">&#10003;</span>'
        else
            button.selected_box.markup = '<span foreground="#0000CC"></span>'

        end
    end
end

function update_todo_list()
    todo_layout:reset()
    awful.spawn.easy_async_with_shell("task export status:pending", function(output)
        local tasks = json.decode(output)
        table.sort(tasks, function(a,b) return a.urgency >b.urgency end)
        for i, task in ipairs(tasks) do
            local bg = '#020202'
            if (i % 2) == 1 then
                 bg = '#323232'
            end
            local layout = wibox.layout.align.horizontal()
            local c_margin = wibox.container.margin(layout,3,3,3,3)
            local c_bg = wibox.container.background(c_margin, bg)
            local title = wibox.widget.textbox()
            local urgency = wibox.widget.textbox()
            title.markup = gears.string.xml_escape(task.description)
            urgency.text = math.floor((task.urgency) * 100.0) / 100.0
            layout:set_left(title)
            layout:set_right(urgency)
            todo_layout:add(c_bg)
        end
    end)

end

local bar_todo = awful.wibar({
        position = "right",
        screen = 1,
        top = 0,
        width = 350,
        stretch = true,
        visible = DEV,
        ontop = true,
        opacity = 0.7,
        type = 'toolbar',
    })
local bar_todo_wrapper = wibox.layout.fixed.vertical()
local buttons = wibox.layout.flex.horizontal()
todo_layout = wibox.layout.fixed.vertical()

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
bar_todo_wrapper:add(wibox.container.margin(todo_layout, 0, 0, 0, 10))

bar_todo:set_widget(bar_todo_wrapper, 5, 5, 5, 5)

globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, "F1", function ()
        bar_todo.visible = not bar_todo.visible
        update_status_selected()
        update_todo_list()
    end),
    awful.key({ modkey }, "F2", function ()
        bar_todo.visible = true
        update_status_selected()
        update_todo_list()
        awful.prompt.run({
                prompt = "Add todo: "
            }, awful.screen.focused(). mypromptbox.widget, function (data)
                todo:add(wibox.widget.textbox('<span>'..data..'</span>'))
            end)
        end
    )
)
update_status_selected()
update_todo_list()

