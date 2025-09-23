return {
	{ "neovim/nvim-lspconfig" },
	{ -- Package manager for lsp servers, dap servers, linters and formatters
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		lazy = false,
		opts = {
			ui = {
				icons = {
					package_installed = "",
					package_pending = "",
					package_uninstalled = "",
				},
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			automatic_enable = true,
			ensure_installed = {  -- install theses servers automatically if they are not installed already
				"cmake",          -- or neocmake?
				"bashls",
				"clangd",
				"pyright",
				"jsonls",
				"texlab",
				"lua_ls", -- TODO: have a look to luau_lsp
				"vimls",
				"ltex", -- TODO: compare ltex and texlab
				-- "marksman",
			},
		},
	},
}
