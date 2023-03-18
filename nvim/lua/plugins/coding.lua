return {
	-- snippets
	{
		'L3MON4D3/LuaSnip',
		opts = {
			history = true,
			delete_check_events = 'TextChanged',
		},
		keys = {
			{
				'<tab>',
				function()
					return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<tab>'
				end,
				expr = true,
				silent = true,
				mode = 'i',
			},
			{ '<tab>',   function() require('luasnip').jump(1) end,  mode = 's' },
			{ '<s-tab>', function() require('luasnip').jump(-1) end, mode = { 'i', 's' } },
		},
	},

	-- auto completion
	{
		'hrsh7th/nvim-cmp',
		version = false, -- last release is way too old
		event = 'InsertEnter',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'saadparwaiz1/cmp_luasnip',
		},
		opts = function()
			local cmp = require('cmp')
			return {
				completion = {
					completeopt = 'menu,menuone,noinsert',
				},
				window = {
					completion = {
						border = 'rounded',
						winhighlight = "Normal:Normal,FloatBorder:SpecialComment,Search:None",
					},
					documentation = {
						border = 'rounded',
						winhighlight = "Normal:Normal,FloatBorder:Normal",
					},
				},
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-d>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace, }),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'buffer' },
					{ name = 'path' },
				}),
				formatting = {
					format = function(_, item)
						local icons = require('core.lua').icons.kinds
						if icons[item.kind] then
							item.kind = icons[item.kind] .. item.kind
						end
						return item
					end,
				},
				-- disable autocompletion in comments
				enabled = function()
					local context = require('cmp.config.context')
					if vim.api.nvim_get_mode() == 'c' then
						return true
					else
						return not context.in_treesitter_capture('comment') and not context.in_syntax_group('comment')
					end
				end,
				experimental = {
					ghost_text = {
						hl_group = 'LspCodeLens',
					},
				},
			}
		end,
	},

	-- auto pairs
	{
		'echasnovski/mini.pairs',
		event = 'VeryLazy',
		config = function(_, opts)
			require('mini.pairs').setup(opts)
		end,
	},

	-- surround
	{
		'echasnovski/mini.surround',
		opts = {
			mappings = {
				add = 'msa',        -- Add surrounding in Normal and Visual modes
				delete = 'msd',     -- Delete surrounding
				find = 'msf',       -- Find surrounding (to the right)
				find_left = 'msF',  -- Find surrounding (to the left)
				highlight = 'msh',  -- Highlight surrounding
				replace = 'msr',    -- Replace surrounding
				update_n_lines = 'msn', -- Update `n_lines`
			},
		},
		config = function(_, opts)
			require('mini.surround').setup(opts)
		end,
	},

	-- comments
	{ 'JoosepAlviste/nvim-ts-context-commentstring', lazy = true },
	{
		'echasnovski/mini.comment',
		event = 'VeryLazy',
		opts = {
			hooks = {
				pre = function()
					require('ts_context_commentstring.internal').update_commentstring({})
				end,
			},
			mappings = {
				comment = 'mc',
				comment_line = 'mcc',
				textobject = 'mc',
			},
		},
		config = function(_, opts)
			require('mini.comment').setup(opts)
		end,
	},

	-- better text-objects
	{
		'echasnovski/mini.ai',
		event = 'VeryLazy',
		dependencies = { 'nvim-treesitter-textobjects' },
		opts = function()
			local ai = require('mini.ai')
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({
						a = { '@block.outer', '@conditional.outer', '@loop.outer' },
						i = { '@block.inner', '@conditional.inner', '@loop.inner' },
					}, {}),
					f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
					c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
				},
			}
		end,
		config = function(_, opts)
			require('mini.ai').setup(opts)
		end,
	},
}
