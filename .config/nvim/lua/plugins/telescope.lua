local actions = require("telescope.actions")

return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- needed by telescope
			"BurntSushi/ripgrep", -- suggested by telescope
		},
		opts = {
			defaults = {
				path_display = { "truncate" },
				mappings = {
					i = {
						["<C-h>"] = "which_key",
						["<C-s>"] = actions.select_horizontal,
					},
				},
			},
			pickers = {
				man_pages = {
					sections = { "1", "2", "3", "5", "7" },
				},
			},
			extensions = {
				fzf = {
				},
			}
		},
		config = function (lazy, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			telescope.load_extension("fzf")
			vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope buffers<cr>")
			vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
			vim.keymap.set("n", "<leader>fc", function ()
				require("telescope.builtin").find_files({cwd = "~/.config/nvim"})
			end)
			vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
			vim.keymap.set("n", "<leader>fm", "<cmd>Telescope man_pages<cr>")
			vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
			vim.keymap.set("n", "<leader>fq", "<cmd>lua require'telescope.builtin'.quickfix{}<cr>")
			vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>")
			vim.keymap.set("n", "<leader>fj", "<cmd>Telescope jumplist<cr>")
			vim.keymap.set("n", "<leader>fr", "<cmd>Telescope registers<cr>")
			vim.keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>")
			vim.keymap.set("n", "<leader>/" , "<cmd>Telescope current_buffer_fuzzy_find<cr>")
		end,
		cmd = "Telescope",
		keys = {
			{ "<leader>f", mode = "n" },
			{ "<leader>/", mode = "n" },
		},
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
	},
}
