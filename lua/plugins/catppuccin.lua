return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,

  config = function()
    local applying = false

    local function apply()
      if applying then return end
      applying = true

      local dark = vim.o.background == "dark"
      require("catppuccin").setup({
        flavour = "auto",
        background = { light = "latte", dark = "mocha" },
        transparent_background = dark,          -- transparent only in dark mode
        float = { transparent = dark, solid = false },
        show_end_of_buffer = false,
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

      applying = false
    end

    apply()

    -- re-apply whenever the background changes (:set bg=light, <leader>ub, etc.)
    vim.api.nvim_create_autocmd("OptionSet", {
      pattern = "background",
      callback = function() vim.schedule(apply) end,
    })
  end,
}
