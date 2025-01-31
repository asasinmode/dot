local c = require("colorscheme.colors")

local M = {}

function M.get()
	---@type colorscheme.Highlights
	-- stylua: ignore
	return {
		TelescopeNormal         = { fg = c.fg, bg = c.none },
		TelescopeBorder         = { fg = c.red, bg = c.none },
		TelescopeResultsBorder	= { fg = c.cyan, bg = c.none },
		TelescopePreviewBorder	= { fg = c.cyan, bg = c.none },
		TelescopePromptBorder		= { fg = c.cyan, bg = c.none },
		TelescopePromptTitle    = { fg = c.red, bg = c.none },
		TelescopePromptPrefix		= { fg = c.green },
		TelescopeSelection			= { bg = c.bg2 },
		TelescopeSelectionCaret = { fg = c.yellow }
	}
end

return M
