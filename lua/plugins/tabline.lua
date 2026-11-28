-- VSCode-style editor tabs.
--
-- A single tab bar across the top lists every open file, with a filetype icon,
-- a dirty dot, a close button, and inline diagnostics. It uses the editor's
-- palette (set in catppuccin.lua) so the strip sits flush with the editor and
-- the terminal below it instead of looking like a separate widget.
return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons", "nvim-mini/mini.bufremove" },
  lazy = false, -- the tab strip must be visible from the very first frame
  priority = 900,

  keys = {
    { "<Tab>", "<cmd>BufferLineCycleNext<CR>", desc = "Next file tab" },
    { "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous file tab" },
    { "<C-Tab>", "<cmd>BufferLineCycleNext<CR>", desc = "Next file tab" },
    { "<C-S-Tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous file tab" },
    -- VSCode's Ctrl+1..9, moved to Alt so the terminal keeps its own shortcuts.
    { "<A-1>", "<cmd>BufferLineGoToBuffer 1<CR>", desc = "Go to tab 1" },
    { "<A-2>", "<cmd>BufferLineGoToBuffer 2<CR>", desc = "Go to tab 2" },
    { "<A-3>", "<cmd>BufferLineGoToBuffer 3<CR>", desc = "Go to tab 3" },
    { "<A-4>", "<cmd>BufferLineGoToBuffer 4<CR>", desc = "Go to tab 4" },
    { "<A-5>", "<cmd>BufferLineGoToBuffer 5<CR>", desc = "Go to tab 5" },
    { "<A-6>", "<cmd>BufferLineGoToBuffer 6<CR>", desc = "Go to tab 6" },
    { "<A-7>", "<cmd>BufferLineGoToBuffer 7<CR>", desc = "Go to tab 7" },
    { "<A-8>", "<cmd>BufferLineGoToBuffer 8<CR>", desc = "Go to tab 8" },
    { "<A-9>", "<cmd>BufferLineGoToBuffer 9<CR>", desc = "Go to tab 9" },
    { "<A-S>", "<cmd>BufferLineSortByDirectory<CR>", desc = "Sort tabs by directory" },
  },

  opts = {
    options = {
      mode = "buffers",
      style = "default",
      themable = true, -- pick up the custom BufferLine* highlights
      numbers = "none",
      -- Close from the tab's × without breaking splits (same helper as <leader>wq).
      close_command = function(buf)
        require("mini.bufremove").delete(buf, false)
      end,
      middle_mouse_command = function(buf)
        require("mini.bufremove").delete(buf, false)
      end,
      right_mouse_command = "vert sbuffer %d",

      indicator = { icon = "▍", style = "icon" },
      buffer_close_icon = "×",
      modified_icon = "●",
      left_trunc_marker = "‹",
      right_trunc_marker = "›",
      max_name_length = 28,
      truncate_names = true,
      tab_size = 20,
      color_icons = true,
      show_icons = true,
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = false,
      show_tab_indicators = false,

      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(count, level)
        local icons = { error = "●", warning = "●", info = "●", hint = "●" }
        return (icons[(level or ""):lower()] or "●") .. " " .. count
      end,

      persist_buffer_sort = true,
      enforce_regular_tabs = false,
      always_show_bufferline = true,
      separator_style = "thin",

      -- Tabs belong to the editor area: start them to the right of sidebars,
      -- just like VSCode, and give each sidebar a labelled tab-strip extension.
      offsets = {
        {
          filetype = "neo-tree",
          text = "  Explorer",
          text_align = "left",
          separator = true,
          highlight = "NeoTreeNormal",
        },
        {
          filetype = "aerial",
          text = "  Outline",
          text_align = "left",
          separator = true,
        },
        {
          filetype = "trouble",
          text = "  Problems",
          text_align = "left",
          separator = true,
        },
      },
    },
  },
}
