return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",
	build = ":TSUpdate",
	config = function(lazy, opts)
		local ensure_installed = {
			'c',
			'cpp',
			'cmake',
			"lua",
			"vim",
			"vimdoc",
			"bash",
			"diff",
			"python",
			"bibtex",
			"devicetree",
			"dockerfile",
			"doxygen",
			"git_config",
			"git_rebase",
			"gitignore",
			"gitcommit",
			"gnuplot",
			"json",
			"kconfig",
			-- "latex", -- having a problem with the tree-sitter version installed in the system
			"make",
			"printf",
			"verilog",
			"yaml",
		}

		require('nvim-treesitter').install(ensure_installed)

		-- FIXME: Should be in an autogroup
		vim.api.nvim_create_autocmd('FileType', {
			pattern = ensure_installed,
			callback = function() vim.treesitter.start() end,
		})

		vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
	end,
}
