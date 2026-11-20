return {
  "boonyarit-iamsaard/dark-2026.nvim",
  lazy = false,
  name = "dark-2026",
  priority = 1000,

  config = function()
    require("dark-2026").setup({
      -- Inherit Alacritty's #191a1b background so both surfaces match.
      transparent = true,
      italic_comments = true,
      on_highlights = function(hl, p)
        -- Quiet current line, using the theme's own surface colors.
        hl.CursorLine = { bg = p.bg_line }
        hl.CursorLineNr = { fg = p.fg_dim, bg = "NONE", bold = false }
      end,
    })
    vim.cmd.colorscheme("dark-2026")
  end,
}
