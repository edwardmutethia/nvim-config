return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,

  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      -- Let the terminal's background show through, so Neovim picks up
      -- whatever theme the terminal is currently using.
      transparent_background = true,
      float = {
        transparent = true,
      },
      -- Keep the terminal's own palette for nested shells.
      term_colors = false,
    })
    vim.cmd.colorscheme("catppuccin-mocha")
  end,
}
