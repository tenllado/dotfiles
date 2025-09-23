return {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" }, -- variables declared as global
			},
			workspace = {
				library = { -- paths added to the workspace diagnosis
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
				maxPreload = 100000,
				preLoadFileSize = 10000,
			},
		},
	},
}
