return {
	"numToStr/Comment.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	opts = {
		pre_hook = function ()
			require("ts_context_commentstring.internal")
			.update_commentstring()
		end,
	},
}
