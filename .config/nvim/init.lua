-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
print(lazypath)
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.json_conceal = false

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<Esc>', ':nohl<CR>', { silent = true })

vim.opt.hidden = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.opt.background = 'dark'
vim.opt.number = true
vim.opt.swapfile = false
vim.opt.autoindent = true
vim.opt.backspace = 'indent,eol,start'
vim.opt.complete:remove('i')
vim.opt.smarttab = true
vim.opt.nrformats:remove('octal')
vim.opt.termguicolors = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.mouse = 'a'
vim.opt.breakindent = true
vim.opt.signcolumn = "number"
vim.opt.incsearch = true
vim.opt.laststatus = 2
vim.opt.ruler = true
vim.opt.display:append("lastline")
vim.opt.autoread = true
vim.opt.tags:append(".tags")
vim.cmd("colo default")

-- Statusline configuration
vim.opt.statusline:append("")
vim.opt.statusline:append(" %f")                                       -- File path
vim.opt.statusline:append("%m")                                        -- Modified flag
vim.opt.statusline:append("%=")                                        -- Center alignment
vim.opt.statusline:append("%{get(b:,'gitsigns_head','')}")             -- Git branch
vim.opt.statusline:append("%#CursorColumn#")                           -- Highlight color
vim.opt.statusline:append(" %y")                                       -- File type
vim.opt.statusline:append(" %{&fileencoding?&fileencoding:&encoding}") -- File encoding
vim.opt.statusline:append("[%{&fileformat}]")                          -- File format
vim.opt.statusline:append(" %p%%")                                     -- File percentage

if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = [[powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))]],
      ["*"] = [[powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))]],
    },
    cache_enabled = 0,
  }
end


require("lazy").setup({
  spec = {
    {
      'nyoom-engineering/oxocarbon.nvim',
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd([[colo oxocarbon]])
      end
    },
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      },
    },
    {
      'nvim-telescope/telescope.nvim',
      event = 'VimEnter',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('telescope').setup {}

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<C-p>', builtin.find_files)
        vim.keymap.set('n', '<C-b>', builtin.buffers)
        vim.keymap.set('n', '<M-t>', builtin.lsp_dynamic_workspace_symbols)
        vim.keymap.set('n', '<M-g>', builtin.git_status)
        vim.keymap.set('n', '<M-f>', builtin.live_grep)
        vim.keymap.set('n', '<M-o>', builtin.lsp_document_symbols)
      end
    },
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      main = 'nvim-treesitter.configs',
      lazy = false,
      opts = {
        ensure_installed = {
          "python",
          "rust",
          "terraform",
          "bash",
          "vim",
          "javascript",
          "typescript",
          "glsl",
          "lua",
        },
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = { enable = true },
      },
    },
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
      },
      config = function()
        -- setup completions
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
        local lspconfig = require('lspconfig')
        local servers = {
          'pyright',
          'rust_analyzer',
          'gopls',
          'terraformls',
          'ts_ls',
          'lua_ls',
        }
        for _, lsp in ipairs(servers) do
          lspconfig[lsp].setup {
            capabilities = capabilities,
          }
        end

        -- Use LspAttach autocommand to only map the following keys
        -- after the language server attaches to the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('UserLspConfig', {}),
          callback = function(ev)
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

            local opts = { buffer = ev.buf }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<space>f', function()
              vim.lsp.buf.format { async = true }
            end, opts)
          end,
        })
      end
    },
    {
      'lewis6991/gitsigns.nvim',
      opts = {
        on_attach = function()
          vim.wo.signcolumn = "yes"
        end
      }
    },
    {
      'lukas-reineke/indent-blankline.nvim',
      main = "ibl",
      ---@module "ibl"
      ---@type ibl.config
      opts = {},
    },
    { 'tpope/vim-sleuth' },
    {
      'mhinz/vim-startify',
      init = function()
        vim.g.startify_custom_header = {}
      end
    },
    {
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/vim-vsnip',
      },
      config = function()
        local cmp = require 'cmp'
        cmp.setup {
          snippet = {
            expand = function(args)
              vim.fn["vsnip#anonymous"](args.body)
            end
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          }),
          sources = {
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
            { name = 'buffer' },
          },
        }

        cmp.setup.cmdline({ '/', '?' }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' }
          }
        })

        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline' }
          })
        })

        vim.opt.list = true
        vim.opt.listchars:append "eol:↴"
      end
    },
    {
      'windwp/nvim-autopairs',
      event = 'InsertEnter',
      dependencies = { 'hrsh7th/nvim-cmp' },
      config = function()
        require('nvim-autopairs').setup {}
        local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
        local cmp = require 'cmp'
        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
      end,
    }
  },
  install = { colorscheme = { 'oxocarbon' } },
  checker = { enabled = true },
})
