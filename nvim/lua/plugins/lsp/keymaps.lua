local M = {}

---@type PluginLspKeys
M._keys = nil

function M.get()
	local format = require("plugins.lsp.format").format
	if not M._keys then
		---@class PluginLspKeys
    -- stylua: ignore
		M._keys = {
			{ "K", vim.lsp.buf.hover, desc = "Hover documentation" },
			{ "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
			{ "<leader>df", vim.diagnostic.open_float, desc = "[D]iagnostics [F]loating message" },
			{ "<leader>rn", vim.lsp.buf.rename, desc = "[R]e[N]ame" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "[C]ode [A]ction", mode = { "n", "v" }, has = "codeAction" },
			{ "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "[G]oto [D]efinition", has = "definition" },
			{ "gr", "<cmd>Telescope lsp_references<cr>", desc = "[G]oto [R]eferences" },
			{ "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "[G]oto [I]mplementation" },
			{ "gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "[G]oto [T]ype Definition" },
			{ "]d", M.diagnostic_goto(true), desc = "Next Diagnostic" },
			{ "[d", M.diagnostic_goto(false), desc = "Prev Diagnostic" },
			{ "]e", M.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
			{ "[e", M.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
			{ "]w", M.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
			{ "[w", M.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
			{ "<leader>cf", format, desc = "[C]ode [F]ormat Document", has = "documentFormatting" },
			{ "<leader>cf", format, desc = "[C]ode [F]ormat Range",	mode = "v",	has = "documentRangeFormatting" },
		}
	end
	return M._keys
end

function M.on_attach(client, buffer)
	local Keys = require("lazy.core.handler.keys")
	local keymaps = {}

	for _, value in ipairs(M.get()) do
		local keys = Keys.parse(value)
		if keys[2] == vim.NIL or keys[2] == false then
			keymaps[keys.id] = nil
		else
			keymaps[keys.id] = keys
		end
	end

	for _, keys in pairs(keymaps) do
		if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
			local opts = Keys.opts(keys)
			opts.has = nil
			opts.silent = true
			opts.buffer = buffer
			vim.keymap.set(keys.mode or "n", keys[1], keys[2], opts)
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
