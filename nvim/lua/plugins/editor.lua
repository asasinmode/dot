local Util = require("util.lua")

return {
	{
		'nvim-telescope/telescope.nvim',
		cmd = 'Telescope',
		version = false, -- telescope did only one release, so use HEAD for now
		dependencies = {
			'natecraddock/telescope-zf-native.nvim',
			config = function()
				require('telescope').load_extension('zf-native')
			end,
		},
		keys = {
			{ '<leader>sr', '<cmd>Telescope oldfiles<cr>',                  desc = '[S]earch [R]ecent files' },
			{ '<leader>sg', Util.telescope('live_grep'),                    desc = '[S]earch [G]rep word' },
			{ '<leader>sw', Util.telescope('grep_string'),                  desc = '[S]earch current [W]ord' },
			{ '<leader>sf', Util.telescope('files'),                        desc = '[S]earch [F]iles' },
			{ '<leader>sk', '<cmd>Telescope keymaps<cr>',                   desc = '[S]earch [K]eymaps' },
			{ '<leader>sh', '<cmd>Telescope help_tags<cr>',                 desc = '[S]earch [H]elp' },
			{ '<leader>sd', '<cmd>Telescope diagnostics<cr>',               desc = '[S]earch [D]iagnostics' },
			{ '<leader>sb', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = '[S]earch [B]uffer' },
			{ '<leader>gc', '<cmd>Telescope git_commits<cr>',               desc = 'Telescope [G]it [C]ommits' },
		},
		opts = {
			defaults = {
				prompt_prefix = ' ',
				selection_caret = ' ',
				mappings = {
					i = {
						['<C-d>'] = function(...)
							return require('telescope.actions').preview_scrolling_down(...)
						end,
						['<C-u>'] = function(...)
							return require('telescope.actions').preview_scrolling_up(...)
						end,
					},
				},
				vimgrep_arguments = {
					'rg',
					'--color=never',
					'--no-heading',
					'--with-filename',
					'--line-number',
					'--column',
					'--smart-case',
					'--hidden',
				}
			},
		},
	},

	-- easily jump to any location and enhanced f/t motions for Leap
	{
		'ggandor/flit.nvim',
		keys = function()
			local ret = {}
			for _, key in ipairs({ 'f', 'F', 't', 'T' }) do
				ret[#ret + 1] = { key, mode = { 'n', 'x', 'o' }, desc = key }
			end
			return ret
		end,
		opts = { labeled_modes = 'nx' },
	},
	{
		'ggandor/leap.nvim',
		keys = {
			{ 's',  mode = { 'n', 'x', 'o' }, desc = 'Leap forward to' },
			{ 'S',  mode = { 'n', 'x', 'o' }, desc = 'Leap backward to' },
			{ 'gs', mode = { 'n', 'x', 'o' }, desc = 'Leap from windows' },
		},
		config = function(_, opts)
			local leap = require('leap')
			for k, v in pairs(opts) do
				leap.opts[k] = v
			end
			leap.add_default_mappings(true)
			vim.keymap.del({ 'x', 'o' }, 'x')
			vim.keymap.del({ 'x', 'o' }, 'X')
		end,
	},

	-- references
	{
		'RRethy/vim-illuminate',
		event = { 'BufReadPost', 'BufNewFile' },
		opts = { delay = 100, under_cursor = false },
		config = function(_, opts)
			require('illuminate').configure(opts)

			local function map(key, dir, buffer)
				vim.keymap.set('n', key, function()
					require('illuminate')['goto_' .. dir .. '_reference'](false)
				end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference', buffer = buffer })
			end

			map(']]', 'next')
			map('[[', 'prev')

			-- also set it after loading ftplugins, since a lot overwrite [[ and ]]
			vim.api.nvim_create_autocmd('FileType', {
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					map(']]', 'next', buffer)
					map('[[', 'prev', buffer)
				end,
			})
		end,
		keys = {
			{ ']]', desc = 'Next Reference' },
			{ '[[', desc = 'Prev Reference' },
		},
	},

	-- better diagnostics list and others
	{
		'folke/trouble.nvim',
		cmd = { 'TroubleToggle', 'Trouble' },
		opts = { use_diagnostic_signs = true },
		keys = {
			{ '<leader>xx', '<cmd>TroubleToggle document_diagnostics<cr>',  desc = 'Document Diagnostics (Trouble)' },
			{ '<leader>xX', '<cmd>TroubleToggle workspace_diagnostics<cr>', desc = 'Workspace Diagnostics (Trouble)' },
			{ '<leader>xL', '<cmd>TroubleToggle loclist<cr>',               desc = 'Location List (Trouble)' },
			{ '<leader>xQ', '<cmd>TroubleToggle quickfix<cr>',              desc = 'Quickfix List (Trouble)' },
			{
				'[q',
				function()
					if require('trouble').is_open() then
						require('trouble').previous({ skip_groups = true, jump = true })
					else
						vim.cmd.cprev()
					end
				end,
				desc = 'Previous trouble/quickfix item',
			},
			{
				']q',
				function()
					if require('trouble').is_open() then
						require('trouble').next({ skip_groups = true, jump = true })
					else
						vim.cmd.cnext()
					end
				end,
				desc = 'Next trouble/quickfix item',
			},
		},
	},
}
