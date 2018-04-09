local awful = require("awful")
local menubar = require("menubar")
local beautiful = require("beautiful")
modkey = "Mod4"
terminal = "lxterminal"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
menubar.utils.terminal = terminal -- Set the terminal for applications that require it


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

-- }}}

-- {{{ Wibox
-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytasklist = {}

mypromptbox = {}
