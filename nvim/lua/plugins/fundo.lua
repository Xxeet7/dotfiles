-- ================================================================================================
-- TITLE : nvim-fundo
-- ABOUT : Forever undo in Neovim
-- LINKS : https://github.com/kevinhwang91/nvim-fundo
-- ================================================================================================

return {
  "kevinhwang91/nvim-fundo",
  config = function()
    require('fundo').install()
    require("fundo").setup()
  end,
}
