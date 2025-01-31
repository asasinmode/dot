-- modified https://github.com/navarasu/onedark.nvim deep variant
-- heavily inspired by https://github.com/folke/tokyonight.nvim
-- and referenced with https://github.com/joshdick/onedark.vim

local c = require("colorscheme.colors")

vim.cmd("hi clear")

vim.g.colors_name = "asasinmode"

vim.g.terminal_color_0 = c.black -- black
vim.g.terminal_color_1 = c.dark_red -- maroon
vim.g.terminal_color_2 = c.dark_green -- green
vim.g.terminal_color_3 = c.dark_yellow -- olive (dark dirty yellow)
vim.g.terminal_color_4 = c.dark_blue -- navy (dark blue)
vim.g.terminal_color_5 = c.dark_purple -- purple
vim.g.terminal_color_6 = c.dark_cyan -- teal

vim.g.terminal_color_7 = c.light_gray -- silver (lighter)
vim.g.terminal_color_8 = c.gray -- gray (darker)

vim.g.terminal_color_9 = c.red -- red
vim.g.terminal_color_10 = c.green -- lime
vim.g.terminal_color_11 = c.yellow -- yellow
vim.g.terminal_color_12 = c.blue -- blue
vim.g.terminal_color_13 = c.purple -- fuchsia
vim.g.terminal_color_14 = c.cyan -- aqua (cyan)
vim.g.terminal_color_15 = c.white -- white

local groups = require("colorscheme.groups").setup()

for _, group in pairs(groups) do
	for name, hl in pairs(group) do
		hl = type(hl) == "string" and { link = hl } or hl
		vim.api.nvim_set_hl(0, name, hl)
	end
end
