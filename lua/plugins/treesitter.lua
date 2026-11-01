return {
    "nvim-treesitter/nvim-treesitter", 
    build = ":TSUpdate",
    config = function()
      -- pcall (protected call) prevents the crash if the plugin isn't cloned yet
      local status_ok, configs = pcall(require, "nvim-treesitter.configs")
      if not status_ok then
        return
      end
      
      configs.setup({
        ensure_installed = { "lua", "javascript", "c", "cpp", "python", "java", "go", "rust" },
        highlight = { enable = true },
        indent = { enable = true }
      })
    end
  }

