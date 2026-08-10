-- Hyprland config, Lua format (required from 0.57 onwards).
-- Ported from hyprland.conf. See https://wiki.hypr.land/Configuring/Start/

------------------
---- COLORS ------
------------------

-- Catppuccin Mocha. Inlined from mocha.conf, which stays around for hyprlock.
local mocha = {
    rosewater = "rgb(f5e0dc)",
    flamingo  = "rgb(f2cdcd)",
    pink      = "rgb(f5c2e7)",
    mauve     = "rgb(cba6f7)",
    red       = "rgb(f38ba8)",
    maroon    = "rgb(eba0ac)",
    peach     = "rgb(fab387)",
    yellow    = "rgb(f9e2af)",
    green     = "rgb(a6e3a1)",
    teal      = "rgb(94e2d5)",
    sky       = "rgb(89dceb)",
    sapphire  = "rgb(74c7ec)",
    blue      = "rgb(89b4fa)",
    lavender  = "rgb(b4befe)",
    text      = "rgb(cdd6f4)",
    subtext1  = "rgb(bac2de)",
    subtext0  = "rgb(a6adc8)",
    overlay2  = "rgb(9399b2)",
    overlay1  = "rgb(7f849c)",
    overlay0  = "rgb(6c7086)",
    surface2  = "rgb(585b70)",
    surface1  = "rgb(45475a)",
    surface0  = "rgb(313244)",
    base      = "rgb(1e1e2e)",
    mantle    = "rgb(181825)",
    crust     = "rgb(11111b)",
}

------------------
---- MONITORS ----
------------------

hl.monitor({ output = "eDP-1", mode = "1366x768@60.00", position = "1184x320", scale = 1.00 })
hl.monitor({ output = "DP-1",  mode = "1366x768@59.79", position = "2560x320", scale = 0.90 })

---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "ghostty"
local fileManager = "nautilus"
local menu        = "wofi --show drun"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("~/.config/hypr/autostart.sh")
    hl.exec_cmd("hyprctl setcursor catppuccin-mocha-dark-cursors 28")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    hl.exec_cmd("waybar & swaync & hyprpaper & hypridle & swayosd-server")
    hl.exec_cmd("numlockx on")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct") -- change to qt6ct if you have that

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        border_size = 3,

        col = {
            active_border   = { colors = { mocha.mauve, mocha.flamingo }, angle = 90 },
            inactive_border = mocha.subtext0,
        },

        resize_on_border = true,

        gaps_in  = 0,
        gaps_out = 0,

        layout = "dwindle",

        -- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before turning this on
        allow_tearing = false,
    },

    decoration = {
        rounding = 4,

        blur = {
            enabled = true,
            size    = 3,
            passes  = 1,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true, -- you probably want this
    },

    misc = {
        force_default_wallpaper = 0, -- 0 or 1 disables the anime mascot wallpapers
    },

    ecosystem = {
        no_update_news  = true,
        no_donation_nag = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})

hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })

hl.animation({ leaf = "borderangle", enabled = true,  speed = 50,  bezier = "linear", style = "loop" })
hl.animation({ leaf = "workspaces",  enabled = true,  speed = 0.5, bezier = "default" })
hl.animation({ leaf = "windows",     enabled = false })
hl.animation({ leaf = "fade",        enabled = false })

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "latam",
        kb_variant = "",
        kb_model   = "",
        kb_options = "caps:super",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 to 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = true,
        },
    },
})

-- Per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "sigmachip-usb-mouse",
    sensitivity = -0.5,
})

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.layer_rule({
    name    = "no-anim-wofi",
    match   = { namespace = "wofi" },
    no_anim = true,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- Sound through swayosd
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"))
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))

-- Brightness through swayosd
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"))

hl.bind(mainMod .. " + T",         hl.dsp.exec_cmd(terminal .. " -e tmux new-session -A -s main"))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C",         hl.dsp.window.close())
hl.bind(mainMod .. " + M",         hl.dsp.exec_cmd("hyprmon"))
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + space",     hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind("Print",                   hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh window"))
hl.bind("SHIFT + Print",           hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh region"))
hl.bind(mainMod .. " + P",         hl.dsp.window.pseudo())
hl.bind(mainMod .. " + E",         hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + W",         hl.dsp.group.toggle())
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("killall waybar && waybar &"))

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "d" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind(mainMod .. " + A", hl.dsp.focus({ workspace = "empty" }))
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Switch tile order
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.swap({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.swap({ direction = "d" }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Shutdown menu
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("~/.config/rofi/power-menu.sh"))
hl.bind("XF86PowerOff",         hl.dsp.exec_cmd("~/.config/rofi/power-menu.sh"), { locked = true })

hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))
