-- Transparent, terminal-driven palette built on Catppuccin.
--
-- Editor, tab strip, status line, sidebars and floating windows all let the
-- terminal's background show through, so Neovim inherits whatever theme the
-- terminal is using. The "auto" flavour follows the terminal's light/dark
-- setting (detected by Neovim itself), keeping text readable on either.
-- <leader>ut switches to an opaque variant when a fixed backdrop is wanted.
vim.g.vscode_transparent = true

return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,

  config = function()
    local function apply_theme()
      require("catppuccin").setup({
        -- "auto" maps 'background' to latte/mocha and reloads on theme changes.
        flavour = "auto",
        background = { light = "latte", dark = "mocha" },
        transparent_background = vim.g.vscode_transparent,
        float = { transparent = vim.g.vscode_transparent, solid = false },
        -- Keep the terminal's own palette for nested shells.
        term_colors = false,
        custom_highlights = function(c)
          local solid = not vim.g.vscode_transparent
          -- In solid mode the tab bar is a shade darker than the editor, as in
          -- VSCode. In transparent mode every surface is "NONE" so the
          -- terminal's own colour is the only background.
          local bar = solid and c.mantle or "NONE"
          local editor = solid and c.base or "NONE"
          local active = solid and c.base or "NONE"

          return {
            -- Neo-tree paints this strip itself; its integration ignores
            -- transparent_background, so clear it here as well.
            NeoTreeStatusLineNC = { fg = c.overlay0, bg = solid and c.mantle or "NONE" },

            -- Separators disappear into the surface instead of drawing bright
            -- lines between editor, terminal and sidebars.
            WinSeparator = { fg = c.surface0, bg = editor },
            VertSplit = { fg = c.surface0, bg = editor },

            -- Native tabline fallbacks (bufferline supplies the real one).
            TabLine = { fg = c.overlay1, bg = bar },
            TabLineFill = { bg = bar },
            TabLineSel = { fg = c.text, bg = active },

            -- Bufferline tabs: inactive = sidebar shade, active = editor shade,
            -- with a blue accent marking the current file.
            BufferLineFill = { bg = bar },
            BufferLineBackground = { fg = c.overlay1, bg = bar },
            BufferLineBuffer = { fg = c.overlay1, bg = bar },
            BufferLineBufferVisible = { fg = c.subtext0, bg = bar },
            BufferLineBufferSelected = { fg = c.text, bg = active, bold = true },
            BufferLineSeparator = { fg = bar, bg = bar },
            BufferLineSeparatorVisible = { fg = bar, bg = bar },
            BufferLineSeparatorSelected = { fg = active, bg = active },
            BufferLineIndicatorSelected = { fg = c.blue, bg = active },
            BufferLineCloseButton = { fg = c.overlay1, bg = bar },
            BufferLineCloseButtonVisible = { fg = c.overlay1, bg = bar },
            BufferLineCloseButtonSelected = { fg = c.text, bg = active },
            BufferLineModified = { fg = c.yellow, bg = bar },
            BufferLineModifiedVisible = { fg = c.yellow, bg = bar },
            BufferLineModifiedSelected = { fg = c.yellow, bg = active },
            BufferLineError = { fg = c.red, bg = bar },
            BufferLineErrorVisible = { fg = c.red, bg = bar },
            BufferLineErrorSelected = { fg = c.red, bg = active },
            BufferLineWarning = { fg = c.yellow, bg = bar },
            BufferLineWarningVisible = { fg = c.yellow, bg = bar },
            BufferLineWarningSelected = { fg = c.yellow, bg = active },
            BufferLineInfo = { fg = c.blue, bg = bar },
            BufferLineInfoVisible = { fg = c.blue, bg = bar },
            BufferLineInfoSelected = { fg = c.blue, bg = active },
            BufferLineHint = { fg = c.teal, bg = bar },
            BufferLineHintVisible = { fg = c.teal, bg = bar },
            BufferLineHintSelected = { fg = c.teal, bg = active },
            BufferLineTab = { fg = c.overlay1, bg = bar },
            BufferLineTabSelected = { fg = c.text, bg = active },
            BufferLineTabClose = { fg = c.overlay1, bg = bar },
            BufferLineOffset = { fg = c.subtext0, bg = bar },
            BufferLineOffsetSeparator = { fg = c.surface0, bg = bar },
            BufferLineOffsetText = { fg = c.subtext0, bg = bar },
            BufferLineOffsetTextSelected = { fg = c.subtext0, bg = bar },
          }
        end,
      })
      -- Do not pin a flavour here: the colorscheme entry point lets changes to
      -- 'background' reload the matching latte/mocha variant automatically.
      vim.cmd.colorscheme("catppuccin")
    end

    apply_theme()

    vim.keymap.set("n", "<leader>ut", function()
      vim.g.vscode_transparent = not vim.g.vscode_transparent
      apply_theme()
      vim.notify(
        "Editor background: " .. (vim.g.vscode_transparent and "transparent" or "solid"),
        vim.log.levels.INFO,
        { title = "VSCode UI" }
      )
    end, { desc = "Toggle transparent / solid background" })
  end,
}
