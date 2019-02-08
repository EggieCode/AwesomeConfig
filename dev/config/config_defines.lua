local awful = require("awful")
local menubar = require("menubar")
local beautiful = require("beautiful")
local naughty = require("naughty")
terminal = "lxterminal"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

naughty.config.defaults['icon_size'] = 100

-- Menubar configuration

mymainmenu = awful.menu({
        items = {
            { "awesome", {
                    { "manual", terminal .. " -e man awesome" },
                    { "edit config", editor_cmd .. " " .. awesome.conffile },
                    { "restart", awesome.restart },
                    { "quit", awesome.quit }
            }, beautiful.awesome_icon },
            { "Youtube MPV Clipboard", "mpv $(xclip -o)"},
            { "open terminal", terminal }
        }
    })

mylauncher = awful.widget.launcher({
        image = beautiful.awesome_icon,
        menu = mymainmenu
    })


mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytasklist = {}

mypromptbox = {}
