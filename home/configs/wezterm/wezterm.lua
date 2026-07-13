local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Font configuration
config.font = wezterm.font("JetBrainsMono NF Medium")
config.font_size = 13.0

-- Basic aesthetics and cursor
config.default_cursor_style = "BlinkingBar"
config.scrollback_lines = 10000

-- Auto-switch themes based on OS Dark/Light mode
local appearance = wezterm.gui and wezterm.gui.get_appearance() or "Dark"

if appearance:find("Dark") then
    config.color_scheme = "GruvboxDarkHard"
else
    config.color_scheme = "GruvboxLight"
end

-- Window appearance
config.window_decorations = "RESIZE"
config.window_background_opacity = 1.0
config.enable_tab_bar = false

-- Keybinds
config.native_macos_fullscreen_mode = false

config.keys = {
    {
        key = "Enter",
        mods = "SHIFT",
        action = wezterm.action.SendString("\x1b[13;2u"),
    },
    {
        key = ";",
        mods = "CTRL",
        action = wezterm.action.SendString("\x1b[59;5u"),
    },
    {
        key = "Enter",
        mods = "ALT",
        action = wezterm.action.ToggleFullScreen,
    },
}

-- OS-Specific overrides
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.font_size = 10.0
    -- Launch NixOS by default on Windows
    config.default_prog = { "wsl.exe", "-d", "NixOS", "--cd", "~" }
    -- Windows: Ctrl+Backspace to delete previous word (Ctrl+W)
    table.insert(config.keys, {
        key = "Backspace",
        mods = "CTRL",
        action = wezterm.action.SendString("\x17"),
    })
elseif wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin" then
    -- macOS specific bindings (Option as Alt)
    config.send_composed_key_when_left_alt_is_pressed = false
    config.send_composed_key_when_right_alt_is_pressed = false
    -- macOS: Cmd+Backspace to delete line (Ctrl+U)
    table.insert(config.keys, {
        key = "Backspace",
        mods = "CMD",
        action = wezterm.action.SendString("\x15"),
    })
end

config.mouse_bindings = {
    -- 1. Right-click to paste from the system clipboard
    {
        event = { Down = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = wezterm.action.PasteFrom("Clipboard"),
    },
    -- 2. Automatically copy to system clipboard when releasing the left mouse button after selecting text
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "NONE",
        action = wezterm.action.CompleteSelection("ClipboardAndPrimarySelection"),
    },
}

return config
