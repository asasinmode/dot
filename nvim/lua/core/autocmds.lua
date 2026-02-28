local function augroup(name)
	return vim.api.nvim_create_augroup("asasinmode_" .. name, { clear = true })
end

-- check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	command = "checktime",
})

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].asasinmode_last_loc then
			return
		end
		vim.b[buf].asasinmode_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- change conceal for markdown files
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("markdown_conceal"),
	pattern = { "markdown" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

-- remove empty shada files https://github.com/neovim/neovim/issues/8587#issuecomment-3557794273
vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
	group = vim.api.nvim_create_augroup("cleanup_shada_temp", { clear = true }),
	pattern = { "*" },
	callback = function()
		local status = 0
		for _, f in ipairs(vim.fn.globpath(vim.fn.stdpath("data") .. "/shada", "*tmp*", false, true)) do
			if vim.tbl_isempty(vim.fn.readfile(f)) then
				status = status + vim.fn.delete(f)
			end
		end
		if status ~= 0 then
			vim.notify("Could not delete empty temporary ShaDa files.", vim.log.levels.ERROR)
			vim.fn.getchar()
		end
	end,
	desc = "Delete empty temp ShaDa files",
})
