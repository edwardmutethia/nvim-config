-- Rendered Markdown preview for README files.
-- Rendering happens in the same buffer, so switching between preview and raw
-- edit mode never moves the cursor to another window or buffer.
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = "markdown",
    cmd = "RenderMarkdown",
    keys = {
      {
        "<leader>mp",
        "<cmd>RenderMarkdown buf_toggle<CR>",
        desc = "Markdown: toggle rendered preview / raw edit",
      },
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      -- Every Markdown buffer starts rendered; :RenderMarkdown buf_toggle
      -- switches only the current buffer to raw text when editing is wanted.
      enabled = true,
      -- Insert mode shows raw Markdown automatically, so typing always feels
      -- normal and leaving insert mode restores the rendered preview.
      render_modes = { "n", "c", "t" },
      debounce = 80,
      anti_conceal = { enabled = true },
    },
  },
}
