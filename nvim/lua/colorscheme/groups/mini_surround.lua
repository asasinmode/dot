local c = require("colorscheme.colors")

local M = {}

function M.get()
	---@type colorscheme.Highlights
	return {
		MiniSurround = "IncSearch",
	}
end

return M
