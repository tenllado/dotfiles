-- Lazy.nvim as plugin manager, requires leader key before loading
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.termguicolors = true -- most terminals support this, some plugins require it

-- Avoid loading netrw
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 20

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath
	})
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

require("options")
require("keymaps")
require("lsp")

-- Autocommands
--local ag_conceal = vim.api.nvim_create_augroup("conceal", { clear = true })
--vim.api.nvim_create_autocmd({ "BufEnter", "BufNew", "BufNewFile" }, {
--	pattern = { "*.md" },
--	command = "setlocal conceallevel=2",
--	group = ag_conceal,
--	desc = "set conceallevel=2 for markdown files",
--})

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

--vim.lsp.enable({'clangd'})


