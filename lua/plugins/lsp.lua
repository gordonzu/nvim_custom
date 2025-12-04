-- lsp.lua
-- Per-server opt-in to prefer a user-local binary (e.g. in ~/.local/bin) or let Mason manage it.
-- Drop this into your plugin config (the same place you had your previous lsp.lua).

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      	'williamboman/mason-lspconfig.nvim',
      	'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      	'hrsh7th/cmp-nvim-lsp',
    },
    config = function()

			local has_new_diag = vim.fn.has("nvim-0.10") == 1

			vim.diagnostic.config({
  			virtual_text = false,
  			virtual_lines = has_new_diag,  -- true on 0.10+, false otherwise
  			signs = true,
  			underline = true,
  			update_in_insert = false,
  			severity_sort = true,
  			float = {
    			border = "rounded",
    			source = "if_many",
    			focusable = false,
  			},
			})


      -- Prefer user-local binaries by putting ~/.local/bin first in Neovim's PATH.
      -- This lets vim.fn.exepath() find user-installed servers before system/Mason ones.
      vim.env.PATH = vim.fn.expand("~/.local/bin:") .. vim.env.PATH

      -- Toggle per-server: true = prefer local binary, false = prefer Mason-managed
      local prefer_local = {
        lua_ls  = true,
        pyright = true,
        clangd  = true,
      }

      -- What local binary names (and args) to look for when prefer_local is true.
      -- First element is the executable name looked up with exepath().
      local local_bins = {
        lua_ls  = { "lua-language-server" },           -- adjust if your binary needs args
        pyright = { "pyright-langserver", "--stdio" }, -- pyright-langserver usually uses --stdio
        clangd  = { "clangd" },                        -- clangd typically needs no extra args
      }

      -- Utility: check whether local binary exists and return a cmd table or nil.
      local function local_cmd_for(server_name)
        local info = local_bins[server_name]
        if not info then return nil end
        local exe = vim.fn.exepath(info[1])
        if exe == "" then return nil end
        local cmd = { exe }
        for i = 2, #info do table.insert(cmd, info[i]) end
        return cmd
      end

      -- Servers definitions; we will set `cmd` to the local cmd if found (and preferred),
      -- otherwise leave cmd = nil to let lspconfig/mason-lspconfig supply the default.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local all_server_names = { "lua_ls", "pyright", "clangd" }

      local servers = {}
      local ensure_installed = {} -- list passed to mason-tool-installer (only servers we want Mason to install)

      for _, name in ipairs(all_server_names) do
        local server_conf = {
          filetypes = (name == "lua_ls") and { "lua" } or nil,
          capabilities = capabilities,
        }

        if prefer_local[name] then
          local cmd = local_cmd_for(name)
          if cmd then
            server_conf.cmd = cmd
            -- optional: notify user which local binary is used
            vim.notify(string.format("Using local %s: %s", name, table.concat(cmd, " ")), vim.log.levels.INFO)
          else
            -- local requested but not found -> fall back to Mason/default
            table.insert(ensure_installed, name)
            vim.schedule(function()
              vim.notify(string.format("Local binary for %s not found; Mason will be used when available.", name), vim.log.levels.WARN)
            end)
          end
        else
          -- prefer Mason/system: ensure Mason installs it
          table.insert(ensure_installed, name)
        end

        -- server-specific settings (example for lua_ls)
        if name == "lua_ls" then
          server_conf.settings = {
            Lua = {
              completion = { callSnippet = "Replace" },
              workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            },
          }
        end

        servers[name] = server_conf
      end

      -- Always ensure stylua is installed for formatting (adjust if not desired)
      table.insert(ensure_installed, "stylua")

      -- Setup mason-tool-installer with only the servers we want Mason to manage
      require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

      -- Setup mason-lspconfig and lspconfig - handlers will use our servers table
      require('mason-lspconfig').setup({
        ensure_installed = ensure_installed,
        handlers = {
          function(server_name) -- default handler
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      })

      -- LspAttach autocmd example (keymaps, highlights) -- keep whatever you already use.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end
          local buf = args.buf
          local function buf_map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
          end
          buf_map('n', 'gd', vim.lsp.buf.definition, 'LSP: goto def')
          buf_map('n', 'gr', vim.lsp.buf.references, 'LSP: refs')
        end,
      })
    end,
  },
}
