local Util = require("util.lua")

print('formatting')

local M = {}

---@param opts ConformOpts
function M.setup(_, opts)
	for name, formatter in pairs(opts.formatters or {}) do
		if type(formatter) == "table" then
			---@diagnostic disable-next-line: undefined-field
			if formatter.extra_args then
				---@diagnostic disable-next-line: undefined-field
				formatter.prepend_args = formatter.extra_args
			end
		end
	end

	for _, key in ipairs({ "format_on_save", "format_after_save" }) do
		if opts[key] then
			Util.warn(
				("Don't set `opts.%s` for `conform.nvim`.\n**Editor** will use the conform formatter automatically"):format(
					key
				)
			)
			---@diagnostic disable-next-line: no-unknown
			opts[key] = nil
		end
	end
	require("conform").setup(opts)
end

return {
	-- {
	-- 	"stevearc/conform.nvim",
	-- 	dependencies = { "mason.nvim" },
	-- 	lazy = true,
	-- 	cmd = "ConformInfo",
	-- 	init = function()
	-- 		-- Install the conform formatter on VeryLazy
	-- 		require("util.lua").on_very_lazy(function()
	-- 			require("util.lua.format").register({
	-- 				name = "conform.nvim",
	-- 				priority = 100,
	-- 				primary = true,
	-- 				format = function(buf)
	-- 					local plugin = require("lazy.core.config").plugins["conform.nvim"]
	-- 					local Plugin = require("lazy.core.plugin")
	-- 					local opts = Plugin.values(plugin, "opts", false)
	-- 					require("conform").format(Util.merge(opts.format, { bufnr = buf }))
	-- 				end,
	-- 				sources = function(buf)
	-- 					local ret = require("conform").list_formatters(buf)
	-- 					---@param v conform.FormatterInfo
	-- 					return vim.tbl_map(function(v)
	-- 						return v.name
	-- 					end, ret)
	-- 				end,
	-- 			})
	-- 		end)
	-- 	end,
	-- 	opts = function()
	-- 		local plugin = require("lazy.core.config").plugins["conform.nvim"]
	-- 		if plugin.config ~= M.setup then
	-- 			Util.error({
	-- 				"Don't set `plugin.config` for `conform.nvim`.\n",
	-- 				"This will break **LazyVim** formatting.\n",
	-- 				"Please refer to the docs at https://www.lazyvim.org/plugins/formatting",
	-- 			}, { title = "not sure when this pops up" })
	-- 		end
	-- 		---@class ConformOpts
	-- 		local opts = {
	-- 			-- will use these options when formatting with the conform.nvim formatter
	-- 			format = {
	-- 				timeout_ms = 3000,
	-- 				async = false, -- not recommended to change
	-- 				quiet = false, -- not recommended to change
	-- 			},
	-- 			---@type table<string, conform.FormatterUnit[]>
	-- 			formatters_by_ft = {
	-- 				lua = { "stylua" },
	-- 				javascript = { "eslint_d" },
	-- 				typescript = { "eslint_d" },
	-- 				vue = { "eslint_d" },
	-- 				json = { "eslint_d" },
	-- 				json5 = { "eslint_d" },
	-- 				yaml = { "eslint_d" },
	-- 				html = { "eslint_d" },
	-- 				markdown = { "eslint_d" },
	-- 			},
	-- 			-- The options you set here will be merged with the builtin formatters.
	-- 			-- You can also define any custom formatters here.
	-- 			---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
	-- 			formatters = {
	-- 				injected = { options = { ignore_errors = true } },
	-- 				eslint_d = {
	-- 					condition = function(ctx)
	-- 						return vim.fs.find(
	-- 							{ "eslint.config.js", ".eslintrc.json" },
	-- 							{ path = ctx.filename, upward = true }
	-- 						)[1]
	-- 					end,
	-- 				},
	-- 			},
	-- 		}
	-- 		return opts
	-- 	end,
	-- 	config = M.setup,
	-- },
}
