-- Neo/vim options

-- Netrw stuff
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 20

-- Spelling, url for spell files
vim.g.spellfile_URL = "https://ftp.nluug.nl/vim/runtime/spell/"

-- General and ascetic options
vim.opt.background = "light"                       -- Use light background
vim.opt.backspace = { "indent", "eol", "start" }   -- Backspace deletes and moves to the previous line
vim.opt.backup = false                             -- Do not create backup files
vim.opt.writebackup = false						   -- If a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.cmdheight = 2                              -- lines for displaying messages
vim.opt.conceallevel = 0                           -- so that `` is visible in markdown files
vim.opt.guifont = "DejaVuSansM Nerd Font Mono:h11" -- the font used in graphical neovim applications
vim.opt.list = true                               -- do not show special symbols for blanks
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.mouse = "a"                                -- allow the mouse to be used in neovim
vim.opt.linebreak = true                           -- when wrapping long lines, wrap at a character in breakat
vim.opt.shortmess:append("c") -- don't give ins-completion-menu messages
vim.opt.showmode = false                           -- already in status line 
vim.opt.showcmd = true                             -- show partial command in the last line of the screen
vim.opt.swapfile = false      -- creates a swapfile
vim.opt.termguicolors = true  -- most terminals support this, some plugins require it
vim.opt.title = true          -- set window title
vim.cmd([[set titlestring=nvim:\ %f]])
vim.opt.timeoutlen = 1000     -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true       -- enable persistent undo
vim.opt.updatetime = 300      -- faster completion (4000ms default)
vim.opt.wrap = false          -- do not wrap long lines
--vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=tcroqn2bj]])
vim.cmd([[set whichwrap+=<,>,[,],h,l]])

-- Cmdline behaviour
vim.opt.pumheight = 10        -- pop up menu height
vim.opt.wildmenu = true       -- enhanced command-line completion
vim.opt.path:append("**")						   -- search down into subfolders, with tab-completion for all file operations
vim.cmd([[set wildignore=*.o,*.obj,*.pdf,*.ps,*.eps,*.jpg,*.png,*.tar.gz,*.tgz,*.zip,*tar.bz2]])

-- Indentation options
vim.opt.shiftwidth = 4                             -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4                                -- show tabs as this number of spaces
vim.opt.softtabstop = 4                            -- consider this amount of spaces equivalent to a tab
vim.opt.autoindent = true                          -- automatic indent
vim.opt.smartindent = true                         -- make indenting smarter again
vim.opt.smarttab = true                            -- A tab in front of line inserts blanks according to shiftwidth
vim.opt.cinoptions = ":0"                          -- case labels aligned with switch (see :h cinoptions-values)
vim.opt.expandtab = false                          -- do not convert tabs to spaces

-- Completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Line numbers
vim.opt.number = true                              -- set numbered lines
vim.opt.numberwidth = 4                            -- set number column width to 4
vim.opt.relativenumber = true                      -- set relative numbered lines
vim.opt.signcolumn = "yes"                         -- always show the sign column, otherwise it would shift the text each time

-- Text width and cursorline
vim.opt.textwidth = 80
vim.opt.colorcolumn = { "+1" }                     -- highlight column (textwidth +1)
vim.opt.cursorline = true                          -- highlight the current line

-- Search options
vim.opt.hlsearch = false                           -- not highlight all matches on previous search pattern
vim.opt.hidden = true                              -- a buffer becomes hidden when it is abandoned
vim.opt.incsearch = true                           -- do incremental search as you type the search string
vim.opt.ignorecase = true                          -- ignore case in search patterns
vim.opt.smartcase = true                           -- smart case

-- Splits
vim.opt.splitbelow = false    -- horizontal splits opens above
vim.opt.splitright = true     -- vertical splits open right of current window

-- Scrolling
--vim.opt.scrolloff = 4 -- minimal number of lines above/bellow the cursor to keep shown
vim.opt.sidescrolloff = 4     -- minimal number of left/right columns to keep around cursor

-- Rc/init and session files
-- vim.opt.exrc = true -- source current directory trusted rc/init files
-- vim.opt.sessionoptions:append("globals")
