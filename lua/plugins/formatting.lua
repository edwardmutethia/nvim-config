return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = "ConformInfo",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      rust = { "rustfmt", lsp_format = "fallback" },
      python = { "ruff_fix", "ruff_format" },
      go = { "gofumpt" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      less = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      java = { "google-java-format" },
      sql = { "sqlfluff" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      [ "_" ] = { "trim_whitespace" },
    },
    formatters = {
      -- Keep the user's 4-space indentation for Prettier-managed web files.
      prettier = { prepend_args = { "--tab-width", "4" } },
      -- SQL projects do not always have a .sqlfluff/pyproject.toml at the root.
      sqlfluff = { require_cwd = false },
    },
    format_on_save = {
      timeout_ms = 2000,
      lsp_format = "fallback",
    },
  },
  config = function(_, opts)
    require("conform").setup(opts)
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
