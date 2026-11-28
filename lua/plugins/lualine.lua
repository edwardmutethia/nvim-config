return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "auto", -- follow the active colorscheme (Catppuccin Mocha)
      globalstatus = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    -- VSCode's status bar: mode on the left accent, project/file context in
    -- the middle, problem counts and cursor position on the right.
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff" },
      lualine_c = {
        {
          "filename",
          path = 1,
          file_status = true,
          symbols = { modified = "●", readonly = "🔒", unnamed = "[No Name]" },
        },
      },
      lualine_x = {
        { "diagnostics", symbols = { error = "● ", warn = "● ", info = "● ", hint = "● " } },
        "encoding",
        "fileformat",
        "filetype",
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    extensions = { "neo-tree", "trouble", "aerial", "toggleterm" },
  },
}
