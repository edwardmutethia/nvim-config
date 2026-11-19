vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- Indentation (kept from your original config)
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4

-- Line numbers (kept from your original config)
opt.number = true
opt.relativenumber = true

-- Core editor behaviour
opt.termguicolors = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true
opt.hidden = true
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.splitbelow = true
opt.splitright = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.colorcolumn = "100"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.updatetime = 250
opt.timeoutlen = 400
opt.showmode = false
opt.completeopt = { "menu", "menuone", "noselect" }
opt.fillchars = { eob = " " }
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "›", precedes = "‹" }

-- Treesitter-backed folding (parser-aware setup lives in lua/autocmds.lua)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = "v:lua.vim.treesitter.foldtext()"
opt.foldlevelstart = 99

opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
