return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		opts = {
			close_if_last_window = false,
			popup_border_style = "rounded",
			sources = {
				"filesystem",
				"git_status",
				"document_symbols",
			},
			default_component_configs = {
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "",
					default = "*",
					highlight = "NeoTreeFileIcon",
				},
				modified = {
					highlight = "NeoTreeNormal",
				},
				name = {
					trailing_slash = true,
				},
				git_status = {
					symbols = {
						-- Change type
						added = "✚",
						modified = "",
						deleted = "✖",
						renamed = "",
						-- Status type
						untracked = "",
						ignored = "",
						unstaged = "",
						staged = "",
						conflict = "",
					},
				},
			},
			window = {
				position = "current",
				width = 30, -- for left/right trees
				mappings = {
					["<space>"] = {
						"toggle_node",
						nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
					},
					["<2-LeftMouse>"] = "open",
					["<cr>"] = "open",
					["<esc>"] = "revert_preview",
					["P"] = { "toggle_preview", config = { use_float = true } },
					["l"] = "focus_preview",
					["s"] = "open_split",
					["v"] = "open_vsplit",
					["S"] = "split_with_window_picker",
					["V"] = "vsplit_with_window_picker",
					["t"] = "open_tabnew",
					-- ["<cr>"] = "open_drop",
					-- ["t"] = "open_tab_drop",
					["w"] = "open_with_window_picker",
					--["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
					["C"] = "close_node",
					-- ['C'] = 'close_all_subnodes',
					["z"] = "close_all_nodes",
					["Z"] = "expand_all_nodes",
					["a"] = {
						"add",
						-- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
						-- some commands may take optional config options, see `:h neo-tree-mappings` for details
						config = {
							show_path = "none", -- "none", "relative", "absolute"
						},
					},
					["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
					["d"] = "delete",
					["r"] = "rename",
					["y"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
					-- ["c"] = {
					--  "copy",
					--  config = {
					--    show_path = "none" -- "none", "relative", "absolute"
					--  }
					--}
					["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
					["q"] = "close_window",
					["R"] = "refresh",
					["?"] = "show_help",
					["<"] = "none", -- "prev_source",
					[">"] = "none", -- "next_source",
				},
				mapping_options = {
					noremap = true,
					nowait = true,
				},
			},
			filesystem = {
				hijack_netrw_behavior = "open_current",
				window = {
					mappings = {
						["<bs>"] = "navigate_up",
						["-"] = "navigate_up", -- netrw
						["."] = "set_root",
						["H"] = "toggle_hidden",
						["/"] = "fuzzy_finder",
						["D"] = "fuzzy_finder_directory",
						-- 				["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
						-- 				["f"] = "filter_on_submit",
						-- 				["<c-x>"] = "clear_filter",
						["[g"] = "prev_git_modified",
						["]g"] = "next_git_modified",
					},
					-- 			fuzzy_finder_mappings = {
					-- 				-- define keymaps for filter popup window in fuzzy_finder_mode
					-- 				["<down>"] = "move_cursor_down",
					-- 				["<C-n>"] = "move_cursor_down",
					-- 				["<up>"] = "move_cursor_up",
					-- 				["<C-p>"] = "move_cursor_up",
					-- 			},
				},
			},
			git_status = {
				window = {
					position = "float",
					mappings = {
						["A"] = "git_add_all",
						["gu"] = "git_unstage_file",
						["ga"] = "git_add_file",
						["gr"] = "git_revert_file",
						["gc"] = "git_commit",
						["gp"] = "git_push",
						["gg"] = "git_commit_and_push",
					},
				},
			},
			document_symbols = {
				window = {
					mappings = {
						["<cr>"] = "jump_to_symbol",
						["o"] = "jump_to_symbol",
					},
				},
			},
		},
		config = function(_, opts)
			vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
			require("neo-tree").setup(opts)

			local mappings = {
				n = {
					["<leader>nc"] = ":Neotree focus current<cr>",
					["<leader>nr"] = ":Neotree focus right<cr>",
					["<leader>nl"] = ":Neotree focus left<cr>",
					["<leader>nf"] = ":Neotree focus float<cr>",
					["<leader>ns"] = ":Neotree focus right document_symbols<cr>",
					["<leader>nn"] = ":Neotree reveal<cr>",
				},
			}
			require('keymaps').set_mappings(mappings)
		end,
	},
}
