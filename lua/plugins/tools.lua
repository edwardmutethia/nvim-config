-- Keep CLI formatters/linters and Java debug/test bundles installed via Mason.
-- DAP adapters themselves are installed by mason-nvim-dap in lua/plugins/dap.lua.
return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  lazy = false,
  dependencies = { "mason-org/mason.nvim" },
  opts = {
    ensure_installed = {
      -- Lua / Rust (existing)
      "stylua",
      "selene",
      "shfmt",
      "taplo",

      -- Python
      "ruff",

      -- Go
      "gofumpt",
      "golangci-lint",

      -- JavaScript / TypeScript / React / HTML / CSS
      "prettier",
      "htmlhint",
      "stylelint",

      -- C / C++
      "clang-format",
      "clang-tidy",

      -- Java (bundles consumed by nvim-jdtls)
      "google-java-format",
      "checkstyle",
      "java-debug-adapter",
      "java-test",

      -- SQL
      "sqlfluff",
    },
    auto_update = false,
    start_delay = 3000,
    debounce_hours = 24,
  },
}
