-- Key Mappings
-- :h map-modes
-- :h nvim_set_keymap
-- :h vim.keymap.set() remap option defaults to false
--
-- Modes
--   normal                 "n"
--   insert                 "i"
--   visual                 "x"
--   select                 "x"
--   operator-pending       "o"
--   terminal               "t"
--   command                "c"
--   lang-arg
--
-- combinations:
--   visual + select        "v"
--   insert + Cmd + Lang    "l"
--
-- map!                     "!"
-- map                      ""
--   norm + vis + sel + opr
--
-- options: defualt false
--    nowait, silent, script, expr, unique
--    noremap, desc, callback, replace_keycodes

local mappings = {
	[""] = {
		["<Space>"] = { "<Nop>", { desc = "ignore space" } },
	},
	["n"] = {
		["<C-h>"]     = { "<C-w>h", { desc = "Focus window on the left" } },
		["<C-j>"]     = { "<C-w>j", { desc = "Focus window below" } },
		["<C-k>"]     = { "<C-w>k", { desc = "Focus window above" } },
		["<C-l>"]     = { "<C-w>l", { desc = "Focus window on the right" } },
		["<C-Up>"]    = { ":resize +2<CR>", { desc = "Increase window height " } },
		["<C-Down>"]  = { ":resize -2<CR>", { desc = "Decrease window height" } },
		["<C-Left>"]  = { ":vertical resize -2<CR>", { desc = "Decrease window width" } },
		["<C-Right>"] = { ":vertical resize +2<CR>", { desc = "Increase window width" } },
		["L"]         = { ":bnext<CR>", { desc = "Go to next buffer in the buffer list" } },
		["H"]         = { ":bprev<CR>", { desc = "Go to previous buffer the buffer list" } },
		["#"]         = { ":b#<CR>", { desc = "Go to alternate buffer" } },
		["<leader>q"] = { "<cmd>Bdelete<cr>", { desc = "Delete/Close buffer" } },
		["K"]         = { ':<C-U>exe "Man" v:count "<C-R><C-W>"<CR>', { desc = "Open man page of word under cursor in split" } },
		["<c-u>"]     = { "<c-u>zz", { desc = "Scroll up in the buffer and center the cursor" } },
		["<c-d>"]     = { "<c-d>zz", { desc = "Scroll down in the buffer and center the cursor" } },
		-- ["n"]         = { "nzzzv", { desc = "Go to next search and center the cursor" } },
		-- ["N"]         = { "Nzzzv", { desc = "Go to previous search and center the cursor" } },
		["<leader>k"] = { function()
			if vim.o.filetype == 'markdown' then
				local root_dir = require('mkdnflow').root_dir
				if root_dir then  -- if the dir is not nil
					return ':Telescope find_files search_dirs={"'..root_dir..'"}<CR>'
				end
			end
		end, {expr = true, replace_keycodes = true}},
	},
	["i"] = {
		["jk"] = { "<ESC>", { desc = "Go back to normal mode (Esc)" } },
	},
	["t"] = {
		["<Esc>"] = { "<C-\\><C-N>", { desc = "Change from terminal mode to normal mode" } },
	},
	[{ "i", "t" }] = {
		["<C-h>"] = { "<C-\\><C-N><C-w>h", { desc = "Focus window on the left" } },
		["<C-j>"] = { "<C-\\><C-N><C-w>j", { desc = "Focus window below" } },
		["<C-k>"] = { "<C-\\><C-N><C-w>k", { desc = "Focus window above" } },
		["<C-l>"] = { "<C-\\><C-N><C-w>l", { desc = "Focus window on the right" } },
	},
	["v"] = {
		["<"] = { "<gv", { desc = "Reduce indent and stay in visual mode" } },
		[">"] = { ">gv", { desc = "Increase indent and stay in visual mode" } },
		["p"] = { '"_dP', { desc = 'Paste and preserve yanked text in the unnamed register " (throwing away the selected text)' } },
	},
	["x"] = {
		["<A-j>"] = { ":move '>+1<CR>gv=gv", { desc = "Move selected text down" } },
		["<A-k>"] = { ":move '<-2<CR>gv=gv", { desc = "Move selected text up" } },
	}
}

local function set_mappings(maps, defaults)
	defaults = defaults or {}
	-- FIXME: this is a workaround to a problem found using this function in the
	-- configuration of treesitter, apparently then table has not been fully
	-- loaded and the unpack field is missing
	local _unpack = table.unpack or unpack
	local function get_command(c)
		local com, opts = c, {}
		if type(c) == "table" then
			com, opts = _unpack(c)
			--com, opts = table.unpack(com) -- this gives me problems when used in the treesitter config
		end
		return com, opts
	end

	for m, t in pairs(maps) do
		for k, v in pairs(t) do
			local com, opts = get_command(v)
			opts = vim.tbl_extend("keep", opts, defaults)
			vim.keymap.set(m, k, com, opts)
		end
	end
end

set_mappings(mappings, { silent = true })

return {
	set_mappings = set_mappings,
}
