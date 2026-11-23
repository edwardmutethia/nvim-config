vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- No plugin here needs Neovim's remote providers; disabling them also removes
-- their optional-runtime health warnings.
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Use the locally installed JDK for Java tooling (no sudo/system install).
local jdk_root = vim.fn.expand("$HOME/.local/lib/jdks")
local jdks = vim.fn.globpath(jdk_root, "jdk-*", true, true)
if #jdks > 0 then
  table.sort(jdks)
  local java_home = jdks[#jdks]
  vim.env.JAVA_HOME = java_home
  vim.env.PATH = java_home .. "/bin:" .. vim.env.PATH
end

local opt = vim.opt

-- Indentation (kept from your original config)
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4

-- Absolute line numbers are easier when you are starting out; <leader>ur
-- switches to relative numbers when you want fast `5j`-style motions.
opt.number = true
opt.relativenumber = false

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
opt.signcolumn = "auto"
opt.cursorline = true
-- No fixed colorcolumn: it appears as a stray vertical rule in wide/floating
-- terminals whenever the window is at least 100 columns wide.
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.updatetime = 250
opt.timeoutlen = 300
opt.showmode = false
opt.completeopt = { "menu", "menuone", "noselect" }
opt.fillchars = { eob = " " }

-- Treesitter-backed folding (parser-aware setup lives in lua/autocmds.lua)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = "v:lua.vim.treesitter.foldtext()"
opt.foldlevelstart = 99

opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
