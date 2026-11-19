-- Keep CLI tools (formatters/linters/debug adapters) installed via Mason.
return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  lazy = false,
  dependencies = { "mason-org/mason.nvim" },
  opts = {
    ensure_installed = {
      "stylua",
      "selene",
      "shfmt",
      "taplo",
    },
    auto_update = false,
    start_delay = 3000,
    debounce_hours = 24,
  },
}
