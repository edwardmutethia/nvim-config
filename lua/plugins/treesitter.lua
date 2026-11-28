-- nvim-treesitter "main" is a full rewrite: highlighting/folds are enabled
-- through Neovim's native APIs (see lua/autocmds.lua), not configs.setup().
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    install_dir = vim.fn.stdpath("data") .. "/site",
  },
  config = function(_, opts)
    require("nvim-treesitter").setup(opts)

    -- Safe to call on every startup; already-installed parsers are skipped.
    require("nvim-treesitter").install({
      "lua",
      "rust",
      "vim",
      "vimdoc",
      -- Used by Noice to highlight regexes in the search prompt.
      "regex",
      "query",
      "bash",
      "json",
      "yaml",
      "toml",
      "markdown",
      "markdown_inline",
      "diff",
      "c",
      "cpp",
      "python",
      "javascript",
      "typescript",
      "tsx",
      "css",
      "scss",
      "html",
      "sql",
      "go",
      "java",
    })
  end,
}
