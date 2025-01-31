local c = require("colorscheme.colors")

local M = {}

function M.get()
	---@type colorscheme.Highlights
	local ret = {
		fugitiveHeading = { fg = c.purple },
		fugitiveStagedHeading = { fg = c.green },
		fugitiveUnstagedHeading = { fg = c.yellow },
		fugitiveUntrackedHeading = { fg = c.red },
		fugitiveStagedModifier = { fg = c.cyan },
		fugitiveUnstagedModifier = { fg = c.cyan },
		fugitiveUntrackedModifier = { fg = c.cyan },
	}

	return ret
end

return M
