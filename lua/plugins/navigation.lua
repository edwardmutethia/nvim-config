return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Workspace diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Document symbols" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix list" },
    },
    opts = {},
  },
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen", "AerialNavOpen" },
    keys = {
      { "<leader>o", "<cmd>AerialToggle!<CR>", desc = "Toggle symbol outline" },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      backends = { "lsp", "treesitter" },
      layout = { default_direction = "right", width = 40 },
      open_automatic = false,
    },
  },
}
