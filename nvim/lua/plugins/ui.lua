return {

	-- file explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		keys = {
			{
				"<leader>pv",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = require("util.lua").get_root() })
				end,
				desc = "Explorer NeoTree (root dir)",
			},
			{
				"<leader>pV",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
				end,
				desc = "Explorer NeoTree (cwd)",
			},
		},
		deactivate = function()
			vim.cmd([[Neotree close]])
		end,
		init = function()
			vim.g.neo_tree_remove_legacy_commands = 1
			if vim.fn.argc() == 1 then
				local stat = vim.loop.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					require("neo-tree")
				end
			end
		end,
		opts = {
			filesystem = {
				bind_to_cwd = false,
				follow_current_file = true,
				filtered_items = {
					hide_hidden = false,
					hide_dotfiles = false,
				}
			},
			window = {
				mappings = {
					["<space>"] = "none",
				},
				width = 35
			},
			default_component_configs = {
				indent = {
					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
			},
		},
	},

	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			options = {
				theme = 'onedark',
				globalstatus = true,
				disabled_filetypes = {
					statusline = { 'dashboard', 'lazy', 'alpha', 'mason', 'Trouble', 'fugitive', 'help', 'gitcommit' } },
				component_separators = '|',
				section_separators = { left = '', right = '' },
			},
			sections = {
				lualine_a = {
					{ 'mode', separator = { left = '' }, right_padding = 1 },
				},
				lualine_b = { 'filename', 'branch' },
				lualine_c = {},
				lualine_x = {},
				lualine_y = { 'filetype' },
				lualine_z = {
					{ 'location', separator = { right = '' }, left_padding = 1 },
				},
			},
			extensions = { "neo-tree" },
		}
	},

	-- noicer ui
	{
		'folke/noice.nvim',
		event = 'VeryLazy',
		opts = {
			lsp = {
				override = {
					['vim.lsp.util.convert_input_to_markdown_lines'] = true,
					['vim.lsp.util.stylize_markdown'] = true,
					['cmp.entry.get_documentation'] = true,
				},
			},
			notify = {
				enabled = false,
			},
			messages = {
				enabled = false,
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				lsp_doc_border = true,
			},
			views = {
				hover = {
					border = {
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = {
							Normal = 'Normal',
							FloatBorder = 'Normal',
						},
					},
				},
				mini = {
					position = {
						row = -2
					},
				}
			},
		},
		keys = {
			{
				'<S-Enter>',
				function() require('noice').redirect(vim.fn.getcmdline()) end,
				mode = 'c',
				desc = 'Redirect Cmdline',
			},
			{
				'<c-d>',
				function() if not require('noice.lsp').scroll(4) then return '<c-d>' end end,
				silent = true,
				expr = true,
				desc = 'Scroll forward',
				mode = { 'i', 'n', 's' },
			},
			{
				'<c-u>',
				function() if not require('noice.lsp').scroll(-4) then return '<c-u>' end end,
				silent = true,
				expr = true,
				desc = 'Scroll backward',
				mode = { 'i', 'n', 's' },
			},
		},
	},

	{ 'nvim-tree/nvim-web-devicons', lazy = true },
	{ 'MunifTanjim/nui.nvim',        lazy = true },

	{
		'stevearc/dressing.nvim',
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require('lazy').load({ plugins = { 'dressing.nvim' } })
				return vim.ui.select(...)
			end

			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require('lazy').load({ plugins = { 'dressing.nvim' } })
				return vim.ui.input(...)
			end
		end
	},
}
