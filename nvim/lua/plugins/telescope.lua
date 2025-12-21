-- ================================================================================================
-- TITLE : telescope.nvim
-- ABOUT : Find, Filter, Preview, Pick. All lua, all the time.
-- LINKS : https://github.com/nvim-telescope/telescope.nvim
-- ================================================================================================

local function opts(desc)
  return { desc = " " .. desc, noremap = true, silent = true, nowait = true }
end
local action = require "telescope.actions"

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-ui-select.nvim",
      config = function()
        require("telescope").load_extension "ui-select"
      end,
    },
  },
  opts = {
    extensions_list = { "themes", "terms", "projects" },
    defaults = {
      mappings = {
        n = {
          ["<leader>sh"] = {
            action.select_horizontal,
            type = "action",
            opts = opts "Open file in horizontal split",
          },
          ["<leader>sv"] = {
            action.select_vertical,
            type = "action",
            opts = opts "Open file in vertical split",
          },
        },
        i = {
          ["<C-h>"] = {
            action.select_horizontal,
            type = "action",
            opts = opts "Open file in horizontal split",
          },
          ["<C-v>"] = {
            action.select_vertical,
            type = "action",
            opts = opts "Open file in vertical split",
          },
        },
      },
      file_ignore_patterns = {
        "node_modules",
        ".git",
        "vendor",
      },
    },
    extensions = {},
  },
}
