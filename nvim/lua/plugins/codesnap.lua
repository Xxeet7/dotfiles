-- ================================================================================================
-- TITLE : codesnap
-- ABOUT : take beautiful code snapshots in Neovim
-- LINKS : https://github.com/mistricky/codesnap.nvim
-- ================================================================================================

return {
  "mistricky/codesnap.nvim",
  build = "make",
  cmd = {
    "CodeSnap",
    "CodeSnapSave",
  },
  opts = {
    save_path = "~/Pictures/Screenshots/codesnaps/",
    bg_theme = "sea",
    watermark = "",
  },
}
