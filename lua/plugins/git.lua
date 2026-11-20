return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs_staged_enable = true,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end

        map("n", "]h", gs.next_hunk, "Next git hunk")
        map("n", "[h", gs.prev_hunk, "Previous git hunk")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hb", gs.blame_line, "Blame line")
        map("n", "<leader>hl", gs.toggle_current_line_blame, "Toggle line blame")
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo staged hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>hd", gs.diffthis, "Diff against index")
        map("n", "<leader>gt", gs.toggle_signs, "Toggle git signs")
      end,
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Git: branch diff" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", desc = "Git: file history" },
      { "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "Git: close diff view" },
    },
    opts = {
      enhanced_diff_hl = true,
      use_icons = false,
      view = {
        default = { winbar_info = false },
        file_history = { winbar_info = false },
      },
      file_panel = { listing_style = "tree" },
    },
  },
}
