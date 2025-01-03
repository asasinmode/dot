local Util = require("util")

local M = {}

---@param opts conform.setupOpts
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
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				vue = { "eslint_d" },
				json = { "eslint_d" },
				jsonc = { "eslint_d" },
				yaml = { "eslint_d" },
				html = { "eslint_d" },
				markdown = { "eslint_d" },
				css = { "eslint_d" },
				rust = { "rustfmt", lsp_format = "fallback" },
			},
			-- The options you set here will be merged with the builtin formatters.
			-- You can also define any custom formatters here.
        	---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
			formatters = {
				injected = { options = { ignore_errors = true } },
				eslint_d = {
					condition = function(self, ctx)
						return vim.fs.find(
							{ "eslint.config.js", "eslint.config.mjs", ".eslintrc.json" },
							{ path = ctx.filename, upward = true }
						)[1]
					end,
				},
			},
		},
		config = M.setup,
	},
}
