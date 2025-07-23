local augLspFormatting = vim.api.nvim_create_augroup("LspFormatting", {})

local format_filters = {
	lua = function (client)
		local stylua_conf = vim.fs.find({ "stylua.toml", ".stylua.toml" }, {
			upward = true,
			stop = vim.fs.dirname(client.config.root_dir),
			path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
		})
		stylua_conf = #stylua_conf
		return client.name == "null-ls" and stylua_conf > 0 or
			client.name == "lua_ls" and stylua_conf == 0
	end,
	tex = function (client)
		-- FIXME: find good formater for latex and configure it
		return false
	end
}

-- on_attach callback, regitered below to be executed when a buffer is attached
-- to an lsp server. It can be used to change configuration on the buffer:
--     keymaps, nvim options, autocommands, etc.
--  Alternative: set a autocommand for the LspAttach event
local function on_attach(client, bufnr)
	-- See :h vim.lsp.* or vim.diagnostic.* for documentation on any of the
	-- below functions
	local mappings = {
		n = {
			["<leader>lr"] = vim.lsp.buf.rename,
			["<leader>la"] = vim.lsp.buf.code_action,
			["<leader>ld"] = vim.diagnostic.open_float,
			["<leader>ll"] = vim.diagnostic.setloclist,
			["<A-k>"] = vim.lsp.buf.hover,
			["<A-j>"] = vim.lsp.buf.signature_help,
			["gD"] = vim.lsp.buf.declaration,
			["gd"] = vim.lsp.buf.definition,
			["gi"] = vim.lsp.buf.implementation,
			["gr"] = vim.lsp.buf.references,
			["[d"] = vim.diagnostic.goto_prev,
			["]d"] = vim.diagnostic.goto_next,
			["gl"] = vim.diagnostic.open_float,
		},
	}

	local augrp = vim.api.nvim_create_augroup
	local aucmd = vim.api.nvim_create_autocmd
	local augrp_clear = vim.api.nvim_clear_autocmds

	-- If server provides highlight capabilities, highlight the word under
	-- cursor when cursor stops and reset when it moves again
	if client.server_capabilities.documentHighlightProvider then
		local id = augrp("lsp_document_highlight", { clear = false })
		augrp_clear({ buffer = bufnr, group = id })
		aucmd({ "CursorHold" }, {
			buffer = bufnr,
			group = id,
			callback = vim.lsp.buf.document_highlight,
		})
		aucmd({ "CursorMoved" }, {
			buffer = bufnr,
			group = id,
			callback = vim.lsp.buf.clear_references,
		})
	end

	if client.server_capabilities.documentFormattingProvider then
		-- if client.supports_method("textDocument/formatting") then
		local format = function ()
			vim.lsp.buf.format({
				bufnr = bufnr,
				filter = format_filters[vim.bo.filetype],
			})
		end
		vim.api.nvim_clear_autocmds({
			group = augLspFormatting,
			buffer = bufnr,
		})
		-- vim.api.nvim_create_autocmd("BufWritePre", {
		-- 	group = augLspFormatting,
		-- 	buffer = bufnr,
		-- 	callback = format,
		-- })

		mappings[{ "n", "v" }] = {
			["<leader>lf"] = format,
		}
		vim.api.nvim_buf_create_user_command(bufnr, "Format", format, {})
	end
	require("keymaps").set_mappings(mappings, { silent = true, buffer = bufnr })
end

local function server_setup(server_name)
	-- see :h vim.lsp.start_client() for possible setup options
	local opts = {
		capabilities = { offsetEncoding = { "utf-16" } },
		on_attach = on_attach,
		-- see https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#borders
		handlers = {
			["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover,
				{ border = "rounded", max_width = 80 }),
			["textDocument/signatureHelp"] = vim.lsp.with(
				vim.lsp.handlers.signature_help,
				{ border = "rounded", max_width = 80 }
			),
		},
	}

	-- add completion capabilities
	local has_cmp, cmp_nvim = pcall(require, "cmp_nvim_lsp")
	if has_cmp then
		opts.capabilities = vim.tbl_extend("force", opts.capabilities,
			cmp_nvim.default_capabilities())
	end

	-- overimpose server specific options
	local file = "plugins.lsp_server_options." .. server_name
	local has_opts, server_opts = pcall(require, file)
	if has_opts then
		for k,v in pairs(server_opts) do
			if opts[k] and type(opts[k]) == "table" then
				opts[k] = vim.tbl_extend("force", opts[k], v)
			else
				opts[k] = v
			end
		end
	end

	require("lspconfig")[server_name].setup(opts)
