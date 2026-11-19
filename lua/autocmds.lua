local group = vim.api.nvim_create_augroup("user_config", { clear = true })

-- Start Treesitter highlighting for every language with an installed parser.
-- Folding is driven globally by v:lua.vim.treesitter.foldexpr() in options.lua.
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function(args)
    if args.match == "" then
      return
    end
    if not pcall(vim.treesitter.language.add, args.match) then
      return
    end
    pcall(vim.treesitter.start, args.buf, args.match)
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Let "q" close the helper windows that are meant to be dismissed quickly.
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "help", "qf", "checkhealth", "lspinfo", "man", "notify", "trouble" },
  callback = function(args)
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = args.buf, silent = true })
  end,
})
