-- ================================================================================================
-- TITLE : Todo Comments
-- ABOUT : Highlight, list and search todo comments like TODO, HACK, BUG in your projects
-- LINKS : https://github.com/folke/todo-comments.nvim
-- ================================================================================================

return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
}
