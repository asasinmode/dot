local Util = require("util.lua")

---@class Config: Options
local M = {}

---@class Options
local defaults = {
	defaults = {
		autocmds = true, -- lazyvim.config.autocmds
		keymaps = true, -- lazyvim.config.keymaps
	},
  -- icons used by other plugins
  -- stylua: ignore
  icons = {
    misc = {
      dots = "󰇘",
    },
    dap = {
      Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
      Breakpoint          = " ",
      BreakpointCondition = " ",
      BreakpointRejected  = { " ", "DiagnosticError" },
      LogPoint            = ".>",
    },
    diagnostics = {
      Error = " ",
      Warn  = " ",
      Hint  = " ",
      Info  = " ",
    },
    git = {
      added    = " ",
      modified = " ",
      removed  = " ",
    },
    kinds = {
      Array         = " ",
      Boolean       = "󰨙 ",
      Class         = " ",
      Codeium       = "󰘦 ",
      Color         = " ",
      Control       = " ",
      Collapsed     = " ",
      Constant      = "󰏿 ",
      Constructor   = " ",
      Copilot       = " ",
      Enum          = " ",
      EnumMember    = " ",
      Event         = " ",
      Field         = " ",
      File          = " ",
      Folder        = " ",
      Function      = "󰊕 ",
      Interface     = " ",
      Key           = " ",
      Keyword       = " ",
      Method        = "󰊕 ",
      Module        = " ",
      Namespace     = "󰦮 ",
      Null          = " ",
      Number        = "󰎠 ",
      Object        = " ",
      Operator      = " ",
      Package       = " ",
      Property      = " ",
      Reference     = " ",
      Snippet       = " ",
      String        = " ",
      Struct        = "󰆼 ",
      TabNine       = "󰏚 ",
      Text          = " ",
      TypeParameter = " ",
      Unit          = " ",
      Value         = " ",
      Variable      = "󰀫 ",
    },
  },
	---@type table<string, string[]|boolean>?
	kind_filter = {
		default = {
			"Class",
			"Constructor",
			"Enum",
			"Field",
			"Function",
			"Interface",
			"Method",
			"Module",
			"Namespace",
			"Package",
			"Property",
			"Struct",
			"Trait",
		},
		markdown = false,
		help = false,
		-- you can specify a different filter for each filetype
		lua = {
			"Class",
			"Constructor",
			"Enum",
			"Field",
			"Function",
			"Interface",
			"Method",
			"Module",
			"Namespace",
			-- "Package", -- remove package since luals uses it for control flow structures
			"Property",
			"Struct",
			"Trait",
		},
	},
}

---@type Options
local options

---@param opts? Options
function M.setup(opts)
	options = vim.tbl_deep_extend("force", defaults, opts or {}) or {}

	-- autocmds can be loaded lazily when not opening a file
	local lazy_autocmds = vim.fn.argc(-1) == 0
	if not lazy_autocmds then
		M.load("autocmds")
	end

	local group = vim.api.nvim_create_augroup("asasinmode", { clear = true })
	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "VeryLazy",
		callback = function()
			if lazy_autocmds then
				M.load("autocmds")
			end
			M.load("keymaps")

			Util.format.setup()
			Util.root.setup()
		end,
	})

	Util.try(function()
		require("navarasu/onedark.nvim").load()
	end, {
		msg = "Could not load colorscheme",
		on_error = function(msg)
			Util.error(msg)
		end,
	})
end

---@param buf? number
---@return string[]?
function M.get_kind_filter(buf)
	buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
	local ft = vim.bo[buf].filetype
	if M.kind_filter == false then
		return
	end
	if M.kind_filter[ft] == false then
		return
	end
	---@diagnostic disable-next-line: return-type-mismatch
	return type(M.kind_filter) == "table" and type(M.kind_filter.default) == "table" and M.kind_filter.default or nil
end

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
	local function _load(mod)
		if require("lazy.core.cache").find(mod)[1] then
			Util.try(function()
				require(mod)
			end, { msg = "Failed loading " .. mod })
		end
	end
	-- always load lazyvim, then user file
	if M.defaults[name] or name == "options" then
		_load("config." .. name)
	end
	_load("config." .. name)
	if vim.bo.filetype == "lazy" then
		-- HACK: may have overwritten options of the Lazy ui, so reset this here
		vim.cmd([[do VimResized]])
	end
	local pattern = "asasinmode" .. name:sub(1, 1):upper() .. name:sub(2)
	vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end

M.did_init = false
function M.init()
	if M.did_init then
		return
	end
	M.did_init = true

	-- load options here, before lazy init while sourcing plugin modules
	-- this is needed to make sure options will be correctly applied
	-- after installing missing plugins
	M.load("options")
end

setmetatable(M, {
	__index = function(_, key)
		if options == nil then
			return vim.deepcopy(defaults)[key]
		end
		---@cast options Config
		return options[key]
	end,
})

return M
