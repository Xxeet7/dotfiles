-- ================================================================================================
-- TITLE : nvmenu
-- ABOUT : add beautiful right click like menu to neovim
-- LINKS : https://github.com/nvzone/menu
-- ================================================================================================

return {
  "nvzone/menu",
  lazy = true,
  dependencies = {
    { "nvzone/volt", lazy = true },
  },
}
