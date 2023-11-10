local wezterm = require("wezterm")

return {
	font = wezterm.font({
		family = "FiraCode Nerd Font",
		harfbuzz_features = { "cv02=1", "ss03=1", "ss05=1" },
	}),
	font_size = 18.0,
	native_macos_fullscreen_mode = true,
	hide_tab_bar_if_only_one_tab = true,
	window_background_image = wezterm.home_dir .. "/Documents/terminal.jpg",
	window_background_image_hsb = {
		brightness = 0.04,
	},
	keys = {
		{
			key = "+",
			mods = "SHIFT|ALT",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "_",
			mods = "SHIFT|ALT",
			action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
	},
}
