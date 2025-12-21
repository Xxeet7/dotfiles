-- ================================================================================================
-- TITLE : Neovide settings
-- ABOUT : custom settings when running inside neovide
-- ================================================================================================

local g = vim.g
local o = vim.o
local transparency = require("nvconfig").base46.transparency

-- neovide settings
if g.neovide then
  g.neovide_fullscreen = false
  g.neovide_opacity = transparency and 0.8 or 1.0
  o.guifont = "JetBrainsMono Nerd Font:h12"
  g.neovide_cursor_trail_size = 0.2
end
