-- ================================================================================================
-- TITLE : smear cursor
-- ABOUT : Neovim plugin to animate the cursor with a smear effect in all terminals
-- LINKS : https://github.com/sphamba/smear-cursor.nvim
-- ================================================================================================

-- disable smear-cursor in neovide
if vim.g.neovide then
  return {
    "sphamba/smear-cursor.nvim",
    enabled = false,
  }
end

return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  config = function()
    _G.smear_cursor = require("smear_cursor")
    require("smear_cursor").setup {
      stiffness = 0.8,
      trailing_stiffness = 0.5,
      transparent_bg_fallback_color = "#303030",
    }
  end,
}
