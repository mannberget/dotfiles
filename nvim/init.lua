--------------------- HELPERS --------------------
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------------------- OPTIONS --------------------

opt.guicursor = ""


opt.number = true                   -- show line numbers

opt.visualbell = true

opt.tabstop = 2                     -- number of spaces tabs count for
opt.softtabstop = 2
opt.shiftwidth = 2                  -- size of an indent
opt.expandtab = true

opt.hlsearch = true                 -- highlight searches
opt.incsearch = true

opt.scrolloff = 6
opt.laststatus = 2

opt.splitbelow = true               -- put new windows below current
opt.splitright = true               -- put new windows right of current

opt.smartindent = true              -- insert indents automatically

opt.termguicolors = true            -- true color support

opt.wrap = false

opt.mouse = "a"

g.mapleader = " "

-- enable undos between sessions
cmd([[set undofile]])

cmd [[
if has("autocmd")
  autocmd BufWritePost *.md !pandoc % -o %:r.pdf --mathjax=~/mathjax/es5/core.js && open %:r.pdf
endif
]]

-- enable that we go back to last position in file
cmd [[
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif
]]

-- netrw settings
g.netrw_banner = 0                  -- disable banner
g.newrw_winsize = 25                -- explore is 25% of screen
g.netrw_altv = 1                    -- open splits to right
g.netrw_liststyle=3                 -- tree view

-------------------- PLUGINS -------------------

local packer = require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'sainnhe/sonokai'

    use 'nvim-treesitter/nvim-treesitter'

    -- use {
    --     'neoclide/coc.nvim',
    --     branch = 'release'
    -- }

    use {"terrortylor/nvim-comment"}

    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    use 'jpalardy/vim-slime'

    -- use 'JuliaEditorSupport/julia-vim'

    use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
    use 'hrsh7th/nvim-cmp'      -- Autocompletion plugin
    use 'hrsh7th/cmp-nvim-lsp'  -- LSP source for nvim-cmp

    use({"L3MON4D3/LuaSnip", tag = "v<CurrentMajor>.*"})

end)

-- cmd 'colorscheme tender'
-- cmd 'colorscheme hybrid'
cmd 'colorscheme sonokai'
-------------------- TREE-SITTER ----------------
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "cpp", "lua", "rust", "markdown", "latex", "julia", "python"},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
-------------------- COC ------------------------
opt.encoding = "utf-8"
-- opt.hidden = true
opt.cmdheight = 2
-- opt.updatetime = 300    
-- opt.signcolumn = "number"

-- -- enable tab to trigger completion
-- cmd [[
-- inoremap <silent><expr> <TAB>
--       \ coc#pum#visible() ? coc#pum#next(1):
--       \ CheckBackspace() ? "\<Tab>" :
--       \ coc#refresh()
-- inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
--
-- inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
--                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
--
-- function! CheckBackspace() abort
--   let col = col('.') - 1
--   return !col || getline('.')[col - 1]  =~# '\s'
-- endfunction
--
-- autocmd CursorHold * silent call CocActionAsync('highlight')
--
-- nmap <leader>rn <Plug>(coc-rename)
-- ]]

-------------------- NVIM COMMENT ---------------
require('nvim_comment').setup {
    line_mapping = "<leader>cc",
    operator_mapping = "<leader>c"
    --comment_chunk_text_object = "",
}
-------------------- TELESCOPE  -----------------
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key"
      }
    }
  }
}

map('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>") -- telescope find files
map('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>") -- telescope find files
-------------------- LUALINE --------------------
require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = 'seoul256'
    }
}
-------------------- VIMSLIME--------------------
g.slime_target = "tmux"
cmd [[
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
]]
g.slime_cell_delimiter = "#%%"
map('n', '<leader>s', '<Plug>SlimeSendCell')
-------------------- NVIM-CMP -------------------
vim.opt.completeopt = {"menu", "menuone", "noselect"}

local cmp = require('cmp')
local cmp_types = require('cmp.types')
local source_mapping = {buffer = '[Buffer]', nvim_lsp = '[LSP]'}

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<C-f>'] = cmp.mapping.scroll_docs( 4),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
    {
        { name = 'buffer' },
    }),
    completion = {keyword_length = 3},
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = source_mapping[entry.source.name]
            return vim_item
        end,
    },
})

-------------------- LSP ----------------------
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', 'gE', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', 'ge', vim.diagnostic.goto_next, opts)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufopts)
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<space>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, bufopts)
  -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require('lspconfig')['rust_analyzer'].setup{
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {}
    }
}

require('lspconfig')['julials'].setup{
    -- capabilities = create_capabilities(),
    on_new_config = function(new_config, _)
      local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
      if require'lspconfig'.util.path.is_file(julia) then
        new_config.cmd[1] = julia
      end
    end,
    root_dir = function(fname)
        local util = require'lspconfig.util'
        return util.root_pattern 'Project.toml'(fname) or util.find_git_ancestor(fname) or
               util.path.dirname(fname)
    end,
    on_attach = on_attach,
    capabilities = capabilities,
}
-------------------- MAPPINGS -------------------
map('n', '<leader>o', 'o<Esc>')                 -- insert newline from normal mode
map('n', '<leader>O', 'O<Esc>')                 -- insert newline from normal mode
map('n', '<leader>e', '<cmd>Explore<CR>')       -- show file explorer

map('n', '<C-j>', '3<C-e>3j')                   -- fast scrolling
map('n', '<C-k>', '3<C-y>3k')                   -- fast scrolling

map('n', '<C-h>', '<C-w>h')                     -- fast window switch
map('n', '<C-l>', '<C-w>l')                     -- fast window switch

map('n', '<leader>y', '"+y')                   -- copy to clipboard
map('v', '<leader>y', '"+y')                   -- copy to clipboard
