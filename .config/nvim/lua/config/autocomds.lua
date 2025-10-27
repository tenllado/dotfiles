-- Change cocealevel to 2 for markdown files when opening the file
local ag_conceal = vim.api.nvim_create_augroup("conceal", { clear = true })
vim.api.nvim_create_autocmd({"BufNew", "BufNewFile" }, {
	pattern = { "*.md" },
	command = "setlocal conceallevel=2",
	group = ag_conceal,
	desc = "set conceallevel=2 for markdown files",
})

--- LSP setup    --------------------------------------------------------------
local format_filters = {
	lua = function (client)
		local stylua_conf = vim.fs.find({ "stylua.toml", ".stylua.toml" }, {
			upward = true,
			stop = vim.fs.dirname(client.config.root_dir),
			path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
		})
		return client.name == "null-ls" and #stylua_conf > 0 or
			client.name == "lua_ls" and #stylua_conf == 0
	end,
}

local function onLspAttach(args)
	local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
	if client:supports_method("textDocument/completion") then
		vim.lsp.completion.enable(true, client.id, args.buf,
			{ autotrigger = true })
	end

	-- Disable default gr mappings (:h lsp-default)
	vim.cmd([[nnoremap <nowait> gr gr]])

	local nmap = function(keys, func, desc)
	    vim.keymap.set('n', keys, func, { buffer = args.buf, desc = 'Lsp: ' .. desc })
	end
	local vmap = function(keys, func, desc)
	    vim.keymap.set('v', keys, func, { buffer = args.buf, desc = 'Lsp: ' .. desc })
	end

	-- New mappings
	nmap("<leader>lr", vim.lsp.buf.rename, "[r]ename")
	nmap("<leader>la", vim.lsp.buf.code_action, "code [a]ction")
	vmap("<leader>la", vim.lsp.buf.code_action, "code [a]ction")
	nmap("<leader>lu", vim.lsp.buf.references, "references/[u]ses")
	nmap("<leader>li", vim.lsp.buf.implementation, "go to [i]mplementation")
	nmap("<leader>lt", vim.lsp.buf.type_definition, "[t]ype definition")
	nmap("gD", vim.lsp.buf.declaration, "go to [D]eclaration")
	nmap("gd", vim.lsp.buf.definition, "go to [d]efinition")
	nmap("<A-k>", vim.lsp.buf.hover, "hover info")
	nmap("<A-j>", vim.lsp.buf.signature_help, "help doc")
	nmap("<leader>dl", vim.diagnostic.setloclist, "diagnostics in loclist")
	nmap("<leader>df", vim.diagnostic.open_float, "diagnostics in float win")

	-- Mappings using telescope
	local tele = require("telescope.builtin")
	if tele then
		nmap('<leader>fld', tele.lsp_definitions, 'telescope go definition')
		nmap('<leader>fls', tele.lsp_document_symbols, 'telescope doc symbols')
		nmap('<leader>flS', tele.lsp_dynamic_workspace_symbols, 'telescope dynamic symbols')
		nmap('<leader>flt', tele.lsp_type_definitions, 'telescope type')
		nmap('<leader>flr', tele.lsp_references, 'telescope references')
		nmap('<leader>fli', tele.lsp_implementations, 'telescope implementation')
	end

	-- Highlight word under cursor on hold
	if client:supports_method('textDocument/documentHighlight') then
		local aug = vim.api.nvim_create_augroup("LspConfig", { clear = false })
		vim.api.nvim_create_autocmd({ "CursorHold" }, {
			buffer = args.buf,
			group = aug,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved" }, {
			buffer = args.buf,
			group = aug,
			callback = vim.lsp.buf.clear_references,
		})
	end

	if client:supports_method("textDocument/formatting") then
		local format = function ()
			vim.lsp.buf.format({
				bufnr = args.buf,
				filter = format_filters[vim.bo.filetype],
			})
		end
		vim.keymap.set({ "n", "v" }, "<leader>lf", format, opts)
		vim.api.nvim_buf_create_user_command(args.buf, "Format", format, {})
	end

	-- for future reference, for setting up debug adapter protocol (dap)
	--        local dap = require('dap')
	--        map('<leader>dt', dap.toggle_breakpoint, 'Toggle Break')
	--        map('<leader>dc', dap.continue, 'Continue')
	--        map('<leader>dr', dap.repl.open, 'Inspect')
	--        map('<leader>dk', dap.terminate, 'Kill')
	--
	--        map('<leader>dso', dap.step_over, 'Step Over')
	--        map('<leader>dsi', dap.step_into, 'Step Into')
	--        map('<leader>dsu', dap.step_out, 'Step Out')
	--        map('<leader>dl', dap.run_last, 'Run Last')
	--
	--        local dapui = require('dapui')
	--        map('<leader>duu', dapui.open, 'open ui')
	--        map('<leader>duc', dapui.close, 'open ui')
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspConfig", {}),
	callback = onLspAttach,
})

---- LSP setup end  -----------------------------------------------------------
