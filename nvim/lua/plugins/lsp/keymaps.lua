local M = {}

---@type LazyKeysLspSpec[]|nil
M._keys = nil

---@alias LazyKeysLspSpec LazyKeysSpec|{has?:string}
---@alias LazyKeysLsp LazyKeys|{has?:string}

---@return LazyKeysLspSpec[]
function M.get()
	if M._keys then
		return M._keys
	end
    -- stylua: ignore
    M._keys =  {
      { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "go to definition", has = "definition" },
      { "gr", "<cmd>Telescope lsp_references<cr>", desc = "go to references" },
      { "gD", vim.lsp.buf.declaration, desc = "go to declaration" },
      { "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, desc = "go to implementation" },
      { "gt", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "go to type definition" },
      { "K", vim.lsp.buf.hover, desc = "hover" },
      { "gK", vim.lsp.buf.signature_help, desc = "signature help", has = "signatureHelp" },
			{ "<leader>rn", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "code action", mode = { "n", "v" }, has = "codeAction" },
      {
        "<leader>cA",
        function()
          vim.lsp.buf.code_action({
            context = {
              only = {
                "source",
              },
              diagnostics = {},
            },
          })
        end,
        desc = "source action",
        has = "codeAction",
      }
    }
	return M._keys
end

---@param method string
function M.has(buffer, method)
	method = method:find("/") and method or "textDocument/" .. method
	local clients = require("lazyvim.util").lsp.get_clients({ bufnr = buffer })
	for _, client in ipairs(clients) do
		if client.supports_method(method) then
			return true
		end
	end
	return false
end

---@return (LazyKeys|{has?:string})[]
function M.resolve(buffer)
	local Keys = require("lazy.core.handler.keys")
	if not Keys.resolve then
		return {}
	end
	local spec = M.get()
	local opts = require("lazyvim.util").opts("nvim-lspconfig")
	local clients = require("lazyvim.util").lsp.get_clients({ bufnr = buffer })
	for _, client in ipairs(clients) do
		local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
		vim.list_extend(spec, maps)
	end
	return Keys.resolve(spec)
end

function M.on_attach(_, buffer)
	local Keys = require("lazy.core.handler.keys")
	local keymaps = M.resolve(buffer)

	for _, keys in pairs(keymaps) do
		if not keys.has or M.has(buffer, keys.has) then
			local opts = Keys.opts(keys)
			opts.has = nil
			opts.silent = opts.silent ~= false
			opts.buffer = buffer
			vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
		end
	end
end

return M
