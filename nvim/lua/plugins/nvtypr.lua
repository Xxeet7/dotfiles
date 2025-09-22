-- ================================================================================================
-- TITLE : Typr
-- ABOUT : adds typing practice and statistics to Neovim
-- LINKS : https://github.com/nvzone/typr
-- ================================================================================================

return {
  "nvzone/typr",
  lazy = true,
  dependencies = "nvzone/volt",
  opts = {},
  cmd = { "Typr", "TyprStats" },
}
