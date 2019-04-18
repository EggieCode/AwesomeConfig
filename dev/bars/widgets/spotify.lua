-------------------------------------------------
-- Spotify Widget for Awesome Window Manager
-- Shows currently playing song on Spotify for Linux client
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/spotify-widget

-- @author Pavel Makhov
-- @copyright 2018 Pavel Makhov
-------------------------------------------------

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")

local PATH_TO_SP = '/home/egbert/bin/sp'
local PATH_TO_SP_VOLUME = '/home/egbert/bin/sp-volume'

local GET_SPOTIFY_STATUS_CMD = PATH_TO_SP .. ' status'
local GET_CURRENT_SONG_CMD = PATH_TO_SP .. ' current-oneline'
local PATH_TO_ICONS = "/usr/share/icons/Arc"

local spotify_widget = wibox.widget {
    {
        id = "icon",
        widget = wibox.widget.imagebox,
    },
    {
        id = 'current_song',
        widget = wibox.widget.textbox,
        font = 'Play 7'
    },
    layout = wibox.layout.align.horizontal,
    set_status = function(self, is_playing)
        self.icon.image = PATH_TO_ICONS ..
                (is_playing and "/actions/24/player_play.png"
                            or "/actions/24/player_pause.png")
    end,
    set_text = function(self, path)
        self.current_song.markup = path
    end,
}

local update_widget_icon = function(widget, stdout, _, _, _)
    stdout = string.gsub(stdout, "\n", "")
    widget:set_status(stdout == 'Playing' and true or false)
end

local update_widget_text = function(widget, stdout, _, _, _)
    if string.find(stdout, 'Error: Spotify is not running.') ~= nil then
        widget:set_text('')
        widget:set_visible(false)
    else
        widget:set_text(gears.string.xml_escape(stdout))
        widget:set_visible(true)
    end
end

watch(GET_SPOTIFY_STATUS_CMD, 1, update_widget_icon, spotify_widget)
watch(GET_CURRENT_SONG_CMD, 1, update_widget_text, spotify_widget)

--- Adds mouse controls to the widget:
--  - left click - play/pause
--  - scroll up - play next song
--  - scroll down - play previous song
spotify_widget:buttons(awful.util.table.join(
   awful.button({}, 1, function() awful.spawn(PATH_TO_SP .. " play", false) end),
   awful.button({'Control'}, 1, function() awful.spawn(PATH_TO_SP .. " next", false) end),
   awful.button({'Control'}, 3, function() awful.spawn(PATH_TO_SP .. " prev", false) end),
   awful.button({}, 4, function() awful.spawn(PATH_TO_SP_VOLUME .. " +1%", false) end),
   awful.button({}, 5, function() awful.spawn(PATH_TO_SP_VOLUME .. " -1%", false) end)
))

spotify_widget:connect_signal("button::press", function(_, _, _, button)
    awful.spawn.easy_async(GET_SPOTIFY_STATUS_CMD, function(stdout, stderr, exitreason, exitcode)
        update_widget_icon(spotify_widget, stdout, stderr, exitreason, exitcode)
    end)
end)

return spotify_widget
