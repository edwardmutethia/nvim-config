return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "jay-babu/mason-nvim-dap.nvim",
    "jbyuki/one-small-step-for-vimkind",
  },
  keys = {
    { "<F5>", function() require("dap").continue() end, desc = "Debug: continue" },
    { "<F6>", function() require("dap").pause() end, desc = "Debug: pause" },
    { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
    { "<F10>", function() require("dap").step_over() end, desc = "Debug: step over" },
    { "<F11>", function() require("dap").step_into() end, desc = "Debug: step into" },
    { "<F12>", function() require("dap").step_out() end, desc = "Debug: step out" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: toggle UI" },
    { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug: REPL" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Debug: hover value" },
    { "<leader>dl", function() require("osv").launch({ port = 8086 }) end, desc = "Debug: launch Lua server (osv)" },
  },
  config = function()
    local dap = require("dap")

    require("mason-nvim-dap").setup({ ensure_installed = { "codelldb" } })

    require("nvim-dap-virtual-text").setup({
      commented = true,
      virt_text_pos = "inline",
    })

    local dapui = require("dapui")
    dapui.setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Lua debugging through osv: launch the server with <leader>dl in the
    -- debuggee, then attach from another Neovim instance with <F5>.
    dap.adapters.nlua = function(callback, config)
      callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
    end
    dap.configurations.lua = {
      {
        type = "nlua",
        request = "attach",
        name = "Attach to running Neovim instance",
      },
    }

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticError", linehl = "", numhl = "" })
  end,
}
