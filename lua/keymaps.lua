local map = vim.keymap.set

local function opts(desc)
  return { noremap = true, silent = true, desc = desc }
end

-- Window navigation and resizing
map("n", "<C-h>", "<C-w>h", opts("Focus left window"))
map("n", "<C-j>", "<C-w>j", opts("Focus lower window"))
map("n", "<C-k>", "<C-w>k", opts("Focus upper window"))
map("n", "<C-l>", "<C-w>l", opts("Focus right window"))
map("n", "<C-Up>", ":resize +2<CR>", opts("Increase window height"))
map("n", "<C-Down>", ":resize -2<CR>", opts("Decrease window height"))
map("n", "<C-Left>", ":vertical resize -2<CR>", opts("Decrease window width"))
map("n", "<C-Right>", ":vertical resize +2<CR>", opts("Increase window width"))

-- Centred half-screen scrolling: the next target stays in view.
map("n", "<C-d>", "<C-d>zz", opts("Scroll down and centre"))
map("n", "<C-u>", "<C-u>zz", opts("Scroll up and centre"))

-- Buffers. Tab / S-Tab, C-Tab / C-S-Tab and Alt+1..9 live in
-- lua/plugins/tabline.lua so they drive the visible tab strip.
map("n", "<leader><leader>", ":buffer #<CR>", opts("Jump to previous buffer"))
map("n", "<leader>ws", ":write<CR>", opts("Save buffer"))
map("n", "<leader>wv", ":vsplit<CR>", opts("Split vertically"))
map("n", "<leader>wh", ":split<CR>", opts("Split horizontally"))
map("n", "<leader>we", "<C-w>=", opts("Make splits equal size"))
map("n", "<leader>wo", "<C-w>o", opts("Keep only current split"))
-- <leader>wq / <leader>wQ live in lua/plugins/buffers.lua so they can lazy-load
-- mini.bufremove and preserve the window layout.

-- Editing helpers
map("v", "J", ":move '>+1<CR>gv=gv", opts("Move selection down"))
map("v", "K", ":move '<-2<CR>gv=gv", opts("Move selection up"))
map("v", "<", "<gv", opts("Outdent selection"))
map("v", ">", ">gv", opts("Indent selection"))
map("n", "n", "nzzzv", opts("Next search result (centered)"))
map("n", "N", "Nzzzv", opts("Previous search result (centered)"))
map("n", "<leader>uh", ":nohlsearch<CR>", opts("Clear search highlight"))
map("n", "<leader>uw", function()
  vim.opt.wrap = not vim.opt.wrap:get()
end, opts("Toggle line wrap"))

-- Save without leaving Insert mode.
map({ "n", "i" }, "<C-s>", "<cmd>write<CR>", opts("Save buffer"))

-- Clipboard helpers that respect the system clipboard and avoid yank-on-paste.
map({ "n", "v" }, "<leader>y", '"+y', opts("Copy to system clipboard"))
map("n", "<leader>Y", '"+y$', opts("Copy line to system clipboard"))
map("n", "<leader>p", '"+p', opts("Paste from system clipboard"))
map("v", "<leader>p", '"_dP', opts("Paste without yanking selection"))
map({ "n", "v" }, "<leader>D", '"_d', opts("Delete without yanking"))

-- Relative numbers are useful for motions but confusing at first; toggling
-- makes them available without making them the default.
map("n", "<leader>ur", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, opts("Toggle relative line numbers"))
map("n", "<leader>us", function()
  vim.opt.spell = not vim.opt.spell:get()
end, opts("Toggle spell check"))

-- Diagnostics and build output browsing.
map("n", "[d", vim.diagnostic.goto_prev, opts("Previous diagnostic"))
map("n", "]d", vim.diagnostic.goto_next, opts("Next diagnostic"))
map("n", "[q", ":cprevious<CR>", opts("Previous compiler error"))
map("n", "]q", ":cnext<CR>", opts("Next compiler error"))

-- Code
map({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, opts("Format buffer"))