end

-- This does not work, apparently returning nil from root_dir function does not
-- avavoid the connection
-- local function null_ls_root_dir(filename, bufnr)
-- 	local u = require("null-ls.utils")
-- 	local rdf = u.root_pattern(".null-ls-root", "Makefile", ".git")
-- 	local root_dir = rdf(filename, bufnr)
-- 	local ft = vim.filetype.match({ filename = filename })
-- 	if ft == "lua" then
-- 		local stylua_conf = vim.fs.find({ "stylua.toml", ".stylua.toml" }, {
-- 			upward = true,
-- 			stop = vim.fs.dirname(root_dir),
-- 			path = vim.fs.dirname(filename),
-- 		})
-- 		if #stylua_conf == 0 then
-- 			root_dir = nil
-- 		end
-- 	end
-- 	return root_dir
-- end

return {
	{ -- Package manager for lsp servers, dap servers, linters and formatters
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		lazy = false,
		opts = {
			ui = {
				icons = {
					package_installed = "",
					package_pending = "",
					package_uninstalled = "",
				},
			},
		},
	},
	{ -- Binding between lspconfig and mason
		-- allows for automatic installation of selected list of servers
		-- allows for automatic configuration of lsp servers
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			automatic_installation = true, -- automatically install servers configured in lspconfig
			ensure_installed = {  -- install theses servers automatically if they are not installed already
				"cmake",          -- or neocmake?
				"bashls",
				"clangd",
				"pyright",
				"jsonls",
				"texlab",
				"lua_ls", -- TODO: have a look to luau_lsp
				"vimls",
				"ltex", -- TODO: compare ltex and texlab
				-- "marksman",
			},
			handlers = { -- for automatic server configuration
				-- default handler, see lspconfig-quickstart and
				-- https://github.com/neovim/nvim-lspconfig/wiki
				server_setup,
				-- you can add specific functions for each lsp server using
				-- lspconfig name for the key, but with the above function
				-- specific options for the server can be added to the options
				-- directory
			},
		},
	},
	{ -- Configuration of lsp servers
		"neovim/nvim-lspconfig",
		dependcencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig",
		},
		config = function ()
			-- see https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
			-- #change-diagnostic-symbols-in-the-sign-column-gutter
			local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
			for k, v in pairs(signs) do
				local hl = "DiagnosticSign" .. k
				vim.fn.sign_define(hl, { text = v, texthl = hl, numhl = "" })
			end

			-- #customizing-how-diagnostics-are-displayed
			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				update_in_insert = false,
				underline = true,
				severity_sort = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})
		end,
	},
	-- { -- Configuration for non-LSP-aware linters and formatters
	-- 	"nvimtools/none-ls.nvim",
	-- 	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	-- 	config = function (_, opts)
	-- 		local null_ls = require("null-ls")
	-- 		local builtins = null_ls.builtins
	--
	-- 		null_ls.setup({
	-- 			debug = false,
	-- 			sources = {
	-- 				-- builtins.formatting.prettier.with({
	-- 				-- 	extra_args = {
	-- 				-- 		"--no-semi",
	-- 				-- 		"--single-quote",
	-- 				-- 		"--jsx-single-quote",
	-- 				-- 	},
	-- 				-- }),
	-- 				builtins.formatting.stylua, -- for lua files
	-- 				-- builtins.formatting.black.with({ extra_args = { "--fast" } }), -- for python files
	-- 				-- builtins.diagnostics.flake8,                    -- for python files
	-- 				-- builtins.code_actions.gitsigns,
	-- 			},
	-- 			-- root_dir = null_ls_root_dir,
	-- 		})
	-- 	end,
	-- },
}
