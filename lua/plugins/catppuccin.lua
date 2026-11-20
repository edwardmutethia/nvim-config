return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,

  config = function()
    local applying = false

    -- A quiet current-line highlight: only a few shades away from the base
    -- background, so it stays visible without fighting the terminal theme.
    local function apply_cursorline_highlights()
      if vim.o.background == "dark" then
        vim.api.nvim_set_hl(0, "CursorLine", { bg = "#242538", bold = false })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#9399b2", bg = "NONE", bold = false })
      else
        vim.api.nvim_set_hl(0, "CursorLine", { bg = "#e8eaf1", bold = false })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#6c6f85", bg = "NONE", bold = false })
      end
    end

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
          aerial = true,
          cmp = true,
          dap = true,
          dap_ui = true,
          flash = true,
          gitsigns = true,
          lsp_trouble = true,
          nvimtree = true,
          neotree = true,
          notify = true,
          telescope = { enabled = true },
          treesitter = true,
          which_key = true,
          mason = true,
          native_lsp = { enabled = true },
        },
      })
      vim.cmd.colorscheme("catppuccin")
      apply_cursorline_highlights()

      applying = false
    end

    apply()

    -- re-apply whenever the background changes (:set bg=light, <leader>ub, etc.)
    vim.api.nvim_create_autocmd("OptionSet", {
      pattern = "background",
      callback = function() vim.schedule(apply) end,
    })

    -- Keep the subtle cursor-line colors if the colorscheme is re-applied.
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function() vim.schedule(apply_cursorline_highlights) end,
    })
  end,
}
