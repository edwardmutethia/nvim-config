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

-- Buffers
map("n", "<Tab>", ":bnext<CR>", opts("Next buffer"))
map("n", "<S-Tab>", ":bprevious<CR>", opts("Previous buffer"))
map("n", "<leader>ws", ":write<CR>", opts("Save buffer"))
map("n", "<leader>wq", ":bdelete<CR>", opts("Close buffer"))
map("n", "<leader>wQ", ":bdelete!<CR>", opts("Force close buffer"))

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

-- Diagnostics browsing
map("n", "[d", vim.diagnostic.goto_prev, opts("Previous diagnostic"))
map("n", "]d", vim.diagnostic.goto_next, opts("Next diagnostic"))

-- Code
map({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, opts("Format buffer"))
