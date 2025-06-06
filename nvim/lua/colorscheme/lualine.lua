local c = require("colorscheme.colors")

local base_statusline_highlights =
	{ "StatusLine", "StatusLineNC", "Tabline", "TabLineFill", "TabLineSel", "Winbar", "WinbarNC" }
for _, hl_group in pairs(base_statusline_highlights) do
	vim.api.nvim_set_hl(0, hl_group, { bg = "none" })
end

return {
	normal = {
		a = { fg = c.bg0, bg = c.green, gui = "bold" },
		b = { fg = c.fg, bg = c.bg3 },
		c = { fg = c.fg, bg = c.none },
	},
	insert = {
		a = { fg = c.bg0, bg = c.blue, gui = "bold" },
	},
	visual = {
		a = { fg = c.bg0, bg = c.purple, gui = "bold" },
	},
	replace = {
		a = { fg = c.bg0, bg = c.red, gui = "bold" },
	},
	command = {
		a = { fg = c.bg0, bg = c.yellow, gui = "bold" },
	},
	inactive = {
		a = { fg = c.gray, bg = c.bg0, gui = "bold" },
		b = { fg = c.gray, bg = c.bg0 },
		c = { fg = c.gray, bg = c.none },
	},
}
