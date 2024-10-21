local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

opt.compatible = false              --
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
opt.splitright = true               -- put new windows right of current
opt.smartindent = true              -- insert indents automatically
opt.termguicolors = true            -- true color support
opt.wrap = false
opt.mouse = "a"
opt.encoding = "utf-8"

opt.cmdheight = 2

opt.wildmenu = true

g.mapleader = " "

opt.path:append({'.', '**'})

g.netrw_banner = 0                  -- disable banner
g.newrw_winsize = 25                -- explore is 25% of screen
g.netrw_altv = 1                    -- open splits to right
g.netrw_liststyle=3                 -- tree view
g.netrw_use_errorwindow = 0         -- popup window (2) doesn't work in nvim, use echoerr instead
g.netrw_sizestyle = "H"
g.netrw_list_hide = vim.fn['netrw_gitignore#Hide']() .. [[,.git/]]
g.netrw_sort_sequence = [[[\/]$,*]] -- sort directories first
g.netrw_keepdir = 0                 -- keep main directory




cmd [[
  colorscheme zaibatsu
  hi MatchParen guibg=white guifg=DarkRed
]]

map('n', '<C-j>', '4<C-e>4j')                   -- fast scrolling
map('n', '<C-k>', '4<C-y>4k')                   -- fast scrolling
map('n', '<leader>o', 'o<Esc>')                 -- insert newline from normal mode
map('n', '<leader>O', 'O<Esc>')                 -- insert newline from normal mode
map('n', '<leader>e', '<cmd>Rexplore<CR>')       -- show file explorer
map('n', '<leader>E', '<cmd>Vexplore<CR>')      -- show file explorer vsplit

map("n", "<leader>f", ":find *")                -- split window vertically
map("n", "<leader>b", ":b ")                -- split window vertically
map("n", "<leader>sv", "<C-w>v")                -- split window vertically
map("n", "<leader>sh", "<C-w>s")                -- split window horizontally
map("n", "<leader>se", "<C-w>=")                -- make split windows equal width & height
map("n", "<leader>sx", ":close<CR>")            -- close current split window
