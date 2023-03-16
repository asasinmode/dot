local Util = require('util.lua')

local function map(mode, lhs, rhs, opts)
	local keys = require('lazy.core.handler').handlers.keys
	---@cast keys LazyKeysHandler
	-- do not create the keymap if a lazy keys handler exists
	if not keys.active[keys.parse({ lhs, mode = mode }).id] then
		opts = opts or {}
		opts.silent = opts.silent ~= false
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

-- keep cursor in the middle when scrolling
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

-- delete without moving to clipboard
map({ 'n', 'v' }, '<leader>d', '"_d', { desc = 'delete without saving to clipboard' })

-- better up/down
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- move to window using the <ctrl> hjkl keys
map('n', '<C-h>', '<C-w>h', { desc = 'go to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'go to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'go to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'go to right window' })

-- resize window using <ctrl> HJKL keys
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'increase window height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'decrease window height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'decrease window width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'increase window width' })

-- move Lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'move line down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'move line up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'move line down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'move line up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'move line down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'move line up' })

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Clear search with <esc>
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'escape and clear hlsearch' })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
	'n',
	'<leader>rl',
	'<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>',
	{ desc = 'Redraw / clear hlsearch / diff update' }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'next search result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'next search result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'next search result' })
map('n', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'prev search result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'prev search result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'prev search result' })

-- Add undo break-points
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', ';', ';<c-g>u')

-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- toggle options
map('n', '<leader>taf', require('plugins.lsp.format').toggle, { desc = '[T]oggle [A]uto [F]ormat on Save' })
map('n', '<leader>ts', function() Util.toggle('spell') end, { desc = '[T]oggle [S]pelling' })
map('n', '<leader>tw', function() Util.toggle('wrap') end, { desc = '[T]oggle Word Wrap' })
map('n', '<leader>td', Util.toggle_diagnostics, { desc = '[T]oggle Diagnostics' })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map('n', '<leader>tc', function() Util.toggle('conceallevel', false, { 0, conceallevel }) end,
	{ desc = '[T]oggle [C]onceal' })

-- fugitive
map('n', '<leader>gs', vim.cmd.Git, { desc = 'Fu[G]itive [S]tatus' })
