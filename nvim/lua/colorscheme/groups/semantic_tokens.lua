local c = require("colorscheme.colors")

local M = {}

function M.get()
	-- stylua: ignore
	---@type colorscheme.Highlights
	return {
		["@lsp.type.boolean"]                      = "@boolean",
		["@lsp.type.builtinType"]                  = "@type.builtin",
		["@lsp.type.comment"]                      = "@comment",
		-- ["@lsp.type.component"]                    = "@type.builtin", -- maybe color it smth, <CustomVueComponents>
		["@lsp.type.decorator"]                    = "@attribute",
		["@lsp.type.deriveHelper"]                 = "@attribute",
		["@lsp.type.enum"]                         = "@type",
		["@lsp.type.enumMember"]                   = "@constant.builtin",
		["@lsp.type.escapeSequence"]               = "@string.escape",
		["@lsp.type.formatSpecifier"]              = "@markup.list",
		["@lsp.type.generic"]                      = "@variable",
		["@lsp.type.interface"]                    = "@type",
		["@lsp.type.keyword"]                      = "@keyword",
		["@lsp.type.lifetime"]                     = "@keyword.storage",
		["@lsp.type.namespace"]                    = "@module",
		["@lsp.type.namespace.python"]             = "@variable",
		["@lsp.type.number"]                       = "@number",
		["@lsp.type.operator"]                     = "@operator",
		["@lsp.type.parameter"]                    = "@variable.parameter",
		["@lsp.type.property"]                     = "@property",
		["@lsp.type.selfKeyword"]                  = "@variable.builtin",
		["@lsp.type.selfTypeKeyword"]              = "@variable.builtin",
		["@lsp.type.string"]                       = "@string",
		["@lsp.type.typeAlias"]                    = "@type.definition",
		["@lsp.type.unresolvedReference"]          = { undercurl = true, sp = c.error },
		["@lsp.type.variable"]                     = {}, -- use treesitter styles for regular variables
		["@lsp.typemod.class.defaultLibrary"]      = "Structure",
		["@lsp.typemod.enum.defaultLibrary"]       = "Structure",
		["@lsp.typemod.enumMember.defaultLibrary"] = "@constant.builtin",
		["@lsp.typemod.function.defaultLibrary"]   = "@function.builtin",
		["@lsp.typemod.keyword.async"]             = "@keyword.coroutine",
		["@lsp.typemod.keyword.injected"]          = "@keyword",
		["@lsp.typemod.macro.defaultLibrary"]      = "@function.builtin",
		["@lsp.typemod.method.defaultLibrary"]     = "@function.builtin",
		["@lsp.typemod.operator.injected"]         = "@operator",
		["@lsp.typemod.string.injected"]           = "@string",
		["@lsp.typemod.struct.defaultLibrary"]     = "Structure",
		["@lsp.typemod.type.defaultLibrary"]       = "Type",
		["@lsp.typemod.typeAlias.defaultLibrary"]  = "Typedef",
		["@lsp.typemod.variable.callable"]         = "@function",
		["@lsp.typemod.variable.defaultLibrary"]   = "@variable.builtin",
		["@lsp.typemod.variable.injected"]         = "@variable",
		["@lsp.typemod.variable.static"]           = "@constant",
	}
end

return M
