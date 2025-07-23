return {
	{ "nvim-lua/plenary.nvim",  lazy = true },                    -- several common functions used by other plugins
	{ "nvim-lua/popup.nvim",    lazy = true },                    -- provides api equivalent to vim's popup_*
	{ "moll/vim-bbye",          lazy = true, cmd = { "Bdelete", "Bwipeout" } }, -- provides :Bdelete and :Bwipeout
	-- Colorschemes
	{ "lunarvim/darkplus.nvim", lazy = true },
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "night",
			light_style = "day",
			day_brightness = 0.2,
		},
		config = function (_, opts)
			require("tokyonight").setup(opts)
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
	{
		"RaafatTurki/hex.nvim",
		config = true,
		lazy = true,
		cmd = { "HexToggle", "HexDump", "HexAssemble" },
	},
	{
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
		lazy = true,
		cmd = "CommentToggle", -- command that triggers the load of the pluggin
		keys = {         -- keys that triggers the load of the pluggin
			{ "gcc", mode = "n" },
			{ "gcb", mode = "n" },
			{ "gc",  mode = { "v", "n" } },
			{ "gb",  mode = { "v", "n" } },
		},
	},
	{
		"akinsho/toggleterm.nvim",
		opts = {
			size = 20,
			open_mapping = [[<A-t>]],
			hide_numbers = true,
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			persist_size = true,
			direction = "horizontal", -- horizontal, vertical or float
			close_on_exit = true,
			shell = vim.o.shell,
		},
		lazy = true,
		cmd = "TermExec",
		keys = {
			{ "<A-t>", mode = "n" },
		},
	},
	{
		"godlygeek/tabular",
		lazy = false,
		init = function()
		end
	},
	-- {
	-- 	"nmac427/guess-indent.nvim",
	-- 	opts = {
	-- 		auto_cmd = true,      -- Set to false to disable automatic execution
	-- 		override_editorconfig = false, -- Set to true to override settings set by .editorconfig
	-- 		filetype_exclude = {  -- A list of filetypes for which the auto command gets disabled
	-- 			"netrw",
	-- 			"tutor",
	-- 		},
	-- 		buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
	-- 			"help",
	-- 			"nofile",
	-- 			"terminal",
	-- 			"prompt",
	-- 		},
	-- 	},
	-- },
}
