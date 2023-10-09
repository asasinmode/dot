local M = {}

---@type PluginLspKeys
M._keys = nil

function M.get()
	local format = require("plugins.lsp.format").format
	if M._keys then
		return M._keys
	end
	---@class PluginLspKeys
	M._keys = {
		{ "K", vim.lsp.buf.hover, desc = "Hover documentation" },
		{ "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
		{ "<leader>df", vim.diagnostic.open_float, desc = "[D]iagnostics [F]loating message" },
		{ "<leader>rn", vim.lsp.buf.rename, desc = "[R]e[N]ame" },
		{
			"<leader>ca",
			vim.lsp.buf.code_action,
			desc = "[C]ode [A]ction",
			mode = { "n", "v" },
			has = "codeAction",
		},
		{
			"gd",
			"<cmd>Telescope lsp_definitions<cr>",
			desc = "[G]oto [D]efinition",
			has = "definition",
		},
		{ "gr", "<cmd>Telescope lsp_references<cr>", desc = "[G]oto [R]eferences" },
		{ "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "[G]oto [I]mplementation" },
		{ "gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "[G]oto [T]ype Definition" },
		{ "]d", M.diagnostic_goto(true), desc = "Next Diagnostic" },
		{ "[d", M.diagnostic_goto(false), desc = "Prev Diagnostic" },
		{ "]e", M.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
		{ "[e", M.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
		{ "]w", M.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
		{ "[w", M.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
		{
			"<leader>cf",
			format,
			desc = "[C]ode [F]ormat Document",
			has = "documentFormatting",
		},
		{
			"<leader>cf",
			format,
			desc = "[C]ode [F]ormat Range",
			mode = "v",
			has = "documentRangeFormatting",
		},
	}
	return M._keys
end

---@param method string
function M.has(buffer, method)
	method = method:find("/") and method or "textDocument/" .. method
	local clients = require("util.lua").get_clients({ bufnr = buffer })
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
	local opts = require("util.lua").opts("nvim-lspconfig")
	local clients = require("util.lua").get_clients({ bufnr = buffer })
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

function M.diagnostic_goto(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end

return M
