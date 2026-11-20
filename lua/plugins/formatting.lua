return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = "ConformInfo",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      rust = { "rustfmt", lsp_format = "fallback" },
      python = { "ruff_fix", "ruff_format" },
      -- gofumpt emits tabs by design; spaces4 converts only leading indentation
      -- back to four spaces without touching tabs inside string literals.
      go = { "gofumpt", "spaces4" },
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
      -- Convert only leading tabs to four spaces. Used after formatters such
      -- as gofumpt that force tabs, while preserving tabs inside strings.
      spaces4 = {
        format = function(_, _, lines, callback)
          local out = {}
          for _, line in ipairs(lines) do
            local indent, rest = line:match("^([\t ]*)(.*)$")
            table.insert(out, indent:gsub("\t", "    ") .. rest)
          end
          callback(nil, out)
        end,
      },
      -- Keep 4 spaces even when a formatter has a different default or the
      -- project has no local config telling it what indentation to use.
      prettier = { prepend_args = { "--tab-width", "4", "--no-use-tabs" } },
      stylua = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" } },
      rustfmt = { prepend_args = { "--config", "tab_spaces=4,hard_tabs=false" } },
      ruff_format = { prepend_args = { "--config", "indent-width = 4" } },
      ["clang-format"] = {
        prepend_args = {
          "-style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Never}",
        },
      },
      ["google-java-format"] = { prepend_args = { "--aosp" } },
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
