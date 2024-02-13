local wezterm = require("wezterm")
local barn = require("barn")

local leader = { key = "a", mods = "CTRL" }

return {
	color_scheme = "tokyonight_storm",

	font = wezterm.font({ family = "ComicCode Nerd Font", weight = "Medium" }),
	font_size = 12,
	front_end = "WebGpu", -- fixes font "too thin" issues

	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = true,
	use_fancy_tab_bar = false,

	leader = leader,
	keys = {
		{
			key = "a",
			mods = "LEADER|CTRL",
			action = barn.NvimConfigurePrefix(leader),
		},

		-- window/pane creation
		{
			key = '"',
			mods = "LEADER",
			action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "%",
			mods = "LEADER",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "c",
			mods = "LEADER",
			action = wezterm.action.SpawnTab("CurrentPaneDomain"),
		},

		-- zoom pane
		{
			key = "z",
			mods = "LEADER",
			action = wezterm.action.TogglePaneZoomState,
		},

		-- windown navigation
		{
			key = "h",
			mods = "LEADER|CTRL",
			action = wezterm.action.ActivateTabRelative(-1),
		},
		{
			key = "l",
			mods = "LEADER|CTRL",
			action = wezterm.action.ActivateTabRelative(1),
		},
		{
			key = "1",
			mods = "LEADER",
			action = wezterm.action.ActivateTab(0),
		},
		{
			key = "2",
			mods = "LEADER",
			action = wezterm.action.ActivateTab(1),
		},
		{
			key = "3",
			mods = "LEADER",
			action = wezterm.action.ActivateTab(2),
		},
		{
			key = "4",
			mods = "LEADER",
			action = wezterm.action.ActivateTab(3),
		},
		{
			key = "5",
			mods = "LEADER",
			action = wezterm.action.ActivateTab(4),
		},
		{
			key = "6",
			mods = "LEADER",
			action = wezterm.action.ActivateTab(5),
		},
		{
			key = "7",
			mods = "LEADER",
			action = wezterm.action.ActivateTab(6),
		},
		{
			key = "8",
			mods = "LEADER",
			action = wezterm.action.ActivateTab(7),
		},
		{
			key = "9",
			mods = "LEADER",
			action = wezterm.action.ActivateTab(8),
		},

		-- killing panes
		{
			key = "&",
			mods = "LEADER|SHIFT",
			action = wezterm.action.CloseCurrentTab({ confirm = true }),
		},
		{
			key = "d",
			mods = "LEADER",
			action = wezterm.action.CloseCurrentPane({ confirm = true }),
		},
		{
			key = "x",
			mods = "LEADER",
			action = wezterm.action.CloseCurrentPane({ confirm = true }),
		},

		-- window navigation
		{
			key = "w",
			mods = "LEADER",
			action = wezterm.action.ShowTabNavigator,
		},

		-- nvim integration
		-- if nvim is detected inside the pane, forward the keys to it,
		-- otherwise perform usual actions.

		-- pane navigation
		{
			key = "h",
			mods = "LEADER",
			action = barn.NvimActivatePaneDirection(leader, { key = "h" }, "Left"),
		},
		{
			key = "j",
			mods = "LEADER",
			action = barn.NvimActivatePaneDirection(leader, { key = "j" }, "Down"),
		},
		{
			key = "k",
			mods = "LEADER",
			action = barn.NvimActivatePaneDirection(leader, { key = "k" }, "Up"),
		},
		{
			key = "l",
			mods = "LEADER",
			action = barn.NvimActivatePaneDirection(leader, { key = "l" }, "Right"),
		},
		-- window resizing
		-- see key_tables below
		{
			key = "H",
			mods = "LEADER|SHIFT",
			action = barn.NvimAdjustPaneSize(leader, { key = "H", mods = "SHIFT" }),
		},
		{
			key = "J",
			mods = "LEADER|SHIFT",
			action = barn.NvimAdjustPaneSize(leader, { key = "J", mods = "SHIFT" }),
		},
		{
			key = "K",
			mods = "LEADER|SHIFT",
			action = barn.NvimAdjustPaneSize(leader, { key = "K", mods = "SHIFT" }),
		},
		{
			key = "L",
			mods = "LEADER|SHIFT",
			action = barn.NvimAdjustPaneSize(leader, { key = "L", mods = "SHIFT" }),
		},
	},

	key_tables = {
		resize_pane = {
			{ key = "H", mods = "SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
			{ key = "L", mods = "SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
			{ key = "K", mods = "SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
			{ key = "J", mods = "SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
		},
	},
}
