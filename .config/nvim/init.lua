-- Lazy.nvim as plugin manager, requires leader key before loading
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.termguicolors = true -- most terminals support this, some plugins require it

-- Avoid loading netrw
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 20

-- -- Download lazy if it does not exist in the data folder
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local lazy_ok, lazy = pcall(require, "lazy")
if lazy_ok then
	-- plugins are lua modules in the lua/plugins directory
	-- Each module declares and configures one or more plugins
	lazy.setup("plugins", { change_detection = { notify = false } })
end

-- Neo/vim options
-- vim.opt.autoindent = true                       -- automatic indent
vim.opt.background = "light"                       -- I am using light background on terminal
vim.opt.backspace = { "indent", "eol", "start" }   -- Backspace deletes and moves to the previous line
vim.opt.backup = false                             -- creates a backup file
vim.opt.clipboard = "unnamedplus"                  -- allows neovim to access the system clipboard
vim.opt.cmdheight = 2                              -- more space in the neovim command line for displaying messages
vim.opt.colorcolumn = { "+1" }                     -- highlight column (textwidth +1)
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.conceallevel = 0                           -- so that `` is visible in markdown files
vim.opt.cinoptions = ":0"
vim.opt.cursorline = true                          -- highlight the current line
vim.opt.expandtab = false                          -- do not convert tabs to spaces
-- vim.opt.exrc = true -- source current directory trusted rc/init files
vim.opt.guifont = "DejaVuSansM Nerd Font Mono:h11" -- the font used in graphical neovim applications
vim.opt.hlsearch = false                           -- not highlight all matches on previous search pattern
vim.opt.hidden = true                              -- a buffer becomes hidden when it is abandoned
vim.opt.incsearch = true                           -- do incremental search as you type the search string
vim.opt.ignorecase = true                          -- ignore case in search patterns
vim.opt.linebreak = true                           -- when wrapping long lines, wrap at a character in breakat
vim.opt.list = false                               -- do not show special symbols for blanks
vim.opt.listchars = { tab = "> ", trail = "-", nbsp = "+" }
vim.opt.mouse = "a"                                -- allow the mouse to be used in neovim
vim.opt.number = true                              -- set numbered lines
vim.opt.numberwidth = 4                            -- set number column width to 4
vim.opt.pumheight = 10                             -- pop up menu height
vim.opt.relativenumber = true                      -- set relative numbered lines
vim.opt.shiftwidth = 4                             -- the number of spaces inserted for each indentation
vim.opt.showmode = true                            -- see things like -- INSERT --
vim.opt.showcmd = true                             -- show partial command in the last line of the screen
vim.opt.signcolumn =
"yes"                                              -- always show the sign column, otherwise it would shift the text each time
vim.opt.smartcase = true                           -- smart case
vim.opt.smartindent = true                         -- make indenting smarter again
vim.opt.smarttab = true                            -- A tab in front of line inserts blanks according to shiftwidth
vim.opt.softtabstop = 4
--vim.opt.splitbelow = true -- horizontal splits open below current window
vim.opt.splitright = true     -- vertical splits open right of current window
vim.opt.swapfile = false      -- creates a swapfile
--vim.opt.scrolloff = 4 -- minimal number of lines above/bellow the cursor to keep shown
vim.opt.sidescrolloff = 4     -- minimal number of left/right columns to keep around cursor
vim.opt.tabstop = 4           -- insert 4 spaces for a tab
vim.opt.textwidth = 80
vim.opt.timeoutlen = 1000     -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.title = true          -- set window title
vim.opt.undofile = true       -- enable persistent undo
vim.opt.updatetime = 300      -- faster completion (4000ms default)
vim.opt.wildmenu = true       -- enhanced command-line completion
vim.opt.writebackup = false   -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.wrap = false          -- do not wrap long lines
vim.opt.shortmess:append("c") -- don't give ins-completion-menu messages
vim.opt.path:append("**")     -- search down into subfolders, with tab-completion for all file operations
-- vim.opt.sessionoptions:append("globals")
-- vim.g.spellfile_URL = "https://ftp.nluug.nl/vim/runtime/spell/"

vim.cmd("set whichwrap+=<,>,[,],h,l")
--vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=tcroqn2bj]])
vim.cmd([[set titlestring=nvim:\ %f]])
vim.cmd([[set wildignore=*.o,*.obj,*.pdf,*.ps,*.eps,*.jpg,*.png,*.tar.gz,*.tgz,*.zip,*tar.bz2]])

require("keymaps")

-- Autocommands
local ag_conceal = vim.api.nvim_create_augroup("conceal", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufNew", "BufNewFile" }, {
	pattern = { "*.md" },
	command = "setlocal conceallevel=2",
	group = ag_conceal,
	desc = "set conceallevel=2 for markdown files",
})

-- local ag_config_indent = vim.api.nvim_create_augroup("config_indent", { clear = true })
-- vim.api.nvim_create_autocmd({ "FileType" }, {
-- 	group = ag_config_indent,
-- 	pattern = { "c", "h", "cpp", "hpp" },
-- 	callback = function()
-- 		vim.opt_local.cindent = true
-- 		vim.opt_local.cinoptions = ":0"
-- 		vim.opt_local.tabstop = 4
-- 		vim.opt_local.softtabstop = 4
-- 		vim.opt_local.shiftwidth = 4
-- 		vim.opt_local.expandtab = false
-- 	end,
-- })
