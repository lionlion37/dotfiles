-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- VimTeX
vim.g.vimtex_compiler_method = "latexmk"

vim.g.vimtex_compiler_latexmk = {
  executable = "latexmk",
  continuous = 1, -- set to 0 if you want *no* background/continuous mode
  callback = 1,
  options = {
    "-xelatex",
    "-file-line-error",
    "-interaction=nonstopmode",
    "-synctex=1",
    -- "-halt-on-error",  -- optional: stops faster when something goes wrong
  },
}

-- Viewer
vim.g.vimtex_view_method = "general"
vim.g.vimtex_view_general_viewer = "SumatraPDF"

-- biber (fine)
vim.g.vimtex_bib_backend = "biber"

-- Spell check for thesis
vim.opt.spell = true
vim.opt.spelllang = { "en_us", "de" } -- English + German
