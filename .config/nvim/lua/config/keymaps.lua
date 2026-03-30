-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- New navigation keys based on German keyboard layout
map('n', 'j', 'h', opts)
map('n', 'k', 'j', opts)
map('n', 'l', 'k', opts)
map('n', 'ö', 'l', opts)

-- Also apply in  visual mode
map('v', 'j', 'h', opts)
map('v', 'k', 'j', opts)
map('v', 'l', 'k', opts)
map('v', 'ö', 'l', opts)

-- Also apply to buffer / window switching
map("n", "<C-j>", "<C-w>h", opts) -- window left
map("n", "<C-k>", "<C-w>j", opts) -- window down
map("n", "<C-l>", "<C-w>k", opts) -- window up
map("n", "<C-ö>", "<C-w>l", opts) -- window right

-- Buffer switching (previously H / L)
map("n", "J", "<cmd>bprevious<cr>", opts)  -- was H (prev buffer)
map("n", "Ö", "<cmd>bnext<cr>", opts)      -- was L (next buffer)

-- Free up h, since this isn't used now anymore
map('n', 'h', '<Nop>', opts)
map('v', 'h', '<Nop>', opts)

