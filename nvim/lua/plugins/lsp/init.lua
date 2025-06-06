local Util = require("util")

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile", "BufWritePre" },
		dependencies = {
			{ "b0o/SchemaStore.nvim", lazy = true, version = false },
			"mason.nvim",
			"mason-org/mason-lspconfig.nvim",
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
					settings = {
						json = {
							format = { enable = true },
							validate = { enable = true },
						},
					},
				},
				cssls = {
					settings = {
						css = {
							lint = {
								unknownAtRules = "ignore",
							},
						},
					},
					init_options = {
						provideFormatter = false,
					},
				},
				html = {
					init_options = {
						provideFormatter = false,
					},
				},
				vtsls = {
					settings = {
						complete_function_calls = true,
						vtsls = {
							autoUseWorkspaceTsdk = true,
							experimental = {
								completion = {
									enableServerSideFuzzyMatch = true,
								},
							},
						},
						typescript = {
							updateImportsOnFileMove = { enabled = "always" },
							suggest = {
								completeFunctionCalls = true,
							},
						},
					},
					tsserver = {
						globalPlugins = {
							{
								name = "@vue/typescript-plugin",
								location = vim.fn.expand(
									"~/AppData/Local/fnm_multishells/2876_1738416076326/node_modules/@vue/typescript-plugin"
								),
								languages = { "vue", "markdown" },
								configNamespace = "typescript",
								enableForWorkspaceTypeScriptVersions = true,
							},
						},
					},
					filetypes = {
						"javascript",
						"typescript",
						"vue",
						"markdown",
					},
				},
				jdtls = {},
				yamlls = {
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
						"yaml",
					},
				},
			},
			setup = {
				jdtls = function()
					return true
				end,
				jsonls = function(_, opts)
					opts.settings.json.schemas = require("schemastore").json.schemas()
				end,
				yamlls = function(_, opts)
					opts.settings.yaml.schemas = require("schemastore").yaml.schemas()
				end,
				eslint = function()
					Util.lsp.on_attach(function(client, _)
						if client.name == "eslint" then
							client.server_capabilities.documentFormattingProvider = true
						elseif client.name == "vtsls" then
							client.server_capabilities.documentFormattingProvider = false
						end
					end)
				end,
				vtsls = function(_, opts)
					opts.settings.javascript =
						vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
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
			local has_blink, blink = pcall(require, "blink.cmp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				has_blink and blink.get_lsp_capabilities() or {},
				opts.capabilities or {}
			)

			-- get all the servers that are available through mason-lspconfig
			local have_mason, mlsp = pcall(require, "mason-lspconfig")
			local all_mslp_servers = {}
			if have_mason then
				all_mslp_servers =
					vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
			end

			local function configure(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})

				if server_opts.enabled == false or opts.setup[server] and opts.setup[server](server, server_opts) then
					return
				end

				vim.lsp.config(server, server_opts)

				if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
					vim.lsp.enable(server)
					return true
				end
				return false
			end

			local exclude_automatic_enable = {} ---@type string[]
			local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					if server_opts.enabled ~= false then
						if configure(server) then
							exclude_automatic_enable[#exclude_automatic_enable + 1] = server
						else
							ensure_installed[#ensure_installed + 1] = server
						end
					end
				end
			end

			mlsp.setup({
				automatic_enable = {
					exclude = exclude_automatic_enable,
				},
				ensure_installed = ensure_installed,
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
		"mason-org/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				"lua-language-server",
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
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}
