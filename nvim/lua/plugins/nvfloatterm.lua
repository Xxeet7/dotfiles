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
    mappings = {
      term = function(buf)
        vim.keymap.set({ "n", "t" }, "<C-a>", function()
          require("floaterm.api").new_term()
        end, { buffer = buf })
      end,
    },
  },
  cmd = "FloatermToggle",
}
