local c = require("colorscheme.colors")

local M = {}

function M.get()
	-- stylua: ignore
	---@type colorscheme.Highlights
	return {
		IlluminatedWordRead  = { bg = c.bg2, bold = true },
		IlluminatedWordText  = { bg = c.bg2, bold = true },
		IlluminatedWordWrite = { bg = c.bg2, bold = true },
		illuminatedCurWord   = { bg = c.bg2, bold = true },
		illuminatedWord      = { bg = c.bg2, bold = true },
	}
end

return M
