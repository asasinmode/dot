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
		enabled = false,
		opts = function()
			local lombok_jar = vim.fn.expand("$MASON/share/jdtls/lombok.jar")
			return {
				-- How to find the root dir for a given filename. The default comes from
				-- lspconfig which provides a function specifically for java projects.
				root_dir = Util.lsp.get_raw_config("jdtls").default_config.root_dir,

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
				cmd = {
					vim.fn.exepath("jdtls"),
					string.format("--jvm-arg=-javaagent:%s", lombok_jar),
				},
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

				-- These depend on nvim-dap, but can additionally be disabled by setting false here.
				dap = { hotcodereplace = "auto", config_overrides = {} },
				dap_main = {},
				test = true,
				settings = {
					java = {
						inlayHints = {
							parameterNames = {
								enabled = "all",
							},
						},
					},
				},
			}
		end,
		config = function(_, opts)
			-- Find the extra bundles that should be passed on the jdtls command-line
			-- if nvim-dap is enabled with java debug/test.
			local mason_registry = require("mason-registry")
			local bundles = {} ---@type string[]
			if opts.dap and Util.has("nvim-dap") and mason_registry.is_installed("java-debug-adapter") then
				local jar_patterns = {
					vim.fn.expand("$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar"),
				}
				-- java-test also depends on java-debug-adapter.
				if opts.test and mason_registry.is_installed("java-test") then
					vim.list_extend(jar_patterns, {
						vim.fn.expand("$MASON/share/java-test/*.jar"),
					})
				end
				for _, jar_pattern in ipairs(jar_patterns) do
					for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
						table.insert(bundles, bundle)
					end
				end
			end

			local function attach_jdtls()
				local fname = vim.api.nvim_buf_get_name(0)

				-- Configuration can be augmented and overridden by opts.jdtls
				local config = extend_or_override({
					cmd = opts.full_cmd(opts),
					root_dir = opts.root_dir(fname),
					init_options = {
						bundles = bundles,
					},
					settings = opts.settings,
					-- enable CMP capabilities
					capabilities = Util.has("blink.cmp") and require("blink.cmp").get_lsp_capabilities() or nil,
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
