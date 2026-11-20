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

    -- Mason installs and auto-registers codelldb (C/C++/Rust), debugpy
    -- (Python), delve (Go). js-debug-adapter is registered manually below.
    require("mason-nvim-dap").setup({
      ensure_installed = { "codelldb", "python", "delve", "js" },
    })

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

    -- Define the common adapters explicitly. mason-nvim-dap also registers
    -- these when its registry has refreshed, but defining them here makes
    -- debugging available immediately after installation.
    local function path_or(name)
      local path = vim.fn.exepath(name)
      return path ~= "" and path or name
    end

    dap.adapters.python = {
      type = "executable",
      command = path_or("debugpy-adapter"),
    }
    dap.adapters.delve = {
      type = "server",
      port = "${port}",
      executable = {
        command = path_or("dlv"),
        args = { "dap", "-l", "127.0.0.1:${port}" },
      },
    }
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = path_or("codelldb"),
        args = { "--port", "${port}" },
      },
    }

    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Python: launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        justMyCode = false,
      },
    }

    dap.configurations.go = {
      {
        type = "delve",
        request = "launch",
        name = "Go: debug file",
        mode = "debug",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "delve",
        request = "launch",
        name = "Go: debug tests",
        mode = "test",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
    }

    -- nvim-dap reads .vscode/launch.json automatically whenever <F5> starts a
    -- new session. These configurations are the fallbacks for projects that do
    -- not have one, so per-project launch.json files just work with no extra
    -- setup or prompting.
    local native_launch = {
      type = "codelldb",
      request = "launch",
      name = "LLDB: launch executable",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      console = "integratedTerminal",
    }
    dap.configurations.c = { vim.deepcopy(native_launch) }
    dap.configurations.cpp = { vim.deepcopy(native_launch) }

    dap.configurations.java = dap.configurations.java or {}
    if #dap.configurations.java == 0 then
      table.insert(dap.configurations.java, {
        type = "java",
        request = "launch",
        name = "Java: launch main class",
        mainClass = function()
          return vim.fn.input("Main class: ", "", "file")
        end,
        console = "integratedTerminal",
      })
    end

    dap.configurations.rust = dap.configurations.rust or {}
    if #dap.configurations.rust == 0 then
      table.insert(dap.configurations.rust, vim.deepcopy(native_launch))
    end

    -- JavaScript / TypeScript / React debugging via Mason's js-debug-adapter.
    local function js_debug_adapter(callback)
      local ok, pkg = pcall(require("mason-registry").get_package, "js-debug-adapter")
      if ok and pkg and pkg:is_installed() then
        local server = vim.fs.joinpath(pkg:get_install_path(), "js-debug/src/dapDebugServer.js")
        if vim.fn.filereadable(server) == 1 then
          callback({
            type = "server",
            host = "127.0.0.1",
            port = "${port}",
            executable = { command = "node", args = { server, "${port}" } },
          })
          return
        end
      end

      local js_debug = vim.fn.exepath("js-debug-adapter")
      callback({
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = js_debug ~= "" and js_debug or "js-debug-adapter",
          args = { "${port}" },
        },
      })
    end

    dap.adapters["pwa-node"] = js_debug_adapter
    dap.adapters["pwa-chrome"] = js_debug_adapter

    local node_configs = {
      {
        type = "pwa-node",
        request = "launch",
        name = "JS/TS: Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        skipFiles = { "<node_internals>/**" },
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "JS/TS: Attach to process",
        processId = require("dap.utils").pick_process,
        skipFiles = { "<node_internals>/**" },
      },
    }

    local browser_configs = {
      {
        type = "pwa-chrome",
        request = "launch",
        name = "React: Chrome (http://localhost:5173)",
        url = "http://localhost:5173",
        webRoot = "${workspaceFolder}",
        sourceMaps = true,
      },
    }

    for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
      dap.configurations[ft] = vim.list_extend(vim.deepcopy(node_configs), vim.deepcopy(browser_configs))
    end

    -- Overseer is set up with dap=false so pressing a build key cannot pull the
    -- debugger in as a side effect. Now that DAP is loaded, enable its
    -- preLaunchTask/postDebugTask integration if Overseer is available.
    vim.defer_fn(function()
      local ok, overseer = pcall(require, "overseer")
      if ok and type(overseer.enable_dap) == "function" then
        overseer.enable_dap()
      end
    end, 0)

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticError", linehl = "", numhl = "" })
  end,
}
