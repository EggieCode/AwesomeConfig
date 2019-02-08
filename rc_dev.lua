local info = debug.getinfo(1,'S');

function stripfilename(filename)
	return string.match(filename, "(.+)/[^/]*%.%w+$")
end

function getfilename(filename)
	local path = string.match(filename, "(.+)/[^/]*%.%w+$")
	return filename:sub(path:len() + 2)
end


if getfilename(info.source) == "rc.lua" then
	DEV = false
	print "\n\n----------"
	print "Production version"
	print "---------\n\n"
else
	DEV = true
	print "\n\n----------"
	print "Development version"
	print "---------\n\n"
end

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
vicious = require("vicious")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

if DEV then
    modkey = "Mod1"
	require("dev.config.config_layout")
	require("dev.config.config_defines")
	require("dev.config.config_signals")
	require("dev.config.config_rules")
	require("dev.bars.top_bar")
	require("dev.bars.todo_bar")
	require("dev.bars.bottom_bar")
else
    modkey = "Mod4"
	require("config.config_layout")
	require("config.config_defines")
	require("config.config_signals")
	require("config.config_rules")
	require("bars.top_bar")
	require("bars.todo_bar")
	require("bars.bottom_bar")
end

root.keys(globalkeys)
require("functions")


run_once("firefox", nil, '/usr/lib/firefox/firefox')
run_once("evolution")
awful.util.spawn_with_shell("xbacklight","=80")
run_once("nm-applet")
run_once("mpd")
run_once("xset", "s 120 120")
run_once("light-locker", "--idle-hint --lock-after-screensaver=10 --lock-on-suspend", "light-locker")
awful.spawn.with_shell("xinput", "set-prop", "Primax Kensington Eagle Trackball", "libinput Accel Speed", "-0.8")
