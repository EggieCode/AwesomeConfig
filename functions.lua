
local wibox = require("wibox")
local awful = require("awful")

-- Read an entire file.
function readall(filename)
  local fh = assert(io.open(filename, "rb"))
  local contents = assert(fh:read("a")) -- "a" in Lua 5.3; "*a" in Lua 5.1 and 5.2
  fh:close()
  return contents
end


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

