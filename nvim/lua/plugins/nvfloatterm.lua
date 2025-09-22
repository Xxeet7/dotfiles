-- ================================================================================================
-- TITLE : floaterm
-- ABOUT : add beautiful floating terminal to neovim
-- LINKS : https://github.com/nvzone/floaterm
-- ================================================================================================

return {
  "nvzone/floaterm",
  dependencies = "nvzone/volt",
  opts = {
    size = { h = 80, w = 80 },
  },
  cmd = "FloatermToggle",
}
