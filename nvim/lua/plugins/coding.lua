local Util = require("util")

return {
	---@diagnostic disable: missing-fields
	{
		"saghen/blink.cmp",
		version = "*",
		opts_extend = {
			"sources.completion.enabled_providers",
			"sources.default",
		},
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
				kind_icons = Util.icons.icons.kinds,
			},
			completion = {
				menu = {
					border = "rounded",
					winhighlight = "Normal:Normal,FloatBorder:SpecialComment,Search:None",
					draw = {
						---@diagnostic disable: assign-type-mismatch
						treesitter = { "lsp" },
						columns = {
							{ "kind_icon" },
							{ "label", "label_description", gap = 1 },
							{ "kind" },
						},
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = {
						border = "rounded",
						winhighlight = "Normal:Normal,FloatBorder:SpecialComment,BlinkCmpDocSeparator:SpecialComment,Search:None",
					},
				},
				trigger = {
					show_on_blocked_trigger_characters = { "," },
					show_on_x_blocked_trigger_characters = { "'", '"', "(", "{", "[", "," },
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				cmdline = {},
			},
			keymap = {
				preset = "enter",
				["<C-d>"] = { "scroll_documentation_down", "fallback" },
				["<C-u>"] = { "scroll_documentation_up", "fallback" },
			},
			enabled = function()
				return not vim.tbl_contains({ "DressingInput" }, vim.bo.filetype)
					and vim.bo.buftype ~= "prompt"
					and vim.b.completion ~= false
			end,
		},
	},

	{
		"saghen/blink.cmp",
		opts = {
			sources = {
				default = { "lazydev" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
		},
	},

	-- auto pairs
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		opts = {},
	},

	-- surround
	{
		"echasnovski/mini.surround",
		opts = {
			mappings = {
				add = "msa", -- Add surrounding in Normal and Visual modes
				delete = "msd", -- Delete surrounding
				find = "msf", -- Find surrounding (to the right)
				find_left = "msF", -- Find surrounding (to the left)
				highlight = "msh", -- Highlight surrounding
				replace = "msr", -- Replace surrounding
				update_n_lines = "",
			},
		},
	},

	-- comments
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = {
			enable_autocmd = false,
		},
	},
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		opts = {
			mappings = {
				comment = "mc",
				comment_line = "mcc",
				textobject = "mc",
				comment_visual = "mc",
			},
			options = {
				ignore_blank_line = true,
				custom_commentstring = function()
					return require("ts_context_commentstring.internal").calculate_commentstring()
						or vim.bo.commentstring
				end,
			},
		},
	},

	-- better text-objects
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter-textobjects" },
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}, {}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
				},
			}
		end,
		config = function(_, opts)
			require("mini.ai").setup(opts)
		end,
	},
}
