return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		style = "night",
		light_style = "day",
		day_brightness = 0.2,
	},
	config = function(lazy, opts)
		require('tokyonight').setup(opts)
		vim.cmd.colorscheme("tokyonight")
	end
}
