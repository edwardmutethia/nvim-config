-- rustaceanvim is a filetype plugin: it manages rust-analyzer itself.
-- Do not call nvim-lspconfig's rust_analyzer setup anywhere else.
return {
  "mrcjkb/rustaceanvim",
  version = "^9",
  lazy = false,
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
  },
  init = function()
    ---@type rustaceanvim.Opts
    vim.g.rustaceanvim = {
      tools = {
        enable_clippy = true,
        -- Falls back to cargo test when cargo-nextest is not installed.
        enable_nextest = vim.fn.executable("cargo-nextest") == 1,
        reload_workspace_from_cargo_toml = true,
      },
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            check = { command = "clippy" },
            inlayHints = {
              lifetimeLabels = { enabled = true },
              typeHints = { enabled = true },
              parameterHints = { enabled = true },
              chainingHints = { enabled = true },
            },
          },
        },
      },
      dap = {
        autoload_configurations = true,
      },
    }
  end,
  keys = {
    { "<leader>rr", "<cmd>RustLsp runnables<CR>", desc = "Rust: runnables" },
    { "<leader>rd", "<cmd>RustLsp debuggables<CR>", desc = "Rust: debuggables" },
    { "<leader>rt", "<cmd>RustLsp testables<CR>", desc = "Rust: testables" },
    { "<leader>rT", "<cmd>RustLsp relatedTests<CR>", desc = "Rust: related tests" },
    { "<leader>rh", "<cmd>RustLsp hover actions<CR>", desc = "Rust: hover actions" },
    { "<leader>rE", "<cmd>RustLsp explainError<CR>", desc = "Rust: explain error" },
  },
}
