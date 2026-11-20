-- Build and task runner. The smart <leader>bb build adapts to the project and
-- sends compiler output to the quickfix list so errors can be stepped through.
local function exists(path)
  return vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1
end

local function project_root()
  local root = vim.fs.root(vim.api.nvim_get_current_buf(), {
    ".git",
    "CMakeLists.txt",
    "Makefile",
    "makefile",
    "Cargo.toml",
    "package.json",
    "go.mod",
    "pyproject.toml",
  })
  return root or vim.fn.getcwd()
end

local function package_scripts(root)
  local ok, lines = pcall(vim.fn.readfile, root .. "/package.json")
  if not ok then
    return {}
  end
  local ok_json, pkg = pcall(vim.json.decode, table.concat(lines, "\n"))
  if ok_json and type(pkg) == "table" and type(pkg.scripts) == "table" then
    return pkg.scripts
  end
  return {}
end

local function cmake_cache_stale(root)
  local ok, lines = pcall(vim.fn.readfile, root .. "/build/CMakeCache.txt")
  if not ok then
    return false
  end
  local current = vim.fn.resolve(root)
  for _, line in ipairs(lines) do
    local cached = line:match("^CMAKE_HOME_DIRECTORY:INTERNAL=(.*)$")
    if cached then
      return vim.fn.resolve(cached) ~= current
    end
  end
  return false
end

local function detect_build(root)
  if exists(root .. "/build/build.ninja") or exists(root .. "/build/Makefile") then
    if cmake_cache_stale(root) then
      return {
        name = "CMake: refresh cache + build",
        cmd = "cmake -S . -B build --fresh && cmake --build build --parallel",
      }
    end
    return {
      name = "CMake: build",
      cmd = { "cmake", "--build", "build", "--parallel" },
    }
  elseif exists(root .. "/CMakeLists.txt") then
    return {
      name = "CMake: configure + build",
      cmd = "cmake -S . -B build && cmake --build build --parallel",
    }
  elseif exists(root .. "/Makefile") or exists(root .. "/makefile") then
    return { name = "Make", cmd = { "make", "-j" } }
  elseif exists(root .. "/Cargo.toml") then
    return { name = "Cargo: build", cmd = { "cargo", "build" } }
  elseif exists(root .. "/go.mod") then
    return { name = "Go: build", cmd = { "go", "build", "./..." } }
  elseif exists(root .. "/package.json") then
    local scripts = package_scripts(root)
    if scripts.build then
      return { name = "npm: build", cmd = { "npm", "run", "build" } }
    end
  end
  return nil
end

local function quickfix_components()
  return {
    {
      "on_output_quickfix",
      errorformat = vim.o.errorformat,
      items_only = true,
      tail = true,
      open = false,
      open_on_exit = "failure",
      open_height = 8,
    },
    "default",
  }
end

local function build_project()
  local overseer = require("overseer")
  local root = project_root()
  local spec = detect_build(root)

  if not spec then
    vim.notify("No build system detected; opening the task picker", vim.log.levels.INFO)
    vim.cmd("OverseerRun")
    return
  end

  local task = overseer.new_task({
    name = spec.name,
    cmd = spec.cmd,
    cwd = root,
    components = quickfix_components(),
  })
  task:start()
end

local function finished_tasks()
  local overseer = require("overseer")
  local task_list = require("overseer.task_list")
  return overseer.list_tasks({
    status = { overseer.STATUS.SUCCESS, overseer.STATUS.FAILURE, overseer.STATUS.CANCELED },
    sort = task_list.sort_finished_recently,
  })
end

local function restart_last_task()
  local tasks = finished_tasks()
  if #tasks == 0 then
    vim.notify("No finished task to restart", vim.log.levels.WARN)
    return
  end
  require("overseer").run_action(tasks[1], "restart")
end

local function open_last_output()
  local tasks = finished_tasks()
  if #tasks == 0 then
    vim.notify("No task output to open", vim.log.levels.WARN)
    return
  end
  require("overseer").run_action(tasks[1], "open float")
end

return {
  "stevearc/overseer.nvim",
  cmd = {
    "OverseerRun",
    "OverseerOpen",
    "OverseerClose",
    "OverseerToggle",
    "OverseerShell",
    "OverseerTaskAction",
    "Build",
  },
  keys = {
    { "<leader>bb", function() build_project() end, desc = "Build: current project" },
    { "<leader>bt", "<cmd>OverseerToggle<CR>", desc = "Tasks: toggle task list" },
    { "<leader>br", function() restart_last_task() end, desc = "Tasks: restart last task" },
    { "<leader>bo", function() open_last_output() end, desc = "Tasks: open last output" },
  },
  opts = {
    -- DAP is enabled later from nvim-dap's config, so a build key never loads
    -- the debugger as a side effect.
    dap = false,
    output = { use_terminal = true },
    task_list = {
      direction = "bottom",
      min_height = 8,
      max_height = { 16, 0.25 },
    },
    form = { border = "rounded" },
    task_win = { border = "rounded" },
  },
  config = function(_, opts)
    local overseer = require("overseer")
    overseer.setup(opts)

    vim.api.nvim_create_user_command("Build", function()
      build_project()
    end, { desc = "Build the current project" })
  end,
}
