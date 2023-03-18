-- Almost a one to one copy of https://github.dev/LazyVim/LazyVim/blob/main/lua/lazyvim/config/init.lua
local M = {}

M.lazy_version = ">=9.1.0"

M.icons = {
	diagnostics = {
		Error = " ",
		Warn = " ",
		Hint = " ",
		Info = " ",
	},
	kinds = {
		Array = " ",
		Boolean = " ",
		Class = " ",
		Color = " ",
		Constant = " ",
		Constructor = " ",
		Copilot = " ",
		Enum = " ",
		EnumMember = " ",
		Event = " ",
		Field = " ",
		File = " ",
		Folder = " ",
		Function = " ",
		Interface = " ",
		Key = " ",
		Keyword = " ",
		Method = " ",
		Module = " ",
		Namespace = " ",
		Null = "ﳠ ",
		Number = " ",
		Object = " ",
		Operator = " ",
		Package = " ",
		Property = " ",
		Reference = " ",
		Snippet = " ",
		String = " ",
		Struct = " ",
		Text = " ",
		TypeParameter = " ",
		Unit = " ",
		Value = " ",
		Variable = " ",
	},
}

function M.setup()
	if not M.has() then
		require("lazy.core.util").error(
			"**this config** needs **lazy.nvim** version "
				.. M.lazy_version
				.. " to work properly.\n"
				.. "Please upgrade **lazy.nvim**",
			{ title = "asasinmode" }
		)
		error("Exiting")
	end

	if vim.fn.argc(-1) == 0 then
		-- autocmds and keymaps can wait to load
		vim.api.nvim_create_autocmd("User", {
			group = vim.api.nvim_create_augroup("asasinmode", { clear = true }),
			pattern = "VeryLazy",
			callback = function()
				M.load("autocmds")
				M.load("keymaps")
			end,
		})
	else
		-- load them now so they affect the opened buffers
		M.load("autocmds")
		M.load("keymaps")
	end

	require("lazy.core.util").try(function()
		require("onedark").load()
	end, {
		msg = "Could not load colorscheme",
		on_error = function(msg)
			require("lazy.core.util").error(msg)
			vim.cmd.colorscheme("default")
		end,
	})
end

---@param range? string
function M.has(range)
	local Semver = require("lazy.manage.semver")
	return Semver.range(range or M.lazy_version):matches(require("lazy.core.config").version or "0.0.0")
end

---@param name 'autocmds' | 'options' | 'keymaps'
function M.load(name)
	local Util = require("lazy.core.util")
	local mod = "config." .. name

	Util.try(function()
		require(mod)
	end, {
		msg = "Failed loading " .. mod,
		on_error = function(msg)
			local modpath = require("lazy.core.cache").find(mod)
			if modpath then
				Util.error(msg)
			end
		end,
	})
end

M.did_init = false
function M.init()
	if not M.did_init then
		M.did_init = true
		M.load("options")
	end
end

return M
