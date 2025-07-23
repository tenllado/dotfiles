local function dirUp(prompt_bufnr)
	local current_picker =
		require("telescope.actions.state").get_current_picker(prompt_bufnr)
	-- cwd is only set if passed as telescope option
	local cwd = current_picker.cwd and tostring(current_picker.cwd)
		or vim.loop.cwd()
	local parent_dir = vim.fs.dirname(cwd)
	-- Posible alternative: use current_picker:refresh
	require("telescope.actions").close(prompt_bufnr)
	require("telescope.builtin").find_files {
		prompt_title = vim.fs.basename(parent_dir),
		cwd = parent_dir,
	}
end

return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- needed by telescope
			"BurntSushi/ripgrep", -- suggested by telescope
		},
		config = function ()
			local ts = require("telescope")
			local actions = require("telescope.actions")
			ts.setup {
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					path_display = { "truncate" },
					mappings = {
						i = {
							["<C-n>"] = actions.cycle_history_next,
							["<C-p>"] = actions.cycle_history_prev,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-c>"] = actions.close,
							["<Down>"] = actions.move_selection_next,
							["<Up>"] = actions.move_selection_previous,
							["<CR>"] = actions.select_default,
							["<C-s>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
							["<C-t>"] = actions.select_tab,
							["<C-u>"] = actions.preview_scrolling_up,
							["<C-d>"] = actions.preview_scrolling_down,
							["<PageUp>"] = actions.results_scrolling_up,
							["<PageDown>"] = actions.results_scrolling_down,
							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-l>"] = actions.complete_tag,
							["<M-k>"] = actions.which_key, -- keys from pressing <C-/>
							["<C-up>"] = dirUp,
						},
						n = {
							["<esc>"] = actions.close,
							["<CR>"] = actions.select_default,
							["<C-s>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
							["<C-t>"] = actions.select_tab,
							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["j"] = actions.move_selection_next,
							["k"] = actions.move_selection_previous,
							["H"] = actions.move_to_top,
							["M"] = actions.move_to_middle,
							["L"] = actions.move_to_bottom,
							["<Down>"] = actions.move_selection_next,
							["<Up>"] = actions.move_selection_previous,
							["gg"] = actions.move_to_top,
							["G"] = actions.move_to_bottom,
							["<C-u>"] = actions.preview_scrolling_up,
							["<C-d>"] = actions.preview_scrolling_down,
							["<PageUp>"] = actions.results_scrolling_up,
							["<PageDown>"] = actions.results_scrolling_down,
							["?"] = actions.which_key,
						},
					}
				},
				pickers = {
					man_pages = {
						sections = { "ALL" },
					},
				},
			}

			local mappings = {
				n = {
					--["<Leader>b" ] = ":ls<Cr>:b<Space>"),
					["<Leader>fb"] = "<cmd>Telescope buffers<cr>",
					["<leader>ff"] = "<cmd>Telescope find_files<cr>",
					["<leader>fg"] = "<cmd>Telescope live_grep<cr>",
					["<leader>fm"] = "<cmd>Telescope man_pages<cr>",
					["<leader>fh"] = "<cmd>Telescope help_tags<cr>",
					["<leader>fq"] =
					"<cmd>lua require'telescope.builtin'.quickfix{}<cr>",
					["<leader>fd"] = "<cmd>Telescope diagnostics<cr>",
					["<leader>fj"] = "<cmd>Telescope jumplist<cr>",
					["<leader>fr"] = "<cmd>Telescope registers<cr>",
					["<leader>fk"] = "<cmd>Telescope keymaps<cr>",
					["<leader>/"] =
					"<cmd>Telescope current_buffer_fuzzy_find<cr>",
				}
			}
			require("keymaps").set_mappings(mappings)
		end,
		cmd = "Telescope",
		keys = {
			{ "<leader>f", mode = "n" },
			{ "<leader>/", mode = "n" },
		},
	},
}
