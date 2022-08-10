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

opt.tabstop = 4                     -- number of spaces tabs count for
opt.softtabstop = 4
opt.shiftwidth = 4                  -- size of an indent
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

    -- use 'jacoborus/tender.vim'
    -- use 'w0ng/vim-hybrid'
    use 'sainnhe/sonokai'

    use 'nvim-treesitter/nvim-treesitter'

    use {
        'neoclide/coc.nvim',
        branch = 'release'
    }

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

end)

-- cmd 'colorscheme tender'
-- cmd 'colorscheme hybrid'
cmd 'colorscheme sonokai'
-------------------- TREE-SITTER ----------------
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "cpp", "lua", "rust" },

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
opt.hidden = true
opt.cmdheight = 2
opt.updatetime = 300    
opt.signcolumn = "number"
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
-------------------- MAPPINGS -------------------
map('n', '<leader>o', 'o<Esc>')                 -- insert newline from normal mode
map('n', '<leader>O', 'O<Esc>')                 -- insert newline from normal mode
map('n', '<leader>e', '<cmd>Explore<CR>')       -- show file explorer

map('n', '<C-j>', '3<C-e>3j')                   -- fast scrolling
map('n', '<C-k>', '3<C-y>3k')                   -- fast scrolling
