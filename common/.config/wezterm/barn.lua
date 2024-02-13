local M = {}

local wezterm = require("wezterm")
local platform = package.config:sub(1, 1) == "\\" and "win" or "unix"

---@param str string path
---@return string _ base name of input path
local function basename(str)
	local sep = "/"
	if platform == "win" then
		sep = "\\"
	end
	local name, _ = str:gsub("(.*" .. sep .. ")(.*)", "%2")
	return name
end

---Key action that activated pane direction with nvim integration.
---@param leader table<string, string> leader key combo
---@param key table<string, string> key binding this action is bound to.
---@param direction "Left"|"Right"|"Up"|"Down"
---@return table
function M.NvimActivatePaneDirection(leader, key, direction)
	return wezterm.action_callback(function(window, pane)
		local is_nvim = basename(pane:get_foreground_process_name()) == "nvim"

		if is_nvim then
			window:perform_action(wezterm.action.SendKey(leader), pane)
			window:perform_action(wezterm.action.SendKey(key), pane)
		else
			window:perform_action(wezterm.action.ActivatePaneDirection(direction), pane)
		end
	end)
end

---Key action that resizes current pane with nvim integration.
---@param leader table<string, string> leader key combo
---@param key table<string, string> key binding this action is bound to.
---@return table
function M.NvimAdjustPaneSize(leader, key)
	return wezterm.action_callback(function(window, pane)
		local is_nvim = basename(pane:get_foreground_process_name()) == "nvim"

		if is_nvim then
			window:perform_action(wezterm.action.SendKey(leader), pane)
			window:perform_action(wezterm.action.SendKey(key), pane)
		else
			window:perform_action(
				wezterm.action.ActivateKeyTable({
					name = "resize_pane",
					one_shot = false,
					timeout_milliseconds = 800,
				}),
				pane
			)
		end
	end)
end

---Key action that configures prefix passing to running programs.
---@param leader table<string, string> leader key combo
---@return table
function M.NvimConfigurePrefix(leader)
	return wezterm.action_callback(function(window, pane)
		local is_nvim = basename(pane:get_foreground_process_name()) == "nvim"

		if is_nvim then
			-- send leader two times (barn needs this - enter mode, press)
			window:perform_action(wezterm.action.SendKey(leader), pane)
			window:perform_action(wezterm.action.SendKey(leader), pane)
		else
			window:perform_action(wezterm.action.SendKey(leader), pane)
		end
	end)
end

return M
