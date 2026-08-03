
-- splash
vim.opt.shortmess:append('I')

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true    -- spaces not tabs
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.signcolumn = 'yes'

vim.opt.timeoutlen = 300

-- confine search highlighting to the focused window ('hlsearch' is global)
vim.api.nvim_set_hl(0, 'NoSearchHL', {}) -- intentionally empty, so matches render as plain text
vim.api.nvim_create_autocmd({ 'WinEnter', 'WinLeave' }, {
    group = vim.api.nvim_create_augroup('search_hl_active_win', { clear = true }),
    callback = function(ev)
        if vim.bo.buftype ~= '' then return end -- leave neo-tree etc. alone
        vim.wo.winhighlight = ev.event == 'WinLeave'
            and 'Search:NoSearchHL,CurSearch:NoSearchHL,IncSearch:NoSearchHL'
            or ''
    end,
})

-- auto-enter terminal mode when focusing a terminal pane
local term_grp = vim.api.nvim_create_augroup('term_auto_insert', { clear = true })
vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter', 'WinEnter' }, {
    group = term_grp,
    pattern = 'term://*',
    callback = function()
        vim.cmd.startinsert()
    end,
})

-- horizontal wheel events are useless in a terminal (content never
-- overflows sideways) and stray trackpad ones knock the pane out of
-- terminal mode — disable them in every mode, buffer-locally
vim.api.nvim_create_autocmd('TermOpen', {
    group = term_grp,
    pattern = 'term://*',
    callback = function(ev)
        for _, key in ipairs({ '<ScrollWheelLeft>', '<ScrollWheelRight>' }) do
            for _, mode in ipairs({ 't', 'n', 'x' }) do
                vim.keymap.set(mode, key, '<Nop>', { buffer = ev.buf })
            end
        end
    end,
})

-- terminal scrollback: wheel-up pops into normal mode (nvim default, the
-- viewport can't leave the live output while in terminal mode); scrolling
-- back down to the bottom returns to terminal mode automatically
vim.api.nvim_create_autocmd('CursorMoved', {
    group = term_grp,
    pattern = 'term://*',
    callback = function()
        if vim.api.nvim_get_mode().mode ~= 'n' then return end
        local at_bottom = vim.fn.line('.') == vim.fn.line('$')
        local was_above = vim.b.term_scrolled_up
        vim.b.term_scrolled_up = not at_bottom
        if at_bottom and was_above then
            vim.cmd.startinsert()
        end
    end,
})

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
        mappings = {
            ["<LeftRelease>"] = "open",
        },
    },
}

-- neotest
require('neotest').setup {
    adapters = { require('neotest-golang') },
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
