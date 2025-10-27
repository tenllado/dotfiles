return {
	on_init = function(client, _)
		client.server_capabilities.semanticTokensProvider = nil  -- turn off semantic tokens
	end,
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
