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

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end

		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename)
		vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action)
		vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float)
		vim.keymap.set("n", "<leader>ll", vim.diagnostic.setloclist)
		vim.keymap.set("n", "<A-k>", vim.lsp.buf.hover)
		vim.keymap.set("n", "<A-j>", vim.lsp.buf.signature_help)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
		vim.keymap.set("n", "gr", vim.lsp.buf.references)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
		vim.keymap.set("n", "gl", vim.diagnostic.open_float)

		local augrp = vim.api.nvim_create_augroup
		local augrp_clear = vim.api.nvim_clear_autocmds
		local aucmd = vim.api.nvim_create_autocmd

		-- If server provides highlight capabilities, highlight the word under
		-- cursor when cursor stops and reset when it moves again
		local group = augrp("UserLspConfig", { clear = false })
		--augrp_clear({ buffer = ev.buf, group = group })
		if client.server_capabilities.documentHighlightProvider then
			aucmd({ "CursorHold" }, {
				buffer = ev.buf,
				group = group,
				callback = vim.lsp.buf.document_highlight,
			})
			aucmd({ "CursorMoved" }, {
				buffer = ev.buf,
				group = group,
				callback = vim.lsp.buf.clear_references,
			})
		end

		if client.server_capabilities.documentFormattingProvider then
			local format = function ()
				vim.lsp.buf.format({
					bufnr = ev.buf,
					filter = format_filters[vim.bo.filetype],
				})
			end
			--vim.api.nvim_clear_autocmds({
			--	group = group,
			--	buffer = ev.buf,
			--})
			-- vim.api.nvim_create_autocmd("BufWritePre", {
			-- 	group = group,
			-- 	buffer = bufnr,
			-- 	callback = format,
			-- })

			vim.keymap.set({"n", "v"}, "<leader>lf", format)
			vim.api.nvim_buf_create_user_command(ev.buf, "Format", format, {})
		end

--        local map = function(keys, func, desc)
--            vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = 'Lsp: ' .. desc })
--        end
--
--        local tele = require("telescope.builtin")
--        map('gd', tele.lsp_definitions, 'Goto Definition')
--        map('<leader>fs', tele.lsp_document_symbols, 'Doc Symbols')
--        map('<leader>fS', tele.lsp_dynamic_workspace_symbols, 'Dynamic Symbols')
--        map('<leader>ft', tele.lsp_type_definitions, 'Goto Type')
--        map('<leader>fr', tele.lsp_references, 'Goto References')
--        map('<leader>fi', tele.lsp_implementations, 'Goto Impl')
--
--        map('K', vim.lsp.buf.hover, 'hover')
--        map('<leader>E', vim.diagnostic.open_float, 'diagnostic')
--        map('<leader>k', vim.lsp.buf.signature_help, 'sig help')
--        map('<leader>rn', vim.lsp.buf.rename, 'rename')
--        map('<leader>ca', vim.lsp.buf.code_action, 'code action')
--        map('<leader>wf', vim.lsp.buf.format, 'format')
--
--        vim.keymap.set('v',
--            '<leader>ca',
--            vim.lsp.buf.code_action, { buffer = ev.buf, desc = 'Lsp: code_action' })
--
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
    end,
})
