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

				vim.keymap.set("n", "<leader>hS", gs.stage_buffer)
				vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk)
				vim.keymap.set("n", "<leader>hR", gs.reset_buffer)
				vim.keymap.set("n", "<leader>hp", gs.preview_hunk)
				vim.keymap.set("n", "<leader>tb", gs.toggle_current_line_blame)
				vim.keymap.set("n", "<leader>hd", gs.diffthis)
				vim.keymap.set("n", "<leader>hq", gs.setqflist)
				vim.keymap.set("n", "<leader>hl", gs.setloclist)
				vim.keymap.set("n", "<leader>hb", blame_line)
				vim.keymap.set("n", "<leader>hD", function () gs.diffthis("~") end)
				vim.keymap.set("n", "<leader>td", gs.toggle_deleted)
				vim.keymap.set("n", "[h", prev_hunk, { expr = true })
				vim.keymap.set("n", "]h", next_hunk, { expr = true })

				vim.keymap.set({"n", "v"}, "<leader>hs", ":Gitsigns stage_hunk<CR>")
				vim.keymap.set({"n", "v"}, "<leader>hr", ":Gitsigns reset_hunk<CR>")
				vim.keymap.set({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>")
			end,
		},
	},
}

return M
