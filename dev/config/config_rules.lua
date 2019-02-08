local awful = require("awful")
local beautiful = require("beautiful")
awful.rules = require("awful.rules")

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            maximized = false,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
    }},
    { rule_any = {
            instance = {
                "DTA",  -- Firefox addon DownThemAll.
                "copyq",  -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Wpa_gui",
                "veromix",
                "xtightvncviewer"
            },

            name = {
                "Event Tester",  -- xev.
            },
            role = {
                "AlarmWindow",  -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
    properties = { floating = true }},
    { rule_any =  { type = { "normal", "dialog" }},
        properties = { titlebars_enabled = true }
    },
    { rule = { class = "MPlayer" },
    properties = { floating = true } },
    { rule = { class = "pinentry" },
    properties = { floating = true } },
    { rule = { class = "gimp" },
    properties = { floating = true } },
    { rule = { class = "Xmessage" },
    properties = { floating = true } },
    { rule = { instance = "Download" },
    properties = { floating = true }, },
    { rule = { instance = "plugin-container" },
    properties = { floating = true } },
    { rule = { name = "termfloat" },
    properties = { floating = true  } },
    { rule = { name = "qtcreator_process_stub" },
    properties = { floating = true  } },
    { rule = { instance = "guake" },
    properties = { floating = true } },

    -- Set Firefox to always map on tags number 2 of screen 1.
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
if screen.count() == 1 then
    awful.rules.rules = awful.util.table.join(awful.rules.rules, {
            { rule = { class = "Firefox" },
            properties = { tag = tags[1][2], maximized = false } },
            { rule = { class = "Evolution" },
            properties = { tag = tags[1][2], maximized = false  } }
        })
elseif screen.count() == 2 then
    awful.rules.rules = awful.util.table.join(awful.rules.rules, {
            { rule = { class = "Firefox" },
            properties = { tag = tags[2][1], maximized = false } },
            { rule = { class = "Evolution" },
            properties = { tag = tags[2][1], maximized = false  } },
        })
elseif screen.count() == 3 then
    awful.rules.rules = awful.util.table.join(awful.rules.rules, {
            { rule = { class = "Firefox" },
            properties = { tag = tags[1][1], maximized = false } },
            { rule = { class = "Evolution" },
            properties = { tag = tags[1][1], maximized = false  } },
        })
end
