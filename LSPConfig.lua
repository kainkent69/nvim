local m = {}

m.setup = function()
  return {
    {
      -- `lazydev` configures lua lsp for your neovim config, runtime and plugins
      -- used for completion, annotations and signatures of neovim apis
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          -- load luvit types when the `vim.uv` word is found
          { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        },
      },
    },
    { 'bilal2453/luvit-meta', lazy = true },
    {
      -- main lsp configuration
      'neovim/nvim-lspconfig',
      opts = {
        inlay_hints = { enabled = true },
      },

      dependencies = {
        -- automatically install lsps and related tools to stdpath for neovim
        { 'williamboman/mason.nvim', config = true }, -- note: must be loaded before dependants
        'williamboman/mason-lspconfig.nvim',
        'whoissethdaniel/mason-tool-installer.nvim',

        -- useful status updates for lsp.
        -- note: `opts = {}` is the same as calling `require('fidget').setup({})`
        { 'j-hui/fidget.nvim', opts = {} },

        -- allows extra capabilities provided by nvim-cmp
        'hrsh7th/cmp-nvim-lsp',
      },
      config = function()
        vim.api.nvim_create_autocmd('lspattach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
          callback = function(event)
            -- note: remember that lua is a real programming language, and as such it is possible
            -- to define small helper and utility functions so you don't have to repeat yourself.
            --
            -- in this case, we create a function that lets us more easily define mappings specific
            -- for lsp related items. it sets the mode, buffer and description for us each time.
            local map = function(keys, func, desc, mode)
              mode = mode or 'n'
              vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'lsp: ' .. desc })
            end

            -- jump to the definition of the word under your cursor.
            --  this is where a variable was first declared, or where a function is defined, etc.
            --  to jump back, press <c-t>.
            map('gd', require('telescope.builtin').lsp_definitions, '[g]oto [d]efinition')

            -- find references for the word under your cursor.
            map('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')

            -- jump to the implementation of the word under your cursor.
            --  useful when your language has ways of declaring types without an actual implementation.
            map('gi', require('telescope.builtin').lsp_implementations, '[g]oto [i]mplementation')

            -- jump to the type of the word under your cursor.
            --  useful when you're not sure what type a variable is and you want to see
            --  the definition of its *type*, not where it was *defined*.
            map('<leader>td', require('telescope.builtin').lsp_type_definitions, 'type [d]efinition')

            -- fuzzy find all the symbols in your current document.
            --  symbols are things like variables, functions, types, etc.
            map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[d]ocument [s]ymbols')

            -- fuzzy find all the symbols in your current workspace.
            --  similar to document symbols, except searches over your entire project.
            map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[w]orkspace [s]ymbols')

            -- rename the variable under your cursor.
            --  most language servers support renaming across files, etc.
            map('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')

            -- execute a code action, usually your cursor needs to be on top of an error
            -- or a suggestion from your lsp for this to activate.
            map('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction', { 'n', 'x' })

            -- warn: this is not goto definition, this is goto declaration.
            --  for example, in c this would take you to the header.
            map('gd', vim.lsp.buf.declaration, '[g]oto [d]eclaration')

            -- the following two autocommands are used to highlight references of the
            -- word under your cursor when your cursor rests there for a little while.
            --    see `:help cursorhold` for information about when this is executed
            --
            -- when you move your cursor, the highlights will be cleared (the second autocommand).
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client.supports_method(vim.lsp.protocol.methods.textdocument_documenthighlight) then
              local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
              vim.api.nvim_create_autocmd({ 'cursorhold', 'cursorholdi' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
              })

              vim.api.nvim_create_autocmd({ 'cursormoved', 'cursormovedi' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
              })

              vim.api.nvim_create_autocmd('lspdetach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                callback = function(event2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                end,
              })
            end

            -- the following code creates a keymap to toggle inlay hints in your
            -- code, if the language server you are using supports them
            --
            -- this may be unwanted, since they displace some of your code
            if client and client.supports_method(vim.lsp.protocol.methods.textdocument_inlayhint) then
              map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
              end, '[t]oggle inlay [h]ints')
            end
          end,
        })

        -- change diagnostic symbols in the sign column (gutter)
        -- if vim.g.have_nerd_font then
        --   local signs = { error = '', warn = '', info = '', hint = '' }
        --   local diagnostic_signs = {}
        --   for type, icon in pairs(signs) do
        --     diagnostic_signs[vim.diagnostic.severity[type]] = icon
        --   end
        --   vim.diagnostic.config { signs = { text = diagnostic_signs } }
        -- end

        -- lsp servers and clients are able to communicate to each other what features they support.
        --  by default, neovim doesn't support everything that is in the lsp specification.
        --  when you add nvim-cmp, luasnip, etc. neovim now has *more* capabilities.
        --  so, we create new capabilities with nvim cmp, and then broadcast that to the servers.
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

        -- enable the following language servers
        --  feel free to add/remove any lsps that you want here. they will automatically be installed.
        --
        --  add any additional override configuration in the following tables. available keys are:
        --  - cmd (table): override the default command used to start the server
        --  - filetypes (table): override the default list of associated filetypes for the server
        --  - capabilities (table): override fields in capabilities. can be used to disable certain lsp features.
        --  - settings (table): override the default settings passed when initializing the server.
        --        for example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
        local servers = {
          -- clangd = {},
          -- gopls = {},
          -- pyright = {},
          -- rust_analyzer = {},
          -- ... etc. see `:help lspconfig-all` for a list of all the pre-configured lsps
          --
          -- some languages (like typescript) have entire language plugins that can be useful:
          --    https://github.com/pmizio/typescript-tools.nvim
          --
          -- but for many setups, the lsp (`ts_ls`) will work just fine
          -- ts_ls = {},
          --

          emmet_ls = {
            filetypes = {
              'html',
              'typescriptreact',
              'javascriptreact',
              'css',
              'sass',
              'scss',
              'less',
              'javascript',
              'typescript',
              'markdown',
              'ejs',
            },
            init_options = {
              html = {
                options = {
                  ['bem.enabled'] = false,
                },
              },
            },
          },

          lua_ls = {
            -- cmd = {...},
            -- filetypes = { ...},
            -- capabilities = {},
            settings = {
              lua = {
                completion = {
                  callsnippet = 'replace',
                },
                -- you can toggle below to ignore lua_ls's noisy `missing-fields` warnings
                -- diagnostics = { disable = { 'missing-fields' } },
              },
            },
          },
        }

        -- ensure the servers and tools above are installed
        --  to check the current status of installed tools and/or manually install
        --  other tools, you can run
        --    :mason
        --
        --  you can press `g?` for help in this menu.
        require('mason').setup()

        -- you can add other tools here that you want mason to install
        -- for you, so that they are available from within neovim.
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
          'stylua', -- used to format lua code
        })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        require('mason-lspconfig').setup {
          ensure_installed = {},
          automatic_installation = true,
          handlers = {
            function(server_name)
              local server = servers[server_name] or {}
              -- this handles overriding only values explicitly passed
              -- by the server configuration above. useful when disabling
              -- certain features of an lsp (for example, turning off formatting for ts_ls)
              server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
              require('lspconfig')[server_name].setup(server)
            end,
          },
        }
      end,
    },
  }
end
return m
