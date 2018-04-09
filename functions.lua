
local wibox = require("wibox")
local awful = require("awful")

function create_margin_widget(margin_left, margin_right)
	w = wibox.widget.textbox()
	return wibox.container.margin(w, margin_left, margin_right)
end


function run_once(prg,arg_string,pname,screen)
    if not prg then
        do return nil end
    end

    if not pname then
       pname = prg
    end

    if not arg_string then
        awful.spawn.with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
    else
        awful.spawn.with_shell("pgrep -f -u $USER -x '" .. pname .. " ".. arg_string .."' || (" .. prg .. " " .. arg_string .. ")",screen)
    end
end

