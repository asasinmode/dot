local Util = require("util")

return {
	{
		"stevearc/conform.nvim",
		dependencies = { "mason.nvim" },
		lazy = true,
		cmd = "ConformInfo",
		init = function()
			-- Install the conform formatter on VeryLazy
			Util.on_very_lazy(function()
				Util.format.register({
					name = "conform.nvim",
					priority = 100,
					primary = true,
					format = function(buf)
						local plugin = require("lazy.core.config").plugins["conform.nvim"]
						local Plugin = require("lazy.core.plugin")
						local opts = Plugin.values(plugin, "opts", false)
						require("conform").format(Util.merge(opts.format, { bufnr = buf }))
					end,
					sources = function(buf)
						local ret = require("conform").list_formatters(buf)
						---@param v conform.FormatterInfo
						return vim.tbl_map(function(v)
							return v.name
						end, ret)
					end,
				})
			end)
		end,
		opts = {
			-- will use these options when formatting with the conform.nvim formatter
			format = {
				timeout_ms = 3000,
				async = false,
				quiet = false,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				lua = { "stylua" },
				rust = { "rustfmt", lsp_format = "fallback" },
				sql = { "sqlfluff" },
				mysql = { "sqlfluff" },
				plsql = { "sqlfluff" },
			},
			---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
			formatters = {
				injected = { options = { ignore_errors = true } },
				sqlfluff = {
					args = { "format", "--dialect", "ansi", "-" },
					require_cwd = false,
				},
			},
		},
	},
}
