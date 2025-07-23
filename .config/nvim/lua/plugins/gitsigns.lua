local M = {
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "x" },
				delete = { text = "-" },
				untracked = { text = "┆" },
				topdelete = { text = "T" },
				changedelete = { text = "~" },
			},
			watch_gitdir = {
				enable = true,
				interval = 1000,
				follow_files = true,
			},
			sign_priority = 6,
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = true,      -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			attach_to_untracked = true,
			-- current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			-- current_line_blame_opts = {
			-- 	virt_text = true,
			-- 	virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
			-- 	delay = 1000,
			-- 	ignore_whitespace = false,
			-- },
			-- current_line_blame_formatter_opts = {
			-- 	relative_time = false,
			-- },
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000,
			preview_config = {
				-- Options passed to nvim_open_win
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			--yadm = {
			--	enable = false,
			--},
			on_attach = function (bufnr)
				local gs = package.loaded.gitsigns

				local function next_hunk()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function () gs.next_hunk() end)
					return "<Ignore>"
				end

				local function prev_hunk()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function () gs.prev_hunk() end)
					return "<Ignore>"
				end

				local function blame_line()
					gs.blame_line({ full = true })
				end

				local mappings = {
					["n"] = {
						["<leader>hS"] = gs.stage_buffer,
						["<leader>hu"] = gs.undo_stage_hunk,
						["<leader>hR"] = gs.reset_buffer,
						["<leader>hp"] = gs.preview_hunk,
						["<leader>tb"] = gs.toggle_current_line_blame,
						["<leader>hd"] = gs.diffthis,
						["<leader>hq"] = gs.setqflist,
						["<leader>hl"] = gs.setloclist,
						["<leader>hb"] = blame_line,
						["<leader>hD"] = function () gs.diffthis("~") end,
						["<leader>td"] = gs.toggle_deleted,
						["[h"] = { prev_hunk, { expr = true } },
						["]h"] = { next_hunk, { expr = true } },
					},
					[{ "n", "v" }] = {
						["<leader>hs"] = ":Gitsigns stage_hunk<CR>",
						["<leader>hr"] = ":Gitsigns reset_hunk<CR>",
					},
					[{ "o", "x" }] = {
						["ih"] = ":<C-U>Gitsigns select_hunk<CR>",
					}
				}

				require("keymaps").set_mappings(mappings)
			end,
		},
	},
}

return M
