-- ================================================================================================
-- TITLE : hop.nvim
-- ABOUT : Easy-motion like plugin for Neovim that allows you to jump anywhere in a document with as few keystrokes as possible.
-- LINKS : https://github.com/smoka7/hop.nvim
-- ================================================================================================

return {
  "smoka7/hop.nvim",
  event = "bufreadpre",
  version = "*",
  config = function()
    dofile(vim.g.base46_cache .. "hop")
    require("hop").setup {
      keys = "etovxqpdygfblzhckisuran",
    }
  end,
}
