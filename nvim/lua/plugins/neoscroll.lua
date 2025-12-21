-- ================================================================================================
-- TITLE : neoscroll
-- ABOUT : Smooth scrolling neovim plugin written in lua
-- LINKS : https://github.com/karb94/neoscroll.nvim
-- ================================================================================================

-- disable neoscroll in neovide
if vim.g.neovide then
  return {
    "karb94/neoscroll.nvim",
    enabled = false,
  }
end

return {
  "karb94/neoscroll.nvim",
  event = "VeryLazy",
  config = function()
    _G.neoscroll = require("neoscroll")
    require("neoscroll").setup { easing = "quintic" }
  end,
}
