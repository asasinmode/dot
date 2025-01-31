local c = require("colorscheme.colors")

local M = {}

function M.get()
	-- stylua: ignore
	---@type colorscheme.Highlights
	return {
		TroubleText   = { fg = c.UNKNOWN },
		TroubleCount  = { fg = c.orange, bg = c.none },
		TroubleNormal = { fg = c.fg, bg = c.none },
	}
end

return M
