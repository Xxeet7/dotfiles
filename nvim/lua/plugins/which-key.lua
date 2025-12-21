-- ================================================================================================
-- TITLE : which-key.nvim
-- ABOUT : Create key bindings that stick. WhichKey helps you remember your Neovim keymaps, by showing available keybindings in a popup as you type.
-- LINKS : https://github.com/folke/which-key.nvim
-- ================================================================================================

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    win = {
      no_overlap = true,
    },
    icons = {
      group = "",
    },
  },
  config = function()
    local wk = require "which-key"
    wk.add {
      {
        "<leader>e",
        desc = "Explorer (Root)",
        icon = { icon = "", color = "yellow" },
      },
      {
        "<leader>E",
        desc = "Explorer (CWD)",
        icon = { icon = "", color = "yellow" },
      },
      {
        "<leader>d",
        desc = "Delete without yanking",
        icon = { icon = "󰗨", color = "red" },
      },
      { "<leader>s", group = "Split", icon = { icon = "", color = "blue" } },
      { "<leader>o", group = "Open", icon = { icon = "" } },
      { "<leader>ot", group = "Open Typr", icon = { icon = "" } },
      { "<leader>y", group = "Yazi", icon = { icon = "󰇥" } },
      { "<leader>c", group = "Code", icon = { icon = "", color = "azure" } },
      { "<leader>f", group = "Telescope", icon = { icon = "", color = "green" } },
      { "<leader>a", group = "AI", icon = { icon = "", color = "azure" } },
      { "<leader>t", group = "Toggle", icon = { icon = "", color = "yellow" } },
      { "<leader>l", group = "LSP", icon = { icon = "󰒍", color = "blue" } },
      { "<leader>w", group = "WhichKey", icon = { icon = "", color = "blue" } },
      { "<leader>r", group = "Variables", icon = { icon = "", color = "red" } },
      { "<leader>v", group = "Vim", icon = { icon = "", color = "green" } },
    }
  end,
}
