return {
	{ "nvim-lua/plenary.nvim", lazy = true },
	{ "tpope/vim-sleuth", event = "VeryLazy" },
	{ "tpope/vim-repeat", event = "VeryLazy" },
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
		keys = {
			{ "<leader>gs", "<cmd>Git<CR>", desc = "fugitive" },
		},
	},
}
