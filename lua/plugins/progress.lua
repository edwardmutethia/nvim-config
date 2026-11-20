-- LSP progress notifications in a corner window, so it is clear when a
-- language server is still indexing instead of appearing hung.
return {
  "j-hui/fidget.nvim",
  version = "*",
  lazy = false,
  opts = {
    notification = {
      window = { winblend = 0 },
    },
  },
}
