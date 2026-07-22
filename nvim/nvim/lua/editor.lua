
-- splash
vim.opt.shortmess:append('I')

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true    -- spaces not tabs
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.signcolumn = 'yes:2'

-- treesitter
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldenable = false   -- start with folds open, don't auto-fold on open

-- lualine
local c = require('ayu.colors')
c.generate(true)

local theme = require('lualine.themes.ayu')
theme.normal.a.bg = c.gutter_active
theme.normal.b.bg = c.gutter_normal
theme.normal.c.bg = c.bg
for _, mode in ipairs({ 'insert', 'visual', 'replace', 'command', 'inactive' }) do
  theme[mode] = theme.normal
end
require('lualine').setup {
    options = {
        theme = theme,
        icons_enabled = true,
        section_separators = { left = '', right = '' },
        -- component_separators = {  left = '', right = '' },
        component_separators = { left = '', right = '' },
    },
    sections = {
        lualine_a = { 'branch', 'diff' },
        lualine_b = { 'filename' },
        lualine_c = { 'diagnostics' },
        lualine_x = { 'searchcount' },
        lualine_y = { 'filetype', 'lsp_status' },
        lualine_z = { 'hostname' },
    }
}

-- neo-tree
require('neo-tree').setup {
    close_if_last_window = true,
    filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
    },
    window = {
        width = 32,
    },
}

-- blink
require('blink.cmp').setup {
    keymap = {
        preset = 'default',
        ['<Tab>']  = { 'accept', 'fallback' },
        ['<C-j>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'snippet_backward', 'fallback' },
    },
    completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 100 },
        menu = { border = 'rounded' },
        ghost_text = { enabled = true },
    },
    signature = { enabled = true },
    sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    snippets = { preset = 'default' },
}
