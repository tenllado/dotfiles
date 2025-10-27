return {
	'stevearc/oil.nvim',
	opts = {
	},
	dependencies = { { "nvim-mini/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	config = function(lazy, opts)
		require('oil').setup(opts)
		vim.keymap.set("n", "<leader>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
	lazy = false,
}
