-- Lualine has sections as shown below
-- +-------------------------------------------------+
-- | A | B | C                             X | Y | Z |
-- +-------------------------------------------------+

return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { "dashboard", "NvimTree", "Outline", "netrw" },
			},
			sections = {
				lualine_a = {
					{
						"branch",
						icon = "",
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						sections = { "error", "warn" },
						symbols = { error = " ", warn = " " },
						colored = false,
						update_in_insert = false,
						always_visible = true,
					},
				},
				lualine_b = {
					{
						"mode",
						fmt = function (str)
							return "-- " .. str .. " --"
						end,
					},
				},
				lualine_c = {
					{
						"filename",
						file_status = true,
						newfile_status = true,
						path = 1, -- 1: Relative path
						shorting_target = 40, -- Shortens path to leave 40 spaces in the window
						symbols = {
							modified = "[+]",
							readonly = "[-]",
							unnamed = "[No Name]",
							newfile = "[New]",
						},
					},
				},
				lualine_x = {
					{
						"diff",
						colored = false,
						symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
						cond = function ()
							return vim.fn.winwidth(0) > 80
						end,
					},
					function ()
						return "sw: " ..
							vim.api.nvim_buf_get_option(0, "shiftwidth")
					end,
					"encoding",
					{
						"fileformat",
						symbols = {
							unix = "", -- e712
							dos = "", -- e70f
							mac = "", -- e711
						},
					},
					{
						"filetype",
						icons_enabled = false,
						icon = nil,
					},
				},
				lualine_y = {
					{
						"location",
						padding = 0,
					},
				},
				lualine_z = { "%L", "progress", },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			-- winbar = {},
			-- inactive_winbar = {},
			extensions = {},
		},
	},
}
