local c = require("colorscheme.colors")

local M = {}

function M.get()
	-- stylua: ignore
	---@type colorscheme.Highlights
	return {
		ColorColumn                 = { bg = c.bg1 }, -- used for the columns set with 'colorcolumn'
		Conceal                     = { fg = c.gray, bg = c.bg1 }, -- placeholder characters substituted for concealed text (see 'conceallevel')
		Cursor                      = { fg = c.bg0, bg = c.fg }, -- character under the cursor
		lCursor                     = { fg = c.bg0, bg = c.fg }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
		CursorIM                    = { fg = c.bg0, bg = c.fg }, -- like Cursor, but used when in IME mode |CursorIM|
		CursorColumn                = { bg = c.bg1 }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
		CursorLine                  = { bg = c.bg1 }, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if foreground (ctermfg OR guifg) is not set.
		Directory                   = { fg = c.blue }, -- directory names (and other special names in listings)
		DiffAdd                     = { bg = c.diff.add }, -- diff mode: Added line |diff.txt|
		DiffChange                  = { bg = c.diff.change }, -- diff mode: Changed line |diff.txt|
		DiffDelete                  = { bg = c.diff.delete }, -- diff mode: Deleted line |diff.txt|
		DiffText                    = { bg = c.diff.text }, -- diff mode: Changed text within a changed line |diff.txt|
		EndOfBuffer                 = { fg = c.bg_d }, -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
		ErrorMsg                    = { fg = c.red, bold = true }, -- error messages on the command line
		VertSplit                   = { fg = c.bg3 }, -- the column separating vertically split windows
		WinSeparator                = { fg = c.bg3 }, -- the column separating vertically split windows
		Folded                      = { fg = c.fg }, -- line used for closed folds
		FoldColumn                  = { fg = c.UNKNOWN }, -- 'foldcolumn'
		SignColumn                  = { fg = c.UNKNOWN }, -- column where |signs| are displayed
		SignColumnSB                = { fg = c.UNKNOWN }, -- column where |signs| are displayed
		Substitute                  = { fg = c.bg0, bg = c.green }, -- |:substitute| replacement text highlighting
		LineNr                      = { fg = c.light_gray, bold = true }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
		CursorLineNr                = { fg = c.light_gray, bold = true }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
		LineNrAbove                 = { fg = c.gray },
		LineNrBelow                 = { fg = c.gray },
		MatchParen                  = { bg = c.gray, bold = true }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
		ModeMsg                     = { fg = c.light_gray, bold = true }, -- 'showmode' message (e.g., "-- INSERT -- ")
		MsgArea                     = { fg = c.fg }, -- Area for messages and cmdline
		MoreMsg                     = { fg = c.UNKNOWN }, -- |more-prompt|
		NonText                     = { fg = c.light_gray }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
		Normal                      = { fg = c.fg, bg = c.none }, -- normal text
		NormalNC                    = { fg = c.fg, bg = c.none }, -- normal text in non-current windows
		NormalSB                    = { fg = c.fg, bg = c.none }, -- normal text in sidebar
		NormalFloat                 = { fg = c.fg, bg = c.none }, -- Normal text in floating windows.
		FloatBorder                 = { fg = c.gray, bg = c.none },
		FloatTitle                  = { fg = c.cyan, bg = c.none },
		Pmenu                       = { fg = c.fg, bg = c.bg1 }, -- Popup menu: normal item.
		PmenuMatch                  = { fg = c.bg0, bg = c.blue }, -- Popup menu: Matched text in normal item.
		PmenuSel                    = { bg = c.bg2 }, -- Popup menu: selected item.
		PmenuSbar                   = { bg = c.bg1 }, -- Popup menu: scrollbar.
		PmenuThumb                  = { bg = c.gray }, -- Popup menu: Thumb of the scrollbar.
		Question                    = { fg = c.yellow }, -- |hit-enter| prompt and yes/no questions
		QuickFixLine                = { bg = c.UNKNOWN, bold = true }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
		Search                      = { fg = c.bg0, bg = c.yellow }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
		IncSearch                   = { fg = c.bg0, bg = c.orange }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
		CurSearch                   =  "IncSearch",
		SpecialKey                  = { fg = c.gray }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace|
		SpellBad                    = { sp = c.red, undercurl = true }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
		SpellCap                    = { sp = c.yellow, undercurl = true }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
		SpellLocal                  = { sp = c.blue, undercurl = true }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
		SpellRare                   = { sp = c.purple, undercurl = true }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
		StatusLine                  = { fg = c.fg, bg = c.bg2 }, -- status line of current window
		StatusLineNC                = { fg = c.gray, bg = c.bg1 }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
		TabLine                     = { fg = c.fg, bg = c.bg1 }, -- tab pages line, not active tab page label
		TabLineFill                 = { fg = c.gray, bg = c.bg1 }, -- tab pages line, where there are no labels
		TabLineSel                  = { fg = c.bg0, bg = c.fg }, -- tab pages line, active tab page label
		Title                       = { fg = c.cyan, bold = true }, -- titles for output from ":set all", ":autocmd" etc.
		Visual                      = { bg = c.bg2 }, -- Visual mode selection
		VisualNOS                   = { fg = c.none, bg = c.bg2, undercurl = true }, -- Visual mode selection when vim is "Not Owning the Selection".
		WarningMsg                  = { fg = c.yellow, bold = true }, -- warning messages
		Whitespace                  = { fg = c.gray }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
		WildMenu                    = { fg = c.bg0, bg = c.blue }, -- current match in 'wildmenu' completion
		WinBar                      = "StatusLine" , -- window bar
		WinBarNC                    = "StatusLineNC", -- window bar in inactive windows

		Comment                     = { fg = c.gray, }, -- any comment
		Constant                    = { fg = c.cyan }, -- (preferred) any constant
		String                      = { fg = c.green }, --   a string constant: "this is a string"
		Character                   = { fg = c.green }, -- a character constant: 'c', '\n'
		Number                      = { fg = c.orange }, -- a number constant: 234, 0xff
		Boolean                     = { fg = c.orange }, -- a boolean constant: TRUE, false
		Float                       = { fg = c.orange }, -- a floating point constant: 2.3e10
		Identifier                  = { fg = c.red }, -- (preferred) any variable name
		Function                    = { fg = c.blue }, -- function name (also: methods for classes)
		Statement                   = { fg = c.purple }, -- (preferred) any statement
		Conditional                 = { fg = c.purple }, -- if, then, else, endif, switch, etc.
		Repeat                      = { fg = c.purple }, -- for, do, while, etc.
		Label                       = { fg = c.purple }, -- case, default, etc.
		Operator                    = { fg = c.purple }, -- "sizeof", "+", "*", etc.
		Keyword                     = { fg = c.purple }, -- any other keyword
		Exception                   = { fg = c.purple }, -- try, catch, throw
		PreProc                     = { fg = c.yellow }, -- (preferred) generic Preprocessor
		Include                     = { fg = c.purple }, -- preprocessor #include
		Define                      = { fg = c.blue }, -- preprocessor #define
		Macro                       = "Define",
		PreCondit                   = { fg = c.yellow }, -- preprocessor #if, #else, #endif, etc.
		Type                        = { fg = c.yellow }, -- (preferred) int, long, char, etc.
		StorageClass                = { fg = c.yellow }, -- static, register, volatile, etc.
		Structure                   = { fg = c.yellow }, -- struct, union, enum, etc.
		Typedef                     = { fg = c.yellow }, -- A typedef
		Special                     = { fg = c.purple }, -- (preferred) any special symbol
		SpecialChar                 = { fg = c.orange }, -- special character in a constant
		Tag                         = { fg = c.UKNOWN }, -- ?
		Delimiter                   = "Special", -- character that needs attention
		SpecialComment              = { fg = c.gray, italic = true }, -- any comment
		Debug                       = { fg = c.yellow }, -- debugging statements

		Underlined                  = { fg = c.fg, underline = true }, -- (preferred) text that stands out, HTML links
		Bold                        = { fg = c.fg, bold = true }, -- (preferred) any bold text
		Italic                      = { fg = c.fg, italic = true }, -- (preferred) any italic text
		Error                       = { fg = c.purple }, -- (preferred) any erroneous construct
		Todo                        = { fg = c.blue }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX

		debugBreakpoint             = { fg = c.yellow }, -- used for breakpoint colors in terminal-debug
		debugPC                     = { fg = c.bg0, bg = c.green }, -- used for highlighting the current line in terminal-debug
		dosIniLabel                 = "@property",
		helpCommand                 = { fg = c.blue },
		htmlH1                      = { fg = c.UNKNOWN, bold = true },
		htmlH2                      = { fg = c.UNKNOWN, bold = true },
		qfFileName                  = { fg = c.UNKNOWN },
		qfLineNr                    = { fg = c.UNKNOWN },

		-- These groups are for the native LSP client. Some other LSP clients may use these groups, or use their own.
		LspReferenceText            = { bg = c.bg2 }, -- used for highlighting "text" references
		LspReferenceRead            = { bg = c.bg2 }, -- used for highlighting "read" references
		LspReferenceWrite           = { bg = c.bg2 }, -- used for highlighting "write" references
		LspSignatureActiveParameter = { bold = true },
		LspCodeLens                 = { fg = c.gray },
		LspInlayHint                = { fg = c.UNKNOWN },
		LspInfoBorder               = { fg = c.UNKNOWN, bg = c.dark_yellow },

		-- diagnostics
		DiagnosticOk                = { fg = c.success_green }, -- in checkhealth
		DiagnosticError             = { fg = c.red }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
		DiagnosticWarn              = { fg = c.yellow }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
		DiagnosticInfo              = { fg = c.cyan }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
		DiagnosticHint              = { fg = c.purple }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
		DiagnosticVirtualTextError  = { fg = c.dark_red }, -- Used for "Error" diagnostic virtual text
		DiagnosticVirtualTextWarn   = { fg = c.dark_yellow }, -- Used for "Warning" diagnostic virtual text
		DiagnosticVirtualTextInfo   = { fg = c.dark_cyan }, -- Used for "Information" diagnostic virtual text
		DiagnosticVirtualTextHint   = { fg = c.dark_purple }, -- Used for "Hint" diagnostic virtual text
		DiagnosticUnderlineError    = { sp = c.dark_red, undercurl = true }, -- Used to underline "Error" diagnostics
		DiagnosticUnderlineWarn     = { sp = c.dark_yellow, undercurl = true }, -- Used to underline "Warning" diagnostics
		DiagnosticUnderlineInfo     = { sp = c.dark_cyan, undercurl = true }, -- Used to underline "Information" diagnostics
		DiagnosticUnderlineHint     = { sp = c.dark_purple, undercurl = true }, -- Used to underline "Hint" diagnostics

		-- Health
		healthError                 = { fg = c.red },
		healthSuccess               = { fg = c.success_green },
		healthWarning               = { fg = c.yellow },
		helpExample                 = { fg = c.light_gray },

		-- diff (not needed anymore?)
		diffAdded                   = { fg = c.green },
		diffRemoved                 = { fg = c.red },
		diffChanged                 = { fg = c.blue },
		diffOldFile                 = { fg = c.yellow },
		diffNewFile                 = { fg = c.orange },
		diffFile                    = { fg = c.blue },
		diffLine                    = { fg = c.gray },
		diffIndexLine               = { fg = c.purple },
	}
end

return M
