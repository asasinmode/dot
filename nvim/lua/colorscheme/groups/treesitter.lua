local c = require("colorscheme.colors")

local M = {}

function M.get()
	-- stylua: ignore
	---@type colorscheme.Highlights
	local ret = {
		["@annotation"]                 = "PreProc",
		["@attribute"]                  = "PreProc",
		["@boolean"]                    = "Boolean",
		["@character"]                  = "Character",
		["@character.printf"]           = "SpecialChar",
		["@character.special"]          = "SpecialChar",
		["@comment"]                    = "Comment",
		["@comment.error"]              = { fg = c.red },
		["@comment.hint"]               = { fg = c.purple },
		["@comment.info"]               = { fg = c.cyan },
		["@comment.note"]               = { fg = c.purple },
		["@comment.todo"]               = { fg = c.blue },
		["@comment.warning"]            = { fg = c.yellow },
		["@constant"]                   = "Constant",
		["@constant.builtin"]           = { fg = c.orange },
		["@constant.macro"]             = "Define",
		["@constructor"]                = { fg = c.yellow }, -- For constructor calls and definitions: `= { }` in Lua, and Java constructors.
		["@diff.delta"]                 = "DiffChange",
		["@diff.minus"]                 = "DiffDelete",
		["@diff.plus"]                  = "DiffAdd",
		["@function"]                   = "Function",
		["@function.builtin"]           = "Function",
		["@function.call"]              = "@function",
		["@function.macro"]             = "Macro",
		["@function.method"]            = "Function",
		["@function.method.call"]       = "@function.method",
		["@keyword"]                    = { fg = c.purple }, -- For keywords that don't fall in previous categories.
		["@keyword.conditional"]        = "Conditional",
		["@keyword.coroutine"]          = "@keyword",
		["@keyword.debug"]              = "Debug",
		["@keyword.directive"]          = "PreProc",
		["@keyword.directive.define"]   = "Define",
		["@keyword.exception"]          = "Exception",
		["@keyword.function"]           = { fg = c.purple }, -- For keywords used to define a function.
		["@keyword.import"]             = "Include",
		["@keyword.operator"]           = { fg = c.purple },
		["@keyword.repeat"]             = "Repeat",
		["@keyword.return"]             = "@keyword",
		["@keyword.storage"]            = "StorageClass",
		["@label"]                      = { fg = c.red }, -- For labels: `label:` in C and `:label:` in Lua.
		["@markup"]                     = "@none",
		["@markup.emphasis"]            = { italic = true },
		["@markup.environment"]         = "Macro",
		["@markup.environment.name"]    = "Type",
		["@markup.heading"]             = "Title",
		["@markup.italic"]              = { italic = true },
		["@markup.link"]                = { fg = c.blue },
		["@markup.link.label"]          = "@markup.link",
		["@markup.link.label.symbol"]   = "Identifier",
		["@markup.link.url"]            = "Underlined",
		["@markup.list"]                = { fg = c.red }, -- For special punctutation that does not fall in the categories before.
		["@markup.list.checked"]        = { fg = c.green }, -- For brackets and parens.
		["@markup.list.markdown"]       = { fg = c.orange, bold = true },
		["@markup.list.unchecked"]      = { fg = c.blue }, -- For brackets and parens.
		["@markup.math"]                = "Special",
		["@markup.raw"]                 = "String",
		["@markup.raw.markdown_inline"] = { fg = c.green, bg = c.none },
		["@markup.strikethrough"]       = { strikethrough = true },
		["@markup.strong"]              = { bold = true },
		["@markup.underline"]           = { underline = true },
		["@module"]                     = "Include",
		["@module.typescript"]          = "@variable.typescript",
		["@module.builtin"]             = { fg = c.red }, -- Variable names that are defined by the languages, like `this` or `self`.
		["@namespace.builtin"]          = "@variable.builtin",
		["@none"]                       = {},
		["@number"]                     = "Number",
		["@number.float"]               = "Float",
		["@operator"]                   = { fg = c.fg }, -- For any operator: `+`, but also `->` and `*` in C.
		["@property"]                   = { fg = c.cyan },
		["@punctuation.bracket"]        = { fg = c.light_gray }, -- For brackets and parens.
		["@punctuation.delimiter"]      = { fg = c.light_gray }, -- For delimiters ie: `.`
		["@punctuation.special"]        = { fg = c.red }, -- For special symbols (e.g. `{}` in string interpolation)
		["@punctuation.special.markdown"] = { fg = c.bg3 }, -- For special symbols (e.g. `{}` in string interpolation), also hover information separator
		["@string"]                     = "String",
		["@string.documentation"]       = { fg = c.yellow },
		["@string.escape"]              = { fg = c.red }, -- For escape characters within a string.
		["@string.regexp"]              = { fg = c.orange }, -- For regexes.
		["@string.special.url"]					= { link = "@string", underline = true },
		["@tag"]                        = "Label",
		["@tag.attribute"]              = { fg = c.yellow },
		["@tag.delimiter"]              = "Delimiter",
		["@tag.delimiter.tsx"]          = { fg = c.UNKNOWN },
		["@tag.tsx"]                    = { fg = c.red },
		["@tag.javascript"]             = { fg = c.red },
		["@type"]                       = "Type",
		["@type.builtin"]               = { fg = c.orange },
		["@type.definition"]            = "Typedef",
		["@type.qualifier"]             = "@keyword",
		["@variable"]                   = { fg = c.fg }, -- Any variable name that does not have another highlight.
		["@variable.builtin"]           = { fg = c.red }, -- Variable names that are defined by the languages, like `this` or `self`.
		["@variable.member"]            = { fg = c.cyan }, -- For fields.
		["@variable.parameter"]         = { fg = c.red }, -- For parameters of a function.
		["@variable.parameter.builtin"] = { fg = c.UNKNOWN }, -- For builtin parameters of a function, e.g. "..." or Smali's p[1-99]
	}

	for i, color in ipairs(c.rainbow) do
		ret["@markup.heading." .. i .. ".markdown"] = { fg = color, bold = true }
	end

	return ret
end

return M
