return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	opts = {
		select = {
			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,
			selection_modes = {
				['@parameter.outer'] = 'v', -- charwise
				['@function.outer'] = 'V', -- linewise
				['@class.outer'] = '<c-v>', -- blockwise
				["@loop.outer"] = "V", -- linewise
				["@loop.inner"] = "V", -- linewise
				["@block.outer"] = "v", -- charwise
				["@conditional.outer"] = "V", -- linewise
				["@conditional.inner"] = "V", -- linewise
			},
		},
		move = {
			-- whether to set jumps in the jumplist
			set_jumps = true,
		},
	},
	config = function (lazy, opts)
		require("nvim-treesitter-textobjects").setup(opts)
		local tssel = require("nvim-treesitter-textobjects.select")

		local select_map = function(keys, query)
			vim.keymap.set({"x", "o"}, keys, function()
				tssel.select_textobject(query, "textobjects")
			end)
		end

		select_map("af", "@function.outer")
		select_map("if", "@function.inner")
		select_map("ac", "@class.outer")
		select_map("ic", "@class.inner")
		select_map("am", "@comment.outer")
		select_map("aa", "@parameter.outer")
		select_map("ia", "@parameter.inner")
		select_map("al", "@loop.outer")
		select_map("il", "@loop.inner")
		select_map("ad", "@conditional.outer")
		select_map("id", "@conditional.inner")
		select_map("as", "@local.scope")

		-- Swaps
		local tssw = require("nvim-treesitter-textobjects.swap")
		local swap_next_map = function(keys, query)
			vim.keymap.set("n", keys, function()
				tssw.swap_next(query)
			end)
		end
		local swap_prev_map = function(keys, query)
			vim.keymap.set("n", keys, function()
				tssw.swap_previous(query)
			end)
		end

		swap_next_map("<leader>sa", "@parameter.inner")
		swap_prev_map("<leader>sA", "@parameter.inner")

		-- Movements
		local tsmov = require("nvim-treesitter-textobjects.move")
		local jump_next_start_map = function(keys, query)
			vim.keymap.set({ "n", "x", "o" }, keys, function()
				tsmov.goto_next_start(query, "textobjects")
			end)
		end

		local jump_next_end_map = function(keys, query)
			vim.keymap.set({ "n", "x", "o" }, keys, function()
				tsmov.goto_next_end(query, "textobjects")
			end)
		end

		local jump_prev_start_map = function(keys, query)
			vim.keymap.set({ "n", "x", "o" }, keys, function()
				tsmov.goto_previous_start(query, "textobjects")
			end)
		end

		local jump_prev_end_map = function(keys, query)
			vim.keymap.set({ "n", "x", "o" }, keys, function()
				tsmov.goto_previous_end(query, "textobjects")
			end)
		end

		local jump_next_end_map = function(keys, query)
			vim.keymap.set({ "n", "x", "o" }, keys, function()
				tsmov.goto_next_end(query, "textobjects")
			end)
		end

		jump_next_start_map("]f", "@function.outer")
		jump_next_end_map("]F", "@function.outer")
		jump_prev_start_map("[f", "@function.outer")
		jump_prev_end_map("[F", "@function.outer")

		jump_next_start_map("]c", "@class.outer")
		jump_next_end_map("]C", "@class.outer")
		jump_prev_start_map("[c", "@class.outer")
		jump_prev_end_map("[C", "@class.outer")

		jump_next_start_map("]l", "@loop.*")
		jump_next_end_map("]L", "@loop.*")
		jump_prev_start_map("[l", "@loop.*")
		jump_prev_end_map("[L", "@loop.*")

		jump_next_start_map("]a", "@parameter.inner")
		jump_next_end_map("]A", "@parameter.inner")
		jump_prev_start_map("[a", "@parameter.inner")
		jump_prev_end_map("[A", "@parameter.inner")

		jump_next_start_map("]b", "@block.outer")
		jump_next_end_map("]B", "@block.outer")
		jump_prev_start_map("[b", "@block.outer")
		jump_prev_end_map("[B", "@block.outer")

		local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"

		-- Repeat movement with ; and ,
		-- ensure ; goes forward and , goes backward regardless of the last direction
		-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
		-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

		-- vim way: ; goes to the direction you were moving.
		vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
		vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

		-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
		vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
	end
}
