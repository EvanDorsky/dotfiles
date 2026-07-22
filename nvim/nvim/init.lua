-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Reload files changed on disk (e.g. by external tools) when unmodified in the buffer.
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	command = "checktime",
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		-- { import = "plugins" },
		{
			"danielfalk/smart-open.nvim",
			branch = "0.2.x",
			config = function()
				require("telescope").load_extension("smart_open")
			end,
			dependencies = {
				"kkharji/sqlite.lua",
				"nvim-tree/nvim-web-devicons",
				-- Only required if using match_algorithm fzf
				{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
				-- Optional.  If installed, native fzy will be used when match_algorithm is fzy
				{ "nvim-telescope/telescope-fzy-native.nvim" },
			},
		},
		{
			'nvim-telescope/telescope.nvim', version = '*',
			dependencies = {
				'nvim-lua/plenary.nvim',
				-- optional but recommended
				{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
			}
		},
		{
			'shatur/neovim-ayu', version = '*'
		},
		{ 'tpope/vim-sleuth' },
		{
			'nvim-lualine/lualine.nvim',
			dependencies = { 'nvim-tree/nvim-web-devicons' }
		},
		{
			'lewis6991/gitsigns.nvim',
			config = function()
				require('gitsigns').setup()
			end,
		},
		{
			'nvim-treesitter/nvim-treesitter',
			lazy = false,
			build = ':TSUpdate'
		},
		{
			'tree-sitter-grammars/tree-sitter-lua'
		},
		{ 'sindrets/diffview.nvim' },
		{
			'nvim-neo-tree/neo-tree.nvim',
			branch = 'v3.x',
			dependencies = {
				'nvim-lua/plenary.nvim',
				'nvim-tree/nvim-web-devicons',
				'MunifTanjim/nui.nvim',
			},
		},
		{
			'saghen/blink.cmp',
			version = '*'
		},
		{
			'coder/claudecode.nvim',
			dependencies = { 'folke/snacks.nvim' },
			config = true,
		}
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true, notify = false },
})

require('keys')
require('lsp')
require('theme')
require('editor')

-- exit callbacks
vim.api.nvim_create_autocmd('VimLeavePre', {
	callback = function()
		vim.fn.setreg('/', '')
	end,
	desc = 'Clear search on exit',
})
