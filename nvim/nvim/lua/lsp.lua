
-- treesitter
require('nvim-treesitter').install({ 'lua', 'go', 'gomod', 'gosum', 'gowork', 'svelte', 'typescript', 'javascript', 'css', 'html', 'c', 'cpp', 'python' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go', 'gomod', 'gosum', 'gowork', 'lua', 'svelte', 'typescript', 'javascript', 'css', 'html', 'c', 'cpp', 'python' },
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

-- svelte + typescript
vim.lsp.config('svelte', {
  cmd = { 'svelteserver', '--stdio' },
  filetypes = { 'svelte' },
  root_markers = { 'package.json', '.git' },
})
vim.lsp.enable('svelte')

vim.lsp.config('vtsls', {
  cmd = { 'vtsls', '--stdio' },
  filetypes = { 'typescript', 'javascript' },
  root_markers = { 'tsconfig.json', 'package.json', '.git' },
})
vim.lsp.enable('vtsls')

-- python
vim.lsp.config('pylsp', {
  cmd = { 'pylsp' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
  -- no lint diagnostics; pylsp is just for completion/navigation/hover
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
        mccabe = { enabled = false },
        pylint = { enabled = false },
        flake8 = { enabled = false },
        pydocstyle = { enabled = false },
      },
    },
  },
  -- point jedi at the project's .venv (uv doesn't activate it, so
  -- VIRTUAL_ENV is usually unset when nvim starts)
  before_init = function(_, config)
    local venv = config.root_dir and config.root_dir .. '/.venv'
    if venv and vim.uv.fs_stat(venv .. '/bin/python') then
      config.settings = vim.tbl_deep_extend('force', config.settings or {}, {
        pylsp = { plugins = { jedi = { environment = venv } } },
      })
    end
  end,
})
vim.lsp.enable('pylsp')

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

-- svelte formatting on save (server formats via prettier-plugin-svelte,
-- respecting the project's prettier config)
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.svelte' },
  callback = function()
    if not vim.lsp.get_clients({ bufnr = 0, name = 'svelte' })[1] then return end
    vim.lsp.buf.format({ async = false })
  end,
})

-- c/c++ (also covers PlatformIO projects; run `pio run -t compiledb` in the
-- project root to generate compile_commands.json so clangd picks up the
-- board's include paths and defines)
vim.lsp.config('clangd', {
  cmd = {
    'clangd',
    '--background-index',
    -- let clangd interrogate PlatformIO cross-compilers (xtensa/riscv) for
    -- their built-in include paths instead of assuming the host compiler's
    '--query-driver=' .. vim.fn.expand('~') .. '/.platformio/packages/toolchain-*/bin/*',
  },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  root_markers = { 'compile_commands.json', 'compile_flags.txt', '.clangd', 'platformio.ini', '.git' },
})
vim.lsp.enable('clangd')
