---@alias colorscheme.Highlights table<string,vim.api.keyset.highlight|string>

local M = {}

M.black = "#0c0e15" -- black0
M.bg_d = "#141b24" -- black1
M.bg0 = "#1a212e" -- black2
M.bg1 = "#21283b" -- black3
M.bg2 = "#283347" -- black4
M.bg3 = "#2a324a" -- black5

M.none = "none"
M.fg = "#99aac9" -- light gray (fg)

M.light_gray = "#6c7d9c"
M.gray = "#4a5b7a"

M.red = "#f65866" -- pinkish, pomegranate red
M.dark_red = "#992525"

M.green = "#8bcd5b" -- light lime green
M.dark_green = "#2f8d00"
M.success_green = "#42d43f" -- greener green, for checkhealth OKs

M.blue = "#41a7fc" -- intense bright skyish blue
M.dark_blue = "#005995"

M.yellow = "#efbd5d" -- more intense light creamy yellow
M.dark_yellow = "#8f610d"

M.purple = "#c75ae8" -- pinkish purple
M.dark_purple = "#862aa1"

M.cyan = "#34bfd0"
M.dark_cyan = "#1b6a73"

M.orange = "#dd9046" -- dimmed orange,

M.diff = {
	add = "#0c1f00",
	delete = "#280005",
	change = "#00172d",
	text = "#002543",
}

M.rainbow = {
	M.red,
	M.purple,
	M.orange,
	M.blue,
	M.yellow,
	M.cyan,
	M.green,
}

-- use if idk what the thing does
M.UNKNOWN = "#ff00ff"

return M
