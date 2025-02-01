local Util = require("util")

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		dependencies = {
			{ "b0o/SchemaStore.nvim", lazy = true, version = false },
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp",
		},
		---@class PluginLspOpts
		opts = {
			-- options for vim.diagnostic.config()
			---@type vim.diagnostic.Opts
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = { spacing = 4, prefix = "●" },
				severity_sort = true,
				float = {
					border = "rounded",
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = Util.icons.icons.diagnostics.Error,
						[vim.diagnostic.severity.WARN] = Util.icons.icons.diagnostics.Warn,
						[vim.diagnostic.severity.HINT] = Util.icons.icons.diagnostics.Hint,
						[vim.diagnostic.severity.INFO] = Util.icons.icons.diagnostics.Info,
					},
				},
			},
			capabilities = {
				workspace = {
					fileOperations = {
						didRename = true,
						willRename = true,
					},
				},
			},
			-- options for vim.lsp.buf.format
			-- `bufnr` and `filter` is handled by the formatter,
			-- but can be also overridden when specified
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				jsonls = {
					on_new_config = function(new_config)
						new_config.settings.json.schemas = new_config.settings.json.schemas or {}
						vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
					end,
					settings = {
						json = {
							format = { enable = true },
							validate = { enable = true },
						},
					},
				},
				cssls = {},
				html = {},
				ts_ls = {
					init_options = {
						plugins = {
							{
								name = "@vue/typescript-plugin",
								location = vim.fn.expand(
									"~/AppData/Local/fnm_multishells/2876_1738416076326/node_modules/@vue/typescript-plugin"
								),
								languages = { "javascript", "typescript", "vue" },
							},
						},
					},
					filetypes = {
						"javascript",
						"typescript",
						"vue",
					},
				},
				volar = {},
				jdtls = {},
				yamlls = {
					on_new_config = function(new_config)
						new_config.settings.yaml.schemas = vim.tbl_deep_extend(
							"force",
							new_config.settings.yaml.schemas or {},
							require("schemastore").yaml.schemas()
						)
					end,
					settings = {
						redhat = { telemetry = { enabled = false } },
						yaml = {
							keyOrdering = false,
							format = {
								enable = true,
							},
							validate = true,
							schemaStore = {
								-- Must disable built-in schemaStore support to use
								-- schemas from SchemaStore.nvim plugin
								enable = false,
								-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
								url = "",
							},
						},
					},
				},
				eslint = {
					settings = {
						workingDirectories = { mode = "auto" },
						format = true,
					},
					experimental = {
						useFlatConfig = true,
					},
					filetypes = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
						"vue",
						"svelte",
						"astro",
						-- antfu eslint config formatting
						"html",
						"css",
						"markdown",
						"json",
					},
				},
			},
			setup = {
				jdtls = function()
					return true
				end,
				yamlls = function()
					Util.lsp.on_attach(function(client, _)
						if client.name == "yamlls" then
							client.server_capabilities.documentFormattingProvider = true
						end
					end)
				end,
				eslint = function()
					Util.lsp.on_attach(function(client, _)
						if client.name == "eslint" then
							client.server_capabilities.documentFormattingProvider = true
						end
					end)
				end,
			},
		},
		---@param opts PluginLspOpts
		config = function(_, opts)
			-- setup autoformat
			Util.format.register(Util.lsp.formatter())
			Util.format.setup()

			-- setup formatting and keymaps
			Util.lsp.on_attach(function(client, buffer)
				require("plugins.lsp.keymaps").on_attach(client, buffer)
			end)

			Util.lsp.setup_dynamic_capability()
			Util.lsp.on_dynamic_capability(require("plugins.lsp.keymaps").on_attach)

			-- diagnostics
			for name, icon in pairs(Util.icons.icons.diagnostics) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end

			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			local servers = opts.servers
			local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			local has_blink, blink = pcall(require, "blink.cmp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				has_cmp and cmp_nvim_lsp.default_capabilities() or {},
				has_blink and blink.get_lsp_capabilities() or {},
				opts.capabilities or {}
			)

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})

				---@diagnostic disable-next-line: redundant-parameter
				if opts.setup[server] and opts.setup[server](server, server_opts) then
					return
				end
				require("lspconfig")[server].setup(server_opts)
			end

			-- get all the servers that are available through mason-lspconfig
			local have_mason, mlsp = pcall(require, "mason-lspconfig")
			local all_mslp_servers = {}
			if have_mason then
				all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
			end

			local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
					if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
						setup(server)
					else
						ensure_installed[#ensure_installed + 1] = server
					end
				end
			end

			mlsp.setup({
				automatic_installation = true,
				ensure_installed = ensure_installed,
				handlers = { setup },
			})

			if Util.lsp.get_config("denols") and Util.lsp.get_config("ts_ls") then
				local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
				Util.lsp.disable("ts_ls", is_deno)
				Util.lsp.disable("denols", function(root_dir)
					return not is_deno(root_dir)
				end)
			end
		end,
	},

	-- cmdline tools and lsp servers
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				"stylua",
			},
			ui = {
				border = "rounded",
				width = 0.8,
				height = 0.8,
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {},
		},
	},
}
