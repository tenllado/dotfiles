return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		opts = {
			-- ensure_installed = "all", -- all or a list of languages
			ensure_installed = {
				"c",
				"cpp",
				"cmake",
				"lua",
				"vim",
				"vimdoc",
				"bash",
				"diff",
				"python",
				"bibtex",
				"devicetree",
				"dockerfile",
				"doxygen",
				"git_config",
				"git_rebase",
				"gitignore",
				"gitcommit",
				"gnuplot",
				"json",
				"kconfig",
				-- "latex",
				"make",
				"printf",
				"verilog",
				"yaml",
			},
			sync_install = false,
			auto_install = false,              -- if true you need to have the cli tree-sitter tool installed in your system
			ignore_install = { "" },           -- List of parsers to ignore installing
			highlight = {
				enable = true,                 -- enable treesitter for highlighting
				additional_vim_regex_highlighting = false, -- see the readme
				use_languagetree = false,
				-- disable = function(lang, bufnr)
				-- 	local buf_name = vim.api.nvim_buf_get_name(bufnr)
				-- 	local file_size = vim.api.nvim_call_function("getfsize", { buf_name })
				-- 	-- return file_size > 256 * 1024
				-- 	return true
				-- end,
			},
			incremental_selection = {
				enable = true, -- enable treesitter for incremental search
				keymaps = {
					init_selection = "gnn", -- set to `false` to disable one of the mappings
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},
			indent = { -- indentation based on treesitter for = operator
				enable = true,
				disable = { "yaml", "c", "cpp" },
			},
			autopairs = {
				enable = true,
			},
		},
		config = function (_, opts)
			require("nvim-treesitter.configs").setup(opts)
			-- Using treesitter to create folds based on language expressions
			-- It respects the foldminlines and foldnestmax settings
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			vim.opt.foldenable = false
		end,
		build = function ()
			require("nvim-treesitter.install").update({ with_sync = true })()
		end,
	},
	{
		-- Define your own text objects mappings similar to ip (inner paragraph)
		-- and ap (a paragraph).
		"nvim-treesitter/nvim-treesitter-textobjects",
		opts = {
			textobjects = {
				select = {
					enable = true,
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["af"] = { query = "@function.outer", desc = "Select around function" },
						["if"] = { query = "@function.inner", desc = "Select inside function" },
						["ac"] = { query = "@class.outer", desc = "Select around class definition" },
						["ic"] = { query = "@class.inner", desc = "Select inside class definition" },
						["am"] = { query = "@comment.outer", desc = "Select around comment" },
						["aa"] = { query = "@parameter.outer", desc = "Select around parameter" },
						["ia"] = { query = "@parameter.inner", desc = "Select inside parameter" },
						["al"] = { query = "@loop.outer", desc = "Select around loop" },
						["il"] = { query = "@loop.inner", desc = "Select inside loop" },
						["ab"] = { query = "@block.outer", desc = "Select around block" },
						["ad"] = { query = "@conditional.outer", desc = "Select around conditional" },
						["id"] = { query = "@conditional.inner", desc = "Select inside conditional" },
						-- You can also use captures from other query groups like `locals.scm`
						["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
					},
					-- You can choose the select mode (default is charwise 'v')
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * method: eg 'v' or 'o'
					-- and should return the mode ('v', 'V', or '<c-v>') or a table
					-- mapping query_strings to modes.
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						["@loop.outer"] = "V", -- linewise
						["@loop.inner"] = "V", -- linewise
						["@class.outer"] = "<c-v>", -- blockwise
						["@block.outer"] = "v", -- charwise
						["@conditional.outer"] = "V", -- linewise
						["@conditional.inner"] = "V", -- linewise
					},
					include_surrounding_whitespace = false, -- can also be a function
				},
				swap = {
					-- swap nodes of the treesitter AST with next or previous
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					-- use goto_next instead to go to either the start or the
					-- end, whichever is closer.
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = { query = "@class.outer", desc = "Next class start" },
						["]l"] = "@loop.*",
						["]d"] = "@conditional.inner",
						["]b"] = "@block.outer",
						["]a"] = "@parameter.inner",
						--
						-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
						-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
						["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
						["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
					},
					goto_next_end = {
						["]F"] = "@function.outer",
						["]C"] = "@class.outer",
						["]L"] = "@loop.*",
						["]D"] = "@conditional.inner",
						["]B"] = "@block.outer",
						["]A"] = "@parameter.inner",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[l"] = "@loop.*",
						["[d"] = "@conditional.outer",
						["[b"] = "@block.outer",
						["[a"] = "@parameter.inner",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[C"] = "@class.outer",
						["[L"] = "@loop.*",
						["[D"] = "@conditional.outer",
						["[B"] = "@block.outer",
						["[A"] = "@parameter.inner",
					},
				},
			},
		},
		config = function (_, opts)
			require("nvim-treesitter.configs").setup(opts)

			-- local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
			--
			-- local mappings = {
			-- 	[{ "n", "x", "o" }] = {
			-- Problem: breaks default ; and , behavior
			-- 		[";"] = ts_repeat_move.repeat_last_move_next,
			-- 		[","] = ts_repeat_move.repeat_last_move_previous,
			-- 		-- alternative vim way: ; goes to the direction you were moving.
			-- 		-- [";"] = ts_repeat_move.repeat_last_move,
			-- 		-- [","] = ts_repeat_move.repeat_last_move_opposite,
			-- 		--
			-- 		-- Issue: https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/519
			-- 		-- when enabling these mappings . does not repeat a movement
			-- 		-- like dt<space>. I remove these mappings till it is fixed
			-- 		-- ["f"] = ts_repeat_move.builtin_f,
			-- 		-- ["F"] = ts_repeat_move.builtin_F,
			-- 		-- ["t"] = ts_repeat_move.builtin_t,
			-- 		-- ["T"] = ts_repeat_move.builtin_T,
			-- 	},
			-- }
			-- require("keymaps").set_mappings(mappings)
		end,
		lazy = true,
	},
}
