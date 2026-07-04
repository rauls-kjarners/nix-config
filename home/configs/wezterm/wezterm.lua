local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Font configuration
config.font = wezterm.font_with_fallback({
	"JetBrainsMono NF", -- Nerd Fonts v3.0+
	"JetBrains Mono Nerd Font", -- Nerd Fonts v2.0
})
config.font_size = 13.0

-- Basic aesthetics and cursor
config.default_cursor_style = "BlinkingBar"
config.scrollback_lines = 10000

-- Auto-switch themes based on OS Dark/Light mode
local appearance = wezterm.gui and wezterm.gui.get_appearance() or "Dark"

if appearance:find("Dark") then
	config.color_scheme = "Dracula (Official)"
else
	-- Define Alucard inline for Light mode since WezTerm doesn't have it natively
	config.color_schemes = {
		["Alucard"] = {
			background = "#FFFBEB",
			foreground = "#1F1F1F",
			cursor_bg = "#A3144D",
			cursor_fg = "#FFFBEB",
			selection_bg = "#CFCFDE",
			selection_fg = "#1F1F1F",
			ansi = {
				"#1F1F1F",
				"#CB3A2A",
				"#14710A",
				"#846E15",
				"#644AC9",
				"#A3144D",
				"#036A96",
				"#CFCFDE",
			},
			brights = {
				"#6C664B",
				"#D74C3D",
				"#198D0C",
				"#9E841A",
				"#7862D0",
				"#BF185A",
				"#047FB4",
				"#FFFBEB",
			},
		},
	}
	config.color_scheme = "Alucard"
end

-- Window appearance
config.window_decorations = "RESIZE"
config.window_background_opacity = 1.0
config.enable_tab_bar = false

-- OS-Specific overrides
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.font_size = 10.0
	-- Launch NixOS by default on Windows
	config.default_domain = "WSL:NixOS"
	config.wsl_domains = {
		{
			name = "WSL:NixOS",
			distribution = "NixOS",
			username = "nixos",
		},
	}
elseif wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin" then
	-- macOS specific bindings (Option as Alt)
	config.send_composed_key_when_left_alt_is_pressed = false
	config.send_composed_key_when_right_alt_is_pressed = false
end

-- Keybinds and Mouse Bindings
config.keys = {}

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
