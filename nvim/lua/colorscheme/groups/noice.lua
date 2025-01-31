local c = require("colorscheme.colors")

local M = {}

function M.get()
	---@type colorscheme.Highlights
	local ret = {
		NoiceCmdlineIconInput = { fg = c.yellow },
		NoiceCmdlineIconLua = { fg = c.blue },
		NoiceCmdlinePopupBorderInput = { fg = c.yellow },
		NoiceCmdlinePopupBorderLua = { fg = c.blue },
		NoiceCmdlinePopupTitleInput = { fg = c.yellow },
		NoiceCmdlinePopupTitleLua = { fg = c.blue },
		NoiceCompletionItemKindDefault = { fg = c.UNKNOWN, bg = c.none },
	}

	require("colorscheme.groups.kinds").kinds(ret, "NoiceCompletionItemKind%s")

	return ret
end

return M
