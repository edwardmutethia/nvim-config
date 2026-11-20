-- Test runner for Lua, Rust, Python, Go, JS/TS/React, Java, and C/C++.
-- Rust uses rustaceanvim's built-in adapter (rust-analyzer powered), so the
-- separate neotest-rust adapter is intentionally not installed.
return {
  "nvim-neotest/neotest",
  version = "^5",
  event = "VeryLazy",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-neotest/neotest-plenary",
    "nvim-treesitter/nvim-treesitter",
    "mrcjkb/rustaceanvim",
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-go",
    "marilari88/neotest-vitest",
    "nvim-neotest/neotest-jest",
    "rcasia/neotest-java",
    "alfaix/neotest-gtest",
    "orjangj/neotest-ctest",
  },
  opts = function()
    return {
      adapters = {
        require("rustaceanvim.neotest"),
        require("neotest-plenary"),
        require("neotest-python")({
          runner = "pytest",
          dap = { justMyCode = false },
        }),
        require("neotest-go")({
          args = { "-count=1", "-timeout=60s" },
          experimental = { test_table = true },
        }),
        require("neotest-vitest")({
          filter_dir = function(name)
            return name ~= "node_modules"
          end,
        }),
        require("neotest-jest"),
        require("neotest-java")({
          incremental_build = true,
          disable_update_notifications = false,
        }),
        require("neotest-gtest").setup({}),
        require("neotest-ctest").setup({ dap_adapter = "codelldb" }),
      },
      output = { open_on_run = "short" },
      diagnostic = { enabled = true },
      status = { signs = true, virtual_text = false },
      summary = {
        open = "botright vsplit | vertical resize 50",
      },
    }
  end,
  keys = {
    { "<leader>nt", function() require("neotest").run.run() end, desc = "Test: nearest" },
    { "<leader>nf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: file" },
    { "<leader>na", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Test: all" },
    { "<leader>nb", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test: debug nearest" },
    { "<leader>nl", function() require("neotest").run.run_last() end, desc = "Test: rerun last" },
    { "<leader>nS", function() require("neotest").run.stop() end, desc = "Test: stop" },
    { "<leader>ns", function() require("neotest").summary.toggle() end, desc = "Test: summary" },
    { "<leader>no", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Test: output" },
  },
}
