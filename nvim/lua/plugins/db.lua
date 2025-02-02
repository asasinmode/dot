local Util = require("util")

-- check https://github.com/kndndrj/nvim-dbee
-- filter out db_ui from telescope recent
return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
			{
				"saghen/blink.cmp",
				opts = {
					sources = {
						default = { "dadbod" },
						providers = {
							dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
						},
					},
				},
			},
		},
		keys = {
			{
				"<leader>pd",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = Util.root.get() })
					vim.cmd("DBUIToggle")
				end,
				desc = "toggle dadbod ui",
			},
		},
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		init = function()
			vim.g.db_ui_winwidth = 31
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
			vim.g.db_ui_tmp_query_location = vim.fn.stdpath("data") .. "/db_ui/tmp"
			vim.g.db_ui_execute_on_save = false
		end,
	},
}
