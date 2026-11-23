-- Beginner-friendly, self-contained quick reference.
-- Open it with :NvimGuide or <leader>H. It is plain text on purpose: no plugin
-- to install, no network, and it works even when LSP or plugins are broken.

local M = {}

local lines = {
  "Neovim Quick Start",
  "==================",
  "",
  "You are in Normal mode. Press i to type, Esc to come back.",
  "Press <leader>H to reopen this guide. Press <leader>? to list every key.",
  "",
  "1. The first keys",
  "----------------",
  "  i       insert (type text)             Esc     back to Normal mode",
  "  :       run a command (type, Enter)     C-s     save (same as <leader>ws)",
  "  u       undo                            C-r     redo",
  "  .       repeat the last edit",
  "",
  "2. Move fast",
  "------------",
  "  h j k l move left/down/up/right        w / b   next / previous word",
  "  0 / $   start / end of line            gg / G  first / last line",
  "  f<char> jump to a character on the line   s    Flash: jump to any text",
  "  /text   search forward (n / N = next / previous)",
  "  C-d/C-u scroll half a page and keep the cursor centred",
  "",
  "3. Edit without thinking",
  "------------------------",
  "  dd / yy / p   delete / copy / paste a line",
  "  ciw           change the word under the cursor",
  "  gc / gcc      comment selection / comment this line",
  "  > / <         indent / outdent (Visual mode: keep the selection)",
  "  <leader>y     copy to the system clipboard",
  "  <leader>Y     copy the line to the system clipboard",
  "  <leader>p     paste from the system clipboard (Visual: no yank)",
  "  <leader>D     delete without filling the clipboard",
  "",
  "4. Find anything",
  "----------------",
  "  C-p or <leader>ff    find a file by name",
  "  <leader>fg           search text in the whole project",
  "  <leader>fc           search for the word under the cursor",
  "  <leader>fs           jump to a symbol (function, class, ...)",
  "  <leader>fk           search the keymaps",
  "  <leader>fh           search Neovim help (the best way to learn a command)",
  "",
  "5. Files, buffers, and splits",
  "-----------------------------",
  "  C-n / <leader>en     toggle the file explorer (P previews a README)",
  "  <Tab> / <S-Tab>      next / previous open file",
  "  <leader><leader>     jump to the previously open file",
  "  <leader>fb           pick an open file from a list",
  "  C-h/C-j/C-k/C-l      move left/down/up/right between splits",
  "  <leader>wv / <leader>wh   split vertically / horizontally",
  "  <leader>we           make all splits equal size",
  "  <leader>wo           keep only the current split",
  "  <leader>ws / <leader>wq   save / close the current file",
  "  <leader>ur           toggle relative line numbers",
  "  <leader>uw           toggle line wrap",
  "",
  "6. Code help (LSP)",
  "------------------",
  "  K                    hover: explain the thing under the cursor",
  "  gd / gi              go to definition / implementation",
  "  <leader>ca           code action (quick fix, organise imports, ...)",
  "  <leader>cr           rename a symbol everywhere",
  "  [d / ]d              previous / next error or warning",
  "  <leader>xx           list all diagnostics in the project",
  "  <leader>o            toggle the symbol outline for this file",
  "  :checkhealth vim.lsp see which language servers are running",
  "",
  "7. Build, test, git",
  "-------------------",
  "  <leader>bb           build the current project (errors go to quickfix)",
  "  <leader>br           rerun the last build       <leader>bo  show its output",
  "  [q / ]q              previous / next compiler error",
  "  <leader>nt           run tests                  <leader>tg  lazygit",
  "  <leader>hS / <leader>hs  stage the whole file / just this hunk",
  "",
  "8. When something feels wrong",
  "-----------------------------",
  "  :checkhealth         diagnose the editor and installed tools",
  "  :Lazy                manage plugins",
  "  :Mason               install or update LSP servers and formatters",
  "  :messages            read recent editor messages",
  "  :NvimGuide           show this guide again",
  "",
  "The full bootcamp lives in ~/.config/nvim/README.md and in the repo:",
  "https://github.com/edwardmutethia/nvim-config",
  "",
  "Tip: press q to close this guide and go back to your work.",
}

function M.show()
  vim.cmd("tabnew")
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
  vim.bo[buf].buftype = "help"
  vim.bo[buf].filetype = "help"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].modified = false
  -- The generic help-window mapping uses :close, which cannot close the only
  -- window in a tab. This guide owns its tab, so q must close the tab.
  vim.keymap.set("n", "q", "<cmd>tabclose<CR>", {
    buffer = buf,
    silent = true,
    desc = "Close guide",
  })

  local ns = vim.api.nvim_create_namespace("nvim_guide")
  vim.api.nvim_buf_add_highlight(buf, ns, "Title", 0, 0, -1)
  for i, line in ipairs(lines) do
    if line:match("^%d+%. ") then
      vim.api.nvim_buf_add_highlight(buf, ns, "Statement", i - 1, 0, -1)
    elseif line:match("^[-]+$") then
      vim.api.nvim_buf_add_highlight(buf, ns, "Comment", i - 1, 0, -1)
    end
  end
end

vim.keymap.set("n", "<leader>H", M.show, { desc = "Open beginner quick-start guide" })
vim.api.nvim_create_user_command("NvimGuide", M.show, { desc = "Open the beginner quick-start guide" })

return M
