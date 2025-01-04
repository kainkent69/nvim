local M = {}

-- [
-- Setting Up
local telescopeOptions = {
  -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  cmd = 'Telescope',
  lazy = true,
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'andrew-george/telescope-themes',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- the themes
    local telescope = require 'telescope'
    telescope.load_extension 'themes'
    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    telescope.setup {

      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`

      defaults = {
        mappings = {
          i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        },
      },

      pickers = {
        find_files = {
          hidden = true,
        },
      },

      extensions = {
        themes = {},
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },

        --other configuration
        -- all builtin themes are ignored by default
        -- (list) -> provide table of theme names to overwrite builtins list
        ignore = { 'default', 'desert', 'elflord', 'habamax' },
      },
    }

    local builtin = require 'telescope.builtin'
    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    -- Setup the keymaps
    require('keymaps.init').setup()
    local function add_newline_not_insert()
      vim.api.nvim_feedkeys('o', 'n', false)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
    end

    -- the add new keymapping
    vim.keymap.set('n', 'gk', add_newline_not_insert, { desc = 'Add new line' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}

-- setup the telescope
M.setup = function()
  return { telescopeOptions }
end

return M
