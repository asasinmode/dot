return {
	{
		"nvim-treesitter/nvim-treesitter",
		main = "nvim-treesitter",
		event = { "VeryLazy", "BufReadPost", "BufNewFile", "BufWritePre" },
		build = ":TSUpdate",
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		config = function()
			require("nvim-treesitter.install").compilers = { "gcc" }
			require("nvim-treesitter").setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
			require("nvim-treesitter").install({
				"css",
				"diff",
				"html",
				"javascript",
				"json",
				"json5",
				"lua",
				"luap",
				"markdown",
				"markdown_inline",
				"query",
				"regex",
				"sql",
				"typescript",
				"vim",
				"vimdoc",
				"vue",
				"yaml",
				"astro",
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		event = "VeryLazy",
		-- config = function(_, opts)
		-- 	local TS = require("nvim-treesitter-textobjects")
		-- 	TS.setup(opts)
		-- end,
	},
}
