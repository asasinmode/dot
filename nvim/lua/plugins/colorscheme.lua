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
			require('onedark').setup(opts)
			require('onedark').load()
		end
	},
}
