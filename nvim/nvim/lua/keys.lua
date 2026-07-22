
-- quick open
vim.keymap.set("n", "<leader>o", function ()
    require("telescope").extensions.smart_open.smart_open({ cwd_only = true })
end, { noremap = true, silent = true })

-- random niceties
vim.keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Hide search highlight' })

-- lsp keys
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local opts = { buffer = args.buf }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)      -- go to definition
        vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)       -- hover docs
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)      -- find references
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)  -- rename
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts) -- code action
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)    -- prev diagnostic
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)    -- next diagnostic

        -- autocompletion (native, 0.11+)
        -- local client = vim.lsp.get_client_by_id(args.data.client_id)
        -- if client and client:supports_method('textDocument/completion') then
        --     vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        -- end
    end,
})

vim.keymap.set('n', '<leader>r', '<cmd>Telescope lsp_document_symbols<CR>',           { desc = 'Document symbols' })
vim.keymap.set('n', '<leader>t', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>',  { desc = 'Workspace symbols' })

-- file tree
vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle reveal<CR>', { desc = 'Toggle file tree with reveal' })

-- panes
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('n', '<leader>sk', '<cmd>aboveleft split<CR>',   { desc = 'Split above' })
vim.keymap.set('n', '<leader>sj', '<cmd>belowright split<CR>',  { desc = 'Split below' })
vim.keymap.set('n', '<leader>sh', '<cmd>aboveleft vsplit<CR>',  { desc = 'Split left' })
vim.keymap.set('n', '<leader>sl', '<cmd>belowright vsplit<CR>', { desc = 'Split right' })

vim.keymap.set('n', '<C-S-Up>',    '<cmd>resize +2<CR>')
vim.keymap.set('n', '<C-S-Down>',  '<cmd>resize -2<CR>')
vim.keymap.set('n', '<C-S-Left>',  '<cmd>vertical resize -2<CR>')
vim.keymap.set('n', '<C-S-Right>', '<cmd>vertical resize +2<CR>')

-- git
vim.keymap.set('n', '<leader>gl', '<cmd>DiffviewFileHistory<CR>', { desc = 'git lg' })
require('diffview').setup({
    keymaps = {
        view = {
            { 'n', 'q', '<cmd>DiffviewClose<CR>', { desc = 'Close diffview' } },
        },
        file_panel = {
            { 'n', 'q', '<cmd>DiffviewClose<CR>', { desc = 'Close diffview' } },
        },
        file_history_panel = {
            { 'n', 'q', '<cmd>DiffviewClose<CR>', { desc = 'Close diffview' } },
        },
    },
})
