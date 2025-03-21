local Util = require("util")

---@class asasinmode.util.toggle
local M = {}

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.option(option, silent, values)
	if values then
		if vim.opt_local[option]:get() == values[1] then
			---@diagnostic disable-next-line: no-unknown
			vim.opt_local[option] = values[2]
		else
			---@diagnostic disable-next-line: no-unknown
			vim.opt_local[option] = values[1]
		end
		return Util.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
	end
	---@diagnostic disable-next-line: no-unknown
	vim.opt_local[option] = not vim.opt_local[option]:get()
	if not silent then
		if vim.opt_local[option]:get() then
			Util.info("Enabled " .. option, { title = "Option" })
		else
			Util.warn("Disabled " .. option, { title = "Option" })
		end
	end
end

local enabled = true
function M.diagnostics()
	enabled = not enabled
	if enabled then
		vim.diagnostic.enable()
		Util.info("Enabled diagnostics", { title = "Diagnostics" })
	else
		vim.diagnostic.enable(false)
		Util.warn("Disabled diagnostics", { title = "Diagnostics" })
	end
end

setmetatable(M, {
	__call = function(m, ...)
		return m.option(...)
	end,
})

return M
