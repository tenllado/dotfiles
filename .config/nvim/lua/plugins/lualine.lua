-- Lualine has sections as shown below
-- +-------------------------------------------------+
-- | A | B | C                             X | Y | Z |
-- +-------------------------------------------------+

local function fmt_branch(branch)
	return branch:len() < 15 and branch or branch:sub(1,15)
end

return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { "oil", "netrw" },
				theme = "tokyonight-day",
			},
			sections = {
				lualine_a = {
					"mode",
				},
				lualine_b = {
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
				lualine_c = {
					{
						"branch",
						icon = "",
						fmt = fmt_branch,
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						sections = { "error", "warn" },
						symbols = { error = " ", warn = " " },
						colored = false,
						update_in_insert = false,
					},
				},
				lualine_x = {
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
			tabline = {},
			extensions = {},
		},
	},
}
