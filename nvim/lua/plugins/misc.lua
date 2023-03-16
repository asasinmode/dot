return {
	{ 'nvim-lua/plenary.nvim', lazy = true },
	{ 'tpope/vim-fugitive',    event = 'VeryLazy' },
	{ 'tpope/vim-sleuth',      event = 'VeryLazy' },
	{ 'tpope/vim-repeat',      event = 'VeryLazy' },
	{
		'dstein64/vim-startuptime',
		cmd = 'StartupTime',
		config = function()
			vim.g.startuptime_tries = 10
		end,
	},
}
