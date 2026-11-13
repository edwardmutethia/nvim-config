return {
  "ellisonleao/gruvbox.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("gruvbox").setup({
      contrast = "hard",
      transparent_mode = true,   -- use the terminal's own background
      italic = { strings = false, comments = true, operators = false, folds = true },
      overrides = {
        -- make the file tree and floating windows see-through too
        NeoTreeNormal       = { bg = "NONE" },
        NeoTreeNormalNC     = { bg = "NONE" },
        NeoTreeEndOfBuffer  = { bg = "NONE" },
        NormalFloat         = { bg = "NONE" },
        FloatBorder         = { bg = "NONE" },
        SignColumn          = { bg = "NONE" },
        TelescopeNormal     = { bg = "NONE" },
        TelescopeBorder     = { bg = "NONE" },
      },
    })
    vim.o.background = "dark"
    vim.cmd.colorscheme("gruvbox")
  end,
}
