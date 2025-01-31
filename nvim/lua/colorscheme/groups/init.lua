local M = {}

local groups = {
	"base",
	"kinds",
	"semantic_tokens",
	"treesitter",

	"blink",
	"fugitive",
	"leap",
	"mini_surround",
	"neo-tree",
	"noice",
	"telescope",
	"trouble",
	"vim-illuminate",

	"custom",
}

function M.setup()
	local rv = {}

	for _, group in ipairs(groups) do
		rv[group] = require("colorscheme.groups." .. group).get()
	end

	return rv
end

return M
