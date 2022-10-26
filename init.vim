set exrc
set relativenumber
set nu
set nohlsearch
set hidden
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set signcolumn=yes
set splitbelow
set splitright

highlight ColorColumn ctermbg=gray
set colorcolumn=80

let mapleader = " "

call plug#begin("~/.config/nvim/plugged")
    "lsp, code completion etc.
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'L3MON4D3/LuaSnip'

    "git & search tools
    Plug 'tpope/vim-fugitive'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'

    "quality of life
    Plug 'preservim/nerdcommenter'
    Plug 'tpope/vim-surround'
    Plug 'mbbill/undotree'
    
    "theme
    Plug 'gruvbox-community/gruvbox'
    Plug 'hoob3rt/lualine.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'ryanoasis/vim-devicons'
call plug#end()

"global remaps
tnoremap <Esc> <C-\><C-n>
nnoremap <leader>+ :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :b#<CR>
nnoremap <leader>t :10sp<bar>te<CR>

"theme : gruvbox & lualine
colorscheme gruvbox
set background=dark
highlight Normal guibg=none
lua require'lualine'.setup{} 

"telescope
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

"git
nnoremap <leader>gf :G fetch --all<CR>
nnoremap <leader>gs :G<CR>
nnoremap <leader>ga :G add .<CR>
nnoremap <leader>gc :G commit<CR>
nnoremap <leader>gp :G push<CR>

"lsp & treesitter
set completeopt=menuone,noinsert,noselect

lua << EOF
-- Configure completion
local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
        require('luasnip').lsp_expand(args.body) 
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local nvim_lsp = require('lspconfig')
-- Use a loop to conveniently call 'setup' on multiple servers
local servers = { "pyright", "rust_analyzer", "tsserver", "ltex" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { capabilities = capabilities }
end
EOF

nnoremap <leader>vd :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>vi :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>vsh :lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>vrr :lua vim.lsp.buf.references()<CR>
nnoremap <leader>vrn :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>vh :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>vca :lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>vsd :lua vim.lsp.diagnostic.show_line_diagnostics(); vim.lsp.util.show_line_diagnostics()<CR>
nnoremap <leader>vn :lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <leader>vll :lua vim.lsp.diagnostic.set_loclist({open_loclist = false})<CR>

