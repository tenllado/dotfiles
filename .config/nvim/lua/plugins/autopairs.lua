return {
	{
		"windwp/nvim-autopairs",
		opts = {
			check_ts = true,
			ts_config = {
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
				java = false,
			},
		},
		config = function(lazy, opts)
			require("nvim-autopairs").setup(opts)

			local cmp_ok, cmp = pcall(require, "cmp")
			if not cmp_ok then
				return
			end
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")

			cmp.event:on(
				"confirm_done",
				cmp_autopairs.on_confirm_done({
					map_char = { tex = "" }, -- not sure if this is correct or if it should be filetypes = { tex = false}
				})
			)
		end,
	},
}

