local Util = require("util")

return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false, -- telescope did only one release, so use HEAD for now
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			-- this doesnt work on windows for some reason, I run it manually in nvim-data/lazy/telescope-fzf-native.nvim
			build = 'cmake -S. -Bbuild -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
			config = function()
				require("telescope").load_extension("fzf")
			end,
		},
		keys = {
			{
				"<leader>sr",
				function()
					require("telescope.builtin").oldfiles({
						cwd_only = true,
					})
				end,
				desc = "search recent files",
			},
			{ "<leader>sg", Util.telescope("live_grep"), desc = "grep root dir" },
			{ "<leader>sf", Util.telescope("files"), desc = "search files" },
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "search keymaps" },
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "search help" },
			{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "search diagnostics" },
			{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "search buffer" },
			{ "<leader>sc", "<cmd>Telescope git_commits<cr>", desc = "search commits" },
			{
				"<leader>ss",
				function()
					require("telescope.builtin").lsp_document_symbols({
						symbols = require("config").get_kind_filter(),
					})
				end,
				desc = "search symbols",
			},
		},
		opts = {
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				mappings = {
					i = {
						["<C-d>"] = function(...)
							return require("telescope.actions").preview_scrolling_down(...)
						end,
						["<C-u>"] = function(...)
							return require("telescope.actions").preview_scrolling_up(...)
						end,
						["<C-q>"] = function(...)
							return require("trouble.sources.telescope").open(...)
						end,
					},
					n = {
						["<C-q>"] = function(...)
							return require("trouble.sources.telescope").open(...)
						end,
					},
				},
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--trim",
				},
			},
		},
	},

	-- easily jump to any location and enhanced f/t motions for Leap
	{
		"ggandor/flit.nvim",
		keys = function()
			local ret = {}
			for _, key in ipairs({ "f", "F", "t", "T" }) do
				ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
			end
			return ret
		end,
		opts = { labeled_modes = "nx" },
	},
	{
		"ggandor/leap.nvim",
		keys = {
			{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
			{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
			{ "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
		},
		config = function(_, opts)
			local leap = require("leap")
			for k, v in pairs(opts) do
				leap.opts[k] = v
			end
			leap.add_default_mappings(true)
			vim.keymap.del({ "x", "o" }, "x")
			vim.keymap.del({ "x", "o" }, "X")
		end,
	},

	-- references
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		opts = {
			delay = 100,
			under_cursor = false,
			large_file_cutoff = 2000,
			large_file_overrides = {
				providers = { "lsp" },
			},
		},
		config = function(_, opts)
			require("illuminate").configure(opts)

			local function map(key, dir, buffer)
				vim.keymap.set("n", key, function()
					require("illuminate")["goto_" .. dir .. "_reference"](false)
				end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
			end

			map("]]", "next")
			map("[[", "prev")

			-- also set it after loading ftplugins, since a lot overwrite [[ and ]]
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					map("]]", "next", buffer)
					map("[[", "prev", buffer)
				end,
			})
		end,
		keys = {
			{ "]]", desc = "next Reference" },
			{ "[[", desc = "prev Reference" },
		},
	},

	-- better diagnostics list and others
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		opts = { use_diagnostic_signs = true },
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "trouble document diagnostics" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>", desc = "trouble workspace diagnostics" },
			{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "trouble location list" },
			{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "trouble quickfix list" },
		},
		config = function(_, opts)
			require("trouble").setup(opts)

			vim.api.nvim_set_hl(0, "TroubleNormalNC", { blend = 0 })
			vim.api.nvim_set_hl(0, "TroubleNormal", { blend = 0 })
		end,
	},
}
