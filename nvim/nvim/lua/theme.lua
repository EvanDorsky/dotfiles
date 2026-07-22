
require('ayu').setup({
        mirage = true,
        terminal = true
})

require('ayu').colorscheme()

-- treesitter-context header: lift it off the buffer background so it reads as a header
local c = require('ayu.colors')
vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = c.panel_bg })
-- the gutter float still reserves its width (keeps the header aligned with the code
-- below) but fg == bg hides the relative numbers, which churn on every scroll
vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { fg = c.panel_bg, bg = c.panel_bg })
vim.api.nvim_set_hl(0, 'TreesitterContextLineNumberBottom', { fg = c.panel_bg, bg = c.panel_bg })
vim.api.nvim_set_hl(0, 'TreesitterContextSeparator', { fg = c.panel_border })
