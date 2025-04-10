-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'julianolf/nvim-dap-lldb',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    local cfg = {
      configurations = {
        -- C lang configurations (you can adjust this as needed)
        c = {
          {
            name = 'Launch GDB',
            type = 'gdb', -- Use 'gdb' as the type
            request = 'launch',
            cwd = '${workspaceFolder}',
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            args = {},
            MIMode = 'gdb', -- Specify the MI mode for GDB
            setupCommands = {
              {
                text = '-enable-pretty-printing',
                description = 'Enable pretty printing of gdb objects',
                ignoreFailures = true,
              },
            },
          },
          {
            name = 'Attach to GDB',
            type = 'gdb',
            request = 'attach',
            cwd = '${workspaceFolder}',
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            pid = function()
              return vim.fn.input('PID to attach to: ', '', 'number')
            end,
            MIMode = 'gdb',
            setupCommands = {
              {
                text = '-enable-pretty-printing',
                description = 'Enable pretty printing of gdb objects',
                ignoreFailures = true,
              },
            },
          },
        },
        -- Add configurations for other languages here if needed
      },
    }

    -- Register the GDB adapter
    dap.adapters.gdb = {
      type = 'executable',
      command = 'gdb', -- Path to the GDB executable
      args = { '--interpreter=mi' }, -- Important for DAP communication
    }

    -- Existing adapter configurations (keep these)
    dap.adapters.executable = { -- This might be for codelldb, keep if you use it
      type = 'executable',
      command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
      name = 'lldb1',
      host = '127.0.0.1',
      port = 13000,
    }

    dap.adapters.codelldb = { -- Keep this if you use codelldb
      name = 'codelldb server',
      type = 'server',
      port = '${port}',
      executable = {
        command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
        args = { '--port', '${port}' },
      },
    }

    -- You might not need this if you're explicitly configuring GDB
    -- require('dap-lldb').setup(cfg)

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve',
        -- Add 'gdb' here if mason should try to install a GDB adapter (might not be necessary)
      },
    }

    -- Dap UI setup (keep this)
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Breakpoint icons (keep this)
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Golang specific config (keep this if you debug Go)
    require('dap-go').setup {
      delve = {
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
