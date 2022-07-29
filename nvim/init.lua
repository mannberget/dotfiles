-------------------- HELPERS --------------------
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


opt.tabstop = 4                     -- number of spaces tabs count for
opt.softtabstop = 4
opt.shiftwidth = 4                  -- size of an indent
opt.expandtab = true

opt.hlsearch = true                 -- highlight searches
opt.incsearch = true


opt.splitbelow = true               -- put new windows below current
opt.splitright = true               -- put new windows right of current

opt.smartindent = true              -- insert indents automatically

opt.termguicolors = true            -- true color support

opt.wrap = false

opt.mouse = "a"

g.mapleader = " "

-- netrw settings
g.netrw_banner = 0                  -- disable banner
g.newrw_winsize = 25                -- explore is 25% of screen
g.netrw_altv = 1                    -- open splits to right
g.netrw_liststyle=3                 -- tree view



-------------------- PLUGINS -------------------
cmd 'packadd paq-nvim'               -- load the package manager

local paq = require('paq-nvim').paq  -- a convenient alias

paq {'nvim-treesitter/nvim-treesitter'}

-------------------- TREE-SITTER ----------------
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "rust" },

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
-------------------- MAPPINGS -------------------

map('n', '<leader>o', 'o<Esc>')                     -- insert newline from normal mode
map('n', '<leader>e', ':Vexplore<CR>')              -- show file explorer


