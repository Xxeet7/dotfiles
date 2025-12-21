-- ================================================================================================
-- TITLE : Typst-preview
-- ABOUT : A Neovim plugin to preview Typst files in real-time.
-- LINKS : https://github.com/chomosuke/typst-preview.nvim
-- ================================================================================================

return {
  'chomosuke/typst-preview.nvim',
  -- lazy = false, 
  ft = 'typst',
  version = '1.*',
  opts = {}, -- lazy.nvim will implicitly calls `setup {}`
}
