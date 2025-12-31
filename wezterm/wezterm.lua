local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local config = {}

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

config.default_prog = { "wsl", "--cd", "~" }
config.window_background_opacity = 0.9
config.window_padding = {
	left = 70,
	right = 70,
	top = 70,
	bottom = 70,
}
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 11.0
config.color_scheme = "tokyonight_moon"
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.command_palette_rows = 7
config.command_palette_font_size = 12.0
config.command_palette_bg_color = "#000000"
config.check_for_updates = false
config.default_cursor_style = "SteadyUnderline"
config.cursor_thickness = 2
config.hide_mouse_cursor_when_typing = false
config.pane_focus_follows_mouse = false
config.prefer_to_spawn_tabs = true
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "RESIZE"
-- config.win32_system_backdrop = "Acrylic"

config.front_end = "OpenGL"
--config.front_end = "WebGpu"
--config.webgpu_power_preference = "HighPerformance"
--local gpus = wezterm.gui.enumerate_gpus()
--config.webgpu_preferred_adapter = gpus[1]

config.keys = {
	{
		key = "q",
		mods = "CTRL|ALT",
		action = act.QuitApplication,
	},
	{
		key = "t",
		mods = "CTRL|SHIFT",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "w",
		mods = "CTRL",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "Enter",
		mods = "CTRL|ALT",
		action = act.ToggleFullScreen,
	},
	{
		key = "_",
		mods = "CTRL|SHIFT",
		action = act.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "|",
		mods = "CTRL|SHIFT",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 54 },
		}),
	},
	{
		key = "LeftArrow",
		mods = "ALT",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "RightArrow",
		mods = "ALT",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "UpArrow",
		mods = "ALT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "DownArrow",
		mods = "ALT",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "r",
		mods = "CTRL|ALT",
		action = wezterm.action.ReloadConfiguration,
	},
	{
		key = "v",
		mods = "CTRL",
		action = act.PasteFrom("Clipboard"),
	},
	{
		key = "t",
		mods = "CTRL|ALT",
		action = wezterm.action.ShowTabNavigator,
	},
	{
		key = "C",
		mods = "CTRL",
		action = wezterm.action.CopyTo("Clipboard"),
	},
	{
		key = "H",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "J",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{ key = "K", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
	{
		key = "L",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	-- {
	-- 	key = "l",
	-- 	mods = "CTRL",
	-- 	action = act.Hide,
	-- },
	{
		key = "F",
		mods = "CTRL|SHIFT",
		action = act.Search("CurrentSelectionOrEmptyString"),
	},
	-- { key = "L", mods = "CTRL|SHIFT", action = wezterm.action.ShowDebugOverlay },
}

wezterm.on("user-var-changed", function(window, pane, name, value)
	if name == "nvim_padding" then
		if value == "0" then
			window:set_config_overrides({
				window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
			})
		elseif value == "default" then
			window:set_config_overrides({
				window_padding = { left = 70, right = 70, top = 70, bottom = 70 },
			})
		end
	end
end)

return config
