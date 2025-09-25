-- find more icons here: https://www.nerdfonts.com/cheat-sheet
local kind_icons = {
	Text = "󰉿",
	Method = "󰆧",
	Function = "󰊕",
	Constructor = "",
	Field = "󰜢",
	Variable = "󰀫",
	Class = "󰠱",
	Interface = "",
	Module = "",
	Property = "󰜢",
	Unit = "󰑭",
	Value = "󰎠",
	Enum = "",
	Keyword = "󰌋",
	Snippet = "",
	Color = "󰏘",
	File = "󰈙",
	Reference = "󰈇",
	Folder = "󰉋",
	EnumMember = "",
	Constant = "󰏿",
	Struct = "󰙅",
	Event = "",
	Operator = "󰆕",
	TypeParameter = "",
}


local function cmp_config()
	local cmp = require("cmp")
	local cmpmap = cmp.mapping
	require("luasnip.loaders.from_vscode").lazy_load()

	cmp.setup({
		snippet = { -- for snippets, see the README of the pluging github
			expand = function(args)
				require('luasnip').lsp_expand(args.body)
			end,
		},
		mapping = { -- key mappings
			["<C-k>"] = cmpmap.select_prev_item(),
			["<C-j>"] = cmpmap.select_next_item(),
			["<C-b>"] = cmpmap(cmp.mapping.scroll_docs(-1), { "i", "c" }),
			["<C-f>"] = cmpmap(cmp.mapping.scroll_docs(1), { "i", "c" }),
			["<C-Space>"] = cmpmap(cmp.mapping.complete(), { "i", "c" }),
			["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
			["<C-e>"] = cmpmap({
				i = cmpmap.abort(),
				c = cmpmap.close(),
			}),
			-- Accept currently selected item. If none selected, `select` first item.
			-- Set `select` to `false` to only confirm explicitly selected items.
			-- Set behavior=cmp.ConfirmBehavior.Replace if you want to replace surounding text
			["<CR>"] = cmpmap.confirm({ select = true }),
			["<Tab>"] = cmpmap(function(fallback)
				local luasnip = require('luasnip')
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expandable() then
					luasnip.expand()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		},
		formatting = { -- format of the completion box
			fields = { "kind", "abbr", "menu" },
			format = function(entry, vim_item)
				-- if entry.source.name == 'marksman' then
				-- 	vim_item.abbr = vim_item.abbr:gsub("^/", "")
				-- 	vim_item.insertText = vim_item.insert_text:gsub("^/", "")
				-- 	vim_item.word = vim_item.word:gsub("^/", "")
			 --    end

				-- menu value
				-- entry.source.name might also be interesting
				-- vim_item.menu = string.format("(%s)", vim_item.kind)
				vim_item.menu = string.format("%12s [%s]",
					string.format("(%s)", vim_item.kind),
					entry.source.name
				)
				-- Kind icon
				vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
				return vim_item
			end,
		},
		sources = { -- sources for completion, order in which they appear
			{ name = "nvim_lsp" },
			{ name = "buffer" },
			{ name = "luasnip" },
			{ name = "nvim_lua" },
			{ name = "path" },
			-- {
			-- 	name = "marksman",
			-- 	-- entry_filter = function(entry)
			-- 	-- -- Limpiamos el contenido antes de que llegue a cmp
			-- 	-- local cleaned = entry.completion_item.label:gsub("^[/\\]+", "")
			-- 	-- entry.completion_item.label = cleaned
			-- 	-- entry.completion_item.insertText = cleaned
			-- 	-- return true
			-- 	--  end
			-- }
		},
		window = { -- completion window aesthetics
			documentation = cmp.config.window.bordered(),
			--completion = cmp.config.window.bordered(),
		},
		experimental = {
			ghost_text = false,
			native_menu = false,
		},
	})
end

return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- Most of these allow nvim-cmp to use different sources of
			-- information for completion
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lua",
			{
				"L3MON4D3/LuaSnip",
				dependencies = { "rafamadriz/friendly-snippets" }
			},
			"saadparwaiz1/cmp_luasnip",
		},
		config = cmp_config,
	},
}
