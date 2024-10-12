return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "olimorris/neotest-rspec",
      "haydenmeade/neotest-jest",
      "zidhuss/neotest-minitest",
      "mfussenegger/nvim-dap",
      "jfpedroza/neotest-elixir",
      "weilbith/neotest-gradle",
      "nvim-neotest/neotest-go",
    },
    opts = {},
    config = function()
      local neotest = require "neotest"

      local neotest_jest = require "neotest-jest" {
        jestCommand = "npm test --",
      }
      neotest_jest.filter_dir = function(name) return name ~= "node_modules" and name ~= "__snapshots__" end

      neotest.setup {
        adapters = {
          require "neotest-gradle",
          require "neotest-rspec" {
            rspec_cmd = function()
              return vim.tbl_flatten {
                "bundle",
                "exec",
                "rspec",
              }
            end,
          },
          neotest_jest,
          require "neotest-minitest",
          require "neotest-elixir",
          require "neotest-go",
        },
        output_panel = {
          enabled = true,
          open = "botright split | resize 15",
        },
        quickfix = {
          open = false,
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function(_, opts)
      local dap = require "dap"
      local dapui = require "dapui"
      -- dap.set_log_level "INFO"
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
      dapui.setup(opts)
    end,
    requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },
  {
    "leoluz/nvim-dap-go",
    config = function() require("dap-go").setup {} end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {},
  },
  { "jbyuki/one-small-step-for-vimkind", module = "osv" },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function(_, opts)
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
    end,
  },
}
