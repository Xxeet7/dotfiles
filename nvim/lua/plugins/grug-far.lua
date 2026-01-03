-- ================================================================================================
-- TITLE : grug-far.nvim
-- ABOUT : A simple file and project finder plugin for Neovim, inspired by 'far.vim' and 'fzf'.
-- LINKS : https://github.com/MagicDuck/grug-far.nvim
-- ================================================================================================

return {
  "MagicDuck/grug-far.nvim",
  cmd = {
    "GrugFar",
  },
  -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
  -- additional lazy config to defer loading is not really needed...
  config = function()
    -- optional setup call to override plugin options
    -- alternatively you can set options with vim.g.grug_far = { ... }
    require("grug-far").setup {
      -- options, see Configuration section below
      -- there are no required options atm
    }
  end,
}
