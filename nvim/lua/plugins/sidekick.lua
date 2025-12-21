-- ================================================================================================
-- TITLE : sidekick
-- ABOUT : sidekick.nvim is a Neovim plugin that provides an integrated terminal management system, allowing users to easily run and manage command-line interfaces (CLIs) within Neovim.
-- LINKS : https://github.com/folke/sidekick.nvim
-- ================================================================================================

return {
  "folke/sidekick.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
    nes = { enabled = false },
    cli = {
      -- win = {
      --   layout = "float",
      --   float = {
      --     width = 0.8,
      --     height = 0.8,
      --     border = "rounded",
      --   },
      -- },
      mux = {
        backend = "tmux",
        enabled = false,
      },
    },
  },
  -- keys = {
  --   {
  --     "<c-.>",
  --     function()
  --       require("sidekick.cli").toggle()
  --     end,
  --     desc = "Sidekick Toggle",
  --     mode = { "n", "t", "i", "x" },
  --   },
  --   {
  --     "<leader>aa",
  --     function()
  --       require("sidekick.cli").toggle()
  --     end,
  --     desc = "Sidekick Toggle CLI",
  --   },
  --   {
  --     "<leader>as",
  --     function()
  --       require("sidekick.cli").select()
  --     end,
  --     -- Or to select only installed tools:
  --     -- require("sidekick.cli").select({ filter = { installed = true } })
  --     desc = "AI Select",
  --   },
  --   {
  --     "<leader>ad",
  --     function()
  --       require("sidekick.cli").close()
  --     end,
  --     desc = "AI detach",
  --   },
  --   {
  --     "<leader>at",
  --     function()
  --       require("sidekick.cli").send { msg = "{this}" }
  --     end,
  --     mode = { "x", "n" },
  --     desc = "Send this to AI",
  --   },
  --   {
  --     "<leader>af",
  --     function()
  --       require("sidekick.cli").send { msg = "{file}" }
  --     end,
  --     desc = "Send this file to AI",
  --   },
  --   {
  --     "<leader>av",
  --     function()
  --       require("sidekick.cli").send { msg = "{selection}" }
  --     end,
  --     mode = { "x" },
  --     desc = "Send visual selection to AI",
  --   },
  --   {
  --     "<leader>ap",
  --     function()
  --       require("sidekick.cli").prompt()
  --     end,
  --     mode = { "n", "x" },
  --     desc = "AI Select Prompt",
  --   },
  -- },
}
