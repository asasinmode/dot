local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	-- bootstrap lazy.nvim
	-- stylua: ignore
	vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("core.options")
require("core.autocmds")
require("core.keymaps")
require("core.colorscheme")

require("lazy").setup({
	spec = {
		{ import = "plugins" },
		-- {
		-- 	"navarasu/onedark.nvim",
		-- 	opts = {
		-- 		style = "deep",
		-- 		transparent = true,
		-- 		code_style = {
		-- 			comments = "none",
		-- 		},
		-- 		lualine = {
		-- 			transparent = true,
		-- 		},
		-- 		diagnostics = {
		-- 			background = false,
		-- 		},
		-- 	},
		-- 	config = function(_, opts)
		-- 		require("onedark").setup(opts)
		-- 		require("onedark").load()
		-- 	end,
		-- },
	},
	defaults = {
		lazy = false,
		-- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
		-- have outdated releases, which may break your Neovim install.
		version = false, -- always use the latest git commit
	},
	rocks = {
		enabled = false,
	},
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
