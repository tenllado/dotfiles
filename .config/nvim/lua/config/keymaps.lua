-- Key Mappings
-- :h map-modes
-- :h nvim_set_keymap
-- :h vim.keymap.set() remap option defaults to false
-- options: defualt false
--    nowait, silent, script, expr, unique
--    noremap, desc, callback, replace_keycodes

vim.g.mapleader = " "
vim.g.maplocalleader = "ç"

vim.keymap.set("", "<Space>", "<Nop>", {desc = "ignore space"})
vim.keymap.set("n", "<C-h>", "<C-w>h", {desc = "Focus window on the left"})
vim.keymap.set("n", "<C-j>", "<C-w>j", {desc = "Focus window below"})
vim.keymap.set("n", "<C-k>", "<C-w>k", {desc = "Focus window above"})
vim.keymap.set("n", "<C-l>", "<C-w>l", {desc = "Focus window on the right"})
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", {desc = "Increase window height"})
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", {desc = "Decrease window height"})
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", {desc = "Decrease window width"})
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", {desc = "Increase window width"})
vim.keymap.set("n", "L", ":bnext<CR>", {desc = "Go to next buffer in the buffer list"})
vim.keymap.set("n", "H", ":bprev<CR>", {desc = "Go to previous buffer in the buffer list"})
vim.keymap.set("n", "#", ":b#<CR>", {desc = "Go to alternate buffer"})
vim.keymap.set("n", "<leader>q", "<cmd>Bdelete<cr>", {desc = "Delete/Close buffer"})
vim.keymap.set("n", "K", ':<C-U>exe "Man" v:count "<C-R><C-W>"<CR>', {desc = "Open man page of word under cursor in split"})
vim.keymap.set("n", "<c-u>", "<c-u>zz", {desc = "Scroll up in the buffer and center the cursor"})
vim.keymap.set("n", "<c-d>", "<c-d>zz", {desc = "Scroll down in the buffer and center the cursor"})
--vim.keymap.set("n", "n", "nzzzv", {desc = "Go to next search and center the cursor"})
--vim.keymap.set("n", "N", "Nzzzv", {desc = "Go to previous search and center the cursor"})
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>", {desc = "Change from terminal mode to normal mode"})

vim.keymap.set( "v", "<", "<gv", {desc = "Reduce indent and stay in visual mode" })
vim.keymap.set( "v", ">", ">gv", {desc = "Increase indent and stay in visual mode" })
vim.keymap.set( "v", "p", '"_dP', {desc = 'Paste and preserve yanked text in the unnamed register " (throwing away the selected text)'})

vim.keymap.set({"i", "t"}, "<C-h>", "<C-\\><C-N><C-w>h", {desc = "Focus window on the left"})
vim.keymap.set({"i", "t"}, "<C-j>", "<C-\\><C-N><C-w>j", {desc = "Focus window below"})
vim.keymap.set({"i", "t"}, "<C-k>", "<C-\\><C-N><C-w>k", {desc = "Focus window above"})
vim.keymap.set({"i", "t"}, "<C-l>", "<C-\\><C-N><C-w>l", {desc = "Focus window on the right"})

vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv=gv", {desc = "Move selected text down"})
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv=gv", {desc = "Move selected text up"})

