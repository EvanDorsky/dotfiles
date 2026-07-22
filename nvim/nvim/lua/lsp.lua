
-- treesitter
require('nvim-treesitter').install({ 'lua', 'go', 'gomod', 'gosum', 'gowork' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go', 'gomod', 'gosum', 'gowork', 'lua' },
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- sticky header showing the function/type the cursor is inside
require('treesitter-context').setup({
  enable = true,
  mode = 'cursor',           -- context of the cursor's scope, not the top visible line
  max_lines = 3,             -- cap the header height
  multiline_threshold = 1,   -- collapse multi-line signatures to their first line
  trim_scope = 'outer',      -- when over max_lines, drop the outermost scopes
  separator = '─',
})

vim.keymap.set('n', '[c', function()
  require('treesitter-context').go_to_context(vim.v.count1)
end, { silent = true, desc = 'Jump to enclosing context' })

vim.keymap.set('n', '<leader>uc', '<cmd>TSContext toggle<CR>', { desc = 'Toggle context header' })

-- golang
vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },
})
vim.lsp.enable('gopls')

-- highlight other instances of the symbol under the cursor
vim.opt.updatetime = 100
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight') then
      local grp = vim.api.nvim_create_augroup('lsp_doc_highlight', { clear = false })
      vim.api.nvim_clear_autocmds({ group = grp, buffer = args.buf })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = grp, buffer = args.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd('CursorMoved', {
        group = grp, buffer = args.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.go', 'go.mod' },
  callback = function()
    local clients = vim.lsp.get_clients({ bufnr = 0, name = 'gopls' })
    if not clients[1] then return end
    local enc = clients[1].offset_encoding or 'utf-16'

    -- organize imports: only meaningful for .go source
    if vim.bo.filetype == 'go' then
      local params = vim.lsp.util.make_range_params(0, enc)
      params.context = { only = { 'source.organizeImports' } }
      local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 1000)
      for _, res in pairs(result or {}) do
        for _, action in pairs(res.result or {}) do
          if action.edit then
            vim.lsp.util.apply_workspace_edit(action.edit, enc)
          end
        end
      end
    end

    -- formatting: applies to both go and gomod
    vim.lsp.buf.format({ async = false })
  end,
})

