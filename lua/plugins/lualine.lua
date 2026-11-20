return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "auto", -- follow the active colorscheme (Dark 2026)
      globalstatus = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {},
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "diagnostics" },
      lualine_y = {},
      lualine_z = { "location" },
    },
    extensions = { "neo-tree", "trouble", "aerial", "toggleterm" },
  },
}
