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
  opts = {},
}
