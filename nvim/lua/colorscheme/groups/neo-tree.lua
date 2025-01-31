local c = require("colorscheme.colors")

local M = {}

function M.get()
	---@type colorscheme.Highlights
	return {
		NeoTreeDimText = { fg = c.bg_d },
		NeoTreeFileName = { fg = c.fg },
		NeoTreeRootName = { fg = c.orange, bold = true },
		NeoTreeGitModified = { fg = c.yellow },
		NeoTreeGitStaged = { fg = c.green },
		NeoTreeGitUntracked = { fg = c.red, italic = true },
		NeoTreeNormal = { fg = c.fg, bg = c.none },
		NeoTreeNormalNC = { fg = c.fg, bg = c.none },
		NeoTreeTabActive = { fg = c.blue, bg = c.bg_dark, bold = true },
		NeoTreeTabInactive = { fg = c.UNKNOWN, bg = c.none },
		NeoTreeTabSeparatorActive = { fg = c.bg1, bg = c.none },
		NeoTreeTabSeparatorInactive = { fg = c.UNKNOWN, bg = c.none },
		NeoTreeEndOfBuffer = { fg = c.bg_d, bg = c.none },
	}
end

return M
