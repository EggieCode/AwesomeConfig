-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")


beautiful.init("/home/egbert/.config/awesome/themes/eggiecode/theme.lua")

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

screen.connect_signal("property::geometry", set_wallpaper)
for s = 1, screen.count() do
    set_wallpaper(s)
end

layouts =
{
    awful.layout.suit.max,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.floating,
    awful.layout.suit.max.fullscreen
    -- awful.layout.suit.magnifier
}
-- }}}

-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.


tags = {}
if screen.count() == 1 then
    tags[1] = awful.tag({ "Term", "Web", "Dev", "Txt" ,"Social" ,"VM", "Game" }, 1,
                    { layouts[3], layouts[1], layouts[1], layouts[1], layouts[6], layouts[7], layouts[6] }
    )
end

print ("Screens: " .. screen.count())
if screen.count() == 2 then
    tags[1] = awful.tag({ "Term", "Web", "Dev", "Txt" ,"Social" ,"VM", "Game" }, 1,
                    { layouts[3], layouts[1], layouts[1], layouts[1], layouts[6], layouts[7], layouts[6] }
    )
	tags[2] = awful.tag({ "Web", "Dev", "Txt" ,"Social" ,"VM", "Game" }, 2,
			    { layouts[1], layouts[1], layouts[1], layouts[6], layouts[7], layouts[6] }
	)
end

if screen.count() == 3 then
    tags[3] = awful.tag({ "Term", "Dev", "Dev", "Txt" ,"Social" ,"VM", "Game" }, 3,
                { layouts[3], layouts[1], layouts[1], layouts[1], layouts[6], layouts[7], layouts[6] }
    )
	tags[1] = awful.tag({ "Web", "Dev", "Txt" ,"Social" ,"VM", "Game" }, 1,
			    { layouts[1], layouts[1], layouts[1], layouts[6], layouts[7], layouts[6] }
	)
	tags[2] = awful.tag({ " 1 ", " 2 ", "3", " 4 ", " 5 ", " 6 "}, 2,
			    { layouts[4], layouts[4], layouts[4] , layouts[4], layouts[4], layouts[4]}
	)
end

for s = 4, screen.count() do
    tags[s] = awful.tag({ "Float","Full" }, s, { layouts[6], layouts[1] })
end

