local Util = require("util")

-- This is the same as in lspconfig.server_configurations.jdtls, but avoids
-- needing to require that when this module loads.
local java_filetypes = { "java" }

-- Utility function to extend or override a config table, similar to the way
-- that Plugin.opts works.
---@param config table
---@param custom function | table | nil
local function extend_or_override(config, custom, ...)
	if type(custom) == "function" then
		config = custom(config, ...) or config
	elseif custom then
		config = vim.tbl_deep_extend("force", config, custom) --[[@as table]]
	end
	return config
end

return {
	{
		"mfussenegger/nvim-jdtls",
		ft = java_filetypes,
		opts = function()
			return {
				-- How to find the root dir for a given filename. The default comes from
				-- lspconfig which provides a function specifically for java projects.
				root_dir = require("lspconfig.server_configurations.jdtls").default_config.root_dir,

				-- How to find the project name for a given root dir.
				project_name = function(root_dir)
					return root_dir and vim.fs.basename(root_dir)
				end,

				-- Where are the config and workspace dirs for a project?
				jdtls_config_dir = function(project_name)
					return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
				end,
				jdtls_workspace_dir = function(project_name)
					return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
				end,

				-- How to run jdtls. This can be overridden to a full java command-line
				-- if the Python wrapper script doesn't suffice.
				cmd = { vim.fn.exepath("jdtls") },
				full_cmd = function(opts)
					local fname = vim.api.nvim_buf_get_name(0)
					local root_dir = opts.root_dir(fname)
					local project_name = opts.project_name(root_dir)

					local cmd = vim.deepcopy(opts.cmd)
					if project_name then
						vim.list_extend(cmd, {
							"-configuration",
							opts.jdtls_config_dir(project_name),
							"-data",
							opts.jdtls_workspace_dir(project_name),
						})
					end

					return cmd
				end,
				settings = {
					java = {
						configuration = {
							runtimes = {
								{
									name = "JavaSE-17",
									path = "C:\\Program Files\\Eclipse Adoptium\\jdk-17.0.10.7-hotspot",
								},
								{
									name = "JavaSE-17",
									path = "C:\\Program Files\\Eclipse Adoptium\\jdk-21.0.3.9-hotspot",
									default = true,
								},
							},
						},
					},
				},
			}
		end,
		config = function()
			local opts = Util.opts("nvim-jdtls") or {}

			local function attach_jdtls()
				local fname = vim.api.nvim_buf_get_name(0)

				-- Configuration can be augmented and overridden by opts.jdtls
				local config = extend_or_override({
					cmd = opts.full_cmd(opts),
					root_dir = opts.root_dir(fname),
					init_options = {
						bundles = {},
					},
					-- enable CMP capabilities
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
				}, opts.jdtls)

				-- Existing server will be reused if the root_dir matches.
				require("jdtls").start_or_attach(config)
				-- not need to require("jdtls.setup").add_commands(), start automatically adds commands
			end

			-- Attach the jdtls for each java buffer. HOWEVER, this plugin loads
			-- depending on filetype, so this autocmd doesn't run for the first file.
			-- For that, we call directly below.
			vim.api.nvim_create_autocmd("FileType", {
				pattern = java_filetypes,
				callback = attach_jdtls,
			})

			-- Setup keymap and dap after the lsp is fully attached.
			-- https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
			-- https://neovim.io/doc/user/lsp.html#LspAttach
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "jdtls" then
						-- stylua: ignore start
						vim.keymap.set("n", "<leader>cxv", require("jdtls").extract_variable_all, { desc = "extract variable", buffer = args.buf })
						vim.keymap.set("n", "<leader>cxc", require("jdtls").extract_constant, { desc = "extract constant", buffer = args.buf })
						vim.keymap.set("n", "gl", require("jdtls").super_implementation, { desc = "go to super", buffer = args.buf })
						vim.keymap.set("n", "<leader>co", require("jdtls").organize_imports, { desc = "organize imports", buffer = args.buf })

						vim.keymap.set("v", "<leader>cxm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], { desc = "extract method", buffer = args.buf })
						vim.keymap.set("v", "<leader>cxv", [[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]], { desc = "extract method", buffer = args.buf })
						vim.keymap.set("v", "<leader>cxc", [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]], { desc = "extract method", buffer = args.buf })
						-- stylua: ignore end
					end
				end,
			})

			-- Avoid race condition by calling attach the first time, since the autocmd won't fire.
			attach_jdtls()
		end,
	},
}
