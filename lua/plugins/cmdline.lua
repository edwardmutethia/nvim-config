-- A quieter, professional command line: a rounded prompt with a clear glyph,
-- context-aware titles and syntax highlighting, plus tidy messages/completions.
-- Search stays in the familiar bottom cmdline; `:` opens the floating prompt.
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    cmdline = {
      view = "cmdline_popup",
      format = {
        -- Unicode glyphs keep the prompt consistent with the zsh prompt and
        -- avoid depending on a Nerd Font.
        cmdline = { icon = "❯", lang = "vim", title = " Command " },
        search_down = { icon = "⌕", lang = "regex", title = " Search " },
        search_up = { icon = "⌕", lang = "regex", title = " Search ↑ " },
        filter = { icon = "$", lang = "bash", title = " Shell " },
        lua = { icon = "λ", lang = "lua", title = " Lua " },
        help = { icon = "?", title = " Help " },
        input = { icon = "❯", title = " Input " },
      },
    },
    -- Completion sits directly under the prompt instead of at the cursor.
    popupmenu = {
      enabled = true,
      backend = "nui", -- nvim-cmp owns insert-mode; Noice owns the cmdline list
      kind_icons = false,
    },
    messages = {
      enabled = true,
      view = "notify",
      view_error = "notify",
      view_warn = "notify",
      view_history = "messages",
      view_search = false, -- no "n of m matches" chatter while searching
    },
    notify = {
      enabled = true,
      view = "notify",
    },
    lsp = {
      -- fidget.nvim already reports LSP progress; keep one source of truth.
      progress = { enabled = false },
      -- Preserve the existing built-in hover/signature help behaviour.
      hover = { enabled = false },
      signature = { enabled = false },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
    views = {
      cmdline_popup = {
        position = { row = 4, col = "50%" },
        size = { min_width = 60, width = "auto" },
        border = { style = "rounded", padding = { 0, 2 } },
      },
      cmdline_popupmenu = {
        position = { row = 6, col = "50%" },
        size = { min_width = 60, width = "auto", max_height = 16 },
      },
      cmdline_input = {
        border = { style = "rounded", padding = { 0, 2 } },
      },
    },
    routes = {
      -- Writing a file is already obvious from the status line's dirty flag.
      {
        filter = { event = "msg_show", kind = "", find = "written" },
        opts = { skip = true },
      },
    },
  },
  config = function(_, opts)
    require("noice").setup(opts)

    vim.keymap.set("n", "<leader>um", "<cmd>Noice<CR>", { desc = "Show recent messages" })
  end,
}
