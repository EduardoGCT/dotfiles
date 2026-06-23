-- Hyprland Lua configuration converted from hyprland.conf

------------------
---- MONITORS ----
------------------

hl.monitor({
    output = "DP-1",
    mode = "1920x1080@179.96",
    position = "0x0",
    scale = 1,
})

hl.monitor({
    output = "HDMI-A-1",
    mode = "1920x1080@60.00",
    position = "1920x0",
    scale = 1,
})

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "kitty"
local fileManager = "dolphin"
local menu = "rofi -show drun"
local navegador = "brave"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("waybar &")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("kbuildsycoca6")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("org.corectrl.CoreCtrl --minimize-systray")
    hl.exec_cmd("mako")
    hl.exec_cmd("waypaper --restore")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

hl.env("XDG_MENU_PREFIX", "arch-")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in = 1,
        gaps_out = 2,
        border_size = 2,
        col = {
            active_border = { colors = { "rgb(bfa8ff)", "rgb(22086b)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 10,
        rounding_power = 2,
        active_opacity = 0.87,
        inactive_opacity = 0.80,
        shadow = {
            enabled = true,
            range = 20,
            render_power = 3,
            color = "rgba(00000079)",
        },
        blur = {
            enabled = true,
            size = 4,
            passes = 1,
            vibrancy = 0.1696,
            new_optimizations = true,
        },
    },
    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuint",   { type = "bezier", points =  { { 0.23, 1 },      { 0.32, 1 }   } })
hl.curve("easeInOutCubic", { type = "bezier", points =  { { 0.65, 0.05 },   { 0.36, 1 }   } })
hl.curve("linear",         { type = "bezier", points =  { { 0, 0 },         { 1, 1 }      } })
hl.curve("almostLinear",   { type = "bezier", points =  { { 0.5, 0.5 },     { 0.75, 1 }   } })
hl.curve("quick",          { type = "bezier", points =  { { 0.15, 0 },      { 0.1, 1 }    } })
hl.curve("overshot",       { type = "bezier", points =  { { 0.05, 0.9 },    { 0.1, 1.1 }  } })
hl.curve("appleCurve",     { type = "bezier", points =  { { 0.25, 1 },      { 0.5, 1 }    } })
hl.curve("expansaoPapel",  { type = "bezier", points =  { { 0.34, 1.56 },   { 0.64, 1 }   } })

--Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 2.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 2.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 2.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2.39, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 2.79, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 4.94, bezier = "overshot", style = "slidevert" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 2.21, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2.94, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.config({
    master = {
        new_status = "master",
    },
})

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },
})

----------------
---- INPUT -----
----------------

hl.config({
    input = {
        kb_layout = "br",
        kb_variant = "abnt2",
        kb_model = "",
        kb_options = "altwin:menu_win",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        accel_profile = "flat",
        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(navegador))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + SPACE", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -zm region"))
hl.bind(mainMod .. "+ W", hl.dsp.exec_cmd("waypaper --random"))

-- Variável para guardar o zoom atual (padrão é 1.0)
local _zoom = 1.0

local function set_zoom(delta)
    return function()
        -- Garante que o zoom nunca fique menor que 1.0
        _zoom = math.max(1.0, _zoom + delta)
        hl.config({
            cursor = {
                zoom_factor = _zoom
            }
        })
    end
end

-- Zoom In RÁPIDO (Aumenta de 0.5 em 0.5)
hl.bind(mainMod .. " + equal", set_zoom(0.5), { repeating = true })

-- Zoom Out RÁPIDO (Diminui de 0.5 em 0.5)
hl.bind(mainMod .. " + minus", set_zoom(-0.5), { repeating = true })

-- RETIRAR O ZOOM IMEDIATAMENTE (Reseta para 1.0 usando a tecla 0)
hl.bind(mainMod .. "+ ALT + 0", function()
    _zoom = 1.0
    hl.config({
        cursor = {
            zoom_factor = 1.0
        }
    })
end)

--move focus with arrows
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

--move window with arrows 
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.move({ direction = "down" }))

--swap window with arrows
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.swap({ direction = "down" }))

--resize windows witdh arrows
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x=30, y=0, relative=true }), {repeating=true})
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x=-30, y=0, relative=true }), {repeating=true})
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x=0, y=-30, relative=true }), {repeating=true})
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x=0, y=30, relative=true }), {repeating=true})


for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

------------------------------------
---- WINDOWS AND WORKSPACES --------
------------------------------------

hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
hl.workspace_rule({ workspace = "4", monitor = "DP-1" })
hl.workspace_rule({ workspace = "5", monitor = "DP-1" })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "10", monitor = "HDMI-A-1" })

hl.window_rule({
    name = "fullscreen-opaque",
    match = { fullscreen = true },
    opacity = "1.0 override 1.0 override 1.0 override",
    no_blur = true,
})

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name = "transparent-volume",
    match = { class = "(org.pulseaudio.pavucontrol)$" },
    opacity = "0.87",
    float = 1,
    size = "800 600",
    workspace = "current",
})