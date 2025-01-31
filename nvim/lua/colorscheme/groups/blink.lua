local c = require("colorscheme.colors")

local M = {}

function M.get()
	---@type colorscheme.Highlights
	local ret = {
		BlinkCmpDoc = { fg = c.fg, bg = c.bg_float },
		BlinkCmpDocBorder = { fg = c.border_highlight, bg = c.bg_float },
		BlinkCmpGhostText = { fg = c.terminal_black },
		BlinkCmpKindDefault = { fg = c.fg_dark, bg = c.none },
		BlinkCmpLabel = { fg = c.fg, bg = c.none },
		BlinkCmpLabelDeprecated = { fg = c.fg_gutter, bg = c.none, strikethrough = true },
		BlinkCmpLabelMatch = { fg = c.blue1, bg = c.none },
	}

	require("colorscheme.groups.kinds").kinds(ret, "BlinkCmpKind%s")

	return ret
end

return M
