return {
	{
		"navarasu/onedark.nvim",
		opts = {
			style = "deep",
			transparent = true,
			code_style = {
				comments = "none",
			},
			lualine = {
				transparent = true,
			},
			diagnostics = {
				background = false,
			},
		},
		config = function(_, opts)
			require("onedark").setup(opts)
			require("onedark").load()
			-- TODO wip highlights, add more
			vim.api.nvim_set_hl(0, "BlinkCmpKindMethod", { link = "Function" })
			vim.api.nvim_set_hl(0, "BlinkCmpKindFunction", { link = "Function" })
		end,
	},
}
