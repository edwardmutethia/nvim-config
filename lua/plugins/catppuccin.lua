return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,

  config = function()
    require("catppuccin").setup({
      flavour = "mocha",              -- darkest flavour, blends best with your teal terminal
      transparent_background = true,  -- main window, sidebar, statusline backgrounds
      float = {
        transparent = true,           -- floating windows (LSP hover, completion docs, etc.)
        solid = false,
      },
      show_end_of_buffer = false,     -- hides the "~" filler lines
      term_colors = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        neotree = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
        mason = true,
        native_lsp = { enabled = true },
      },
    })

    vim.cmd.colorscheme("catppuccin")
  end,
}
