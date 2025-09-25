require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.lsp")

vim.cmd([[colorscheme tokyonight]])

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


