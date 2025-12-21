-- ================================================================================================
-- TITLE : Treesj
-- ABOUT : A simple and configurable Neovim plugin to split and join code structures
-- LINKS : https://github.com/Wansmer/treesj
-- ================================================================================================

return {
  "Wansmer/treesj",
  cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
  dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
  opts = {
    use_default_keymaps = false,
  },
}
