if empty(glob('~/.local/share/nvim/site/autoload/plug.vim')) && has('nvim')
    silent !sh -c 'curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.vim/plugged')

"
" Themes
"
Plug 'bluz71/vim-moonfly-colors', { 'as': 'moonfly' }
Plug 'nyoom-engineering/oxocarbon.nvim'

Plug 'Vimjas/vim-python-pep8-indent'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'tpope/vim-sleuth'

Plug 'mhinz/vim-startify'
let g:startify_custom_header = []

"
" Completions
"
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

call plug#end()
"
" Custom maps
"
map <Esc> :noh<CR>
nnoremap <C-p> <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <C-b> <cmd>lua require('telescope.builtin').buffers()<CR>
nnoremap <M-t> <cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>
nnoremap <M-g> <cmd>lua require('telescope.builtin').git_status()<CR>
nnoremap <M-f> <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <M-o> <cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>
map <C-Space> gcc<CR>
vmap <C-Space> gc<CR>


" Annoying defaults
let g:vim_json_conceal=0

if has('autocmd')
    filetype plugin indent on
    filetype plugin on
endif

if has('syntax') && !exists('g:syntax_on')
    syntax enable
endif

" Use :help 'option' to see the documentation for the given option.
set hidden
set nobackup
set nowritebackup
set updatetime=300
set nocompatible
set background=dark
set number
set noswapfile
set autoindent
set backspace=indent,eol,start
set complete-=i
set smarttab
set nrformats-=octal
set termguicolors
set t_Co=256
set clipboard+=unnamed
set splitright
set mouse=a
colorscheme oxocarbon

set guifont=Fira\ Code\ Retina:h14
set guioptions-=r
set guioptions-=L
if !has('nvim') && &ttimeoutlen == -1
    set ttimeout
    set ttimeoutlen=100
endif

set signcolumn=number

set tabstop=4
set shiftwidth=4
set incsearch
set laststatus=2
set ruler
set display+=lastline
set autoread
set tags+=.tags

set statusline=
set statusline+=\ %f
set statusline+=%m
set statusline+=%=
set statusline+=%{get(b:,'gitsigns_head','')}
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%

"
" WSL specific tweaks
"
if has('wsl')
    let g:clipboard = {
    \   'name': 'WslClipboard',
    \   'copy': {
    \      '+': 'clip.exe',
    \      '*': 'clip.exe',
    \    },
    \   'paste': {
    \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    \   },
    \   'cache_enabled': 0,
    \ }
endif

""" Configs in Lua
lua <<EOF
-- gitsigns
require('gitsigns').setup{
    signcolumn=auto,
    on_attach=function()
        vim.wo.signcolumn = "yes"
    end
}

require('telescope').setup{
    defaults = {
        preview = {
            treesitter = false
        }
    }
}

-- setup completions
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local lspconfig = require('lspconfig')
local servers = { 'pyright', 'rust_analyzer', 'gopls', 'terraformls', 'ts_ls' }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        capabilities=capabilities,
    }
end

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
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

require('nvim-treesitter.configs').setup {
    ensure_installed = { "python", "rust", "terraform", "bash", "vim", "javascript", "typescript" },
    highlight = {
        enable = true,
        disable = { "json" },
    },
    indent = {
        enabled = true,
        disable = { 'python' },
    }
}

-- nvim-cmp setup
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

require("ibl").setup()
EOF
