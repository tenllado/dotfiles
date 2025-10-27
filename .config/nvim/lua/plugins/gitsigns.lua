return {
	"lewis6991/gitsigns.nvim",
	opts = {
		on_attach = function (bufnr)
			local gs = require('gitsigns')

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
			vim.keymap.set({"n", "v"}, "<leader>hr", ":Gitsigns reset_hunk<CR>")
			vim.keymap.set({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>")
		end,
	},
}
