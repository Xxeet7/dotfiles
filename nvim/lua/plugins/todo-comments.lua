-- ================================================================================================
-- TITLE : Todo Comments
-- ABOUT : Highlight, list and search todo comments like TODO, HACK, BUG in your projects
-- LINKS : https://github.com/folke/todo-comments.nvim
-- ================================================================================================

return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    dofile(vim.g.base46_cache .. "todo")
    require("todo-comments").setup {}
  end,
}
