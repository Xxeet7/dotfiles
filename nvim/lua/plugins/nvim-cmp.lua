-- ================================================================================================
-- TITLE : nvim-cmp
-- ABOUT : A completion plugin for neovim coded in Lua.
-- LINKS : https://github.com/hrsh7th/nvim-cmp
-- ================================================================================================

return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter" },
  dependencies = {
    "zbirenbaum/copilot-cmp",
    {
      "hrsh7th/cmp-cmdline",
      event = "CmdlineEnter",
      config = function()
        local cmp = require "cmp"

        cmp.setup.cmdline("/", {
          sources = { { name = "buffer" } },
        })

        cmp.setup.cmdline(":", {
          sources = cmp.config.sources(
            { { name = "path" } },
            { { name = "cmdline" }, option = {
              ignore_cmds = { "Man", "!" },
            } }
          ),
          matching = { disallow_symbol_nonprefix_matching = false },
        })
      end,
    },
  },
  opts = function(_, opts)
    local cmp = require "cmp"
    table.insert(opts.sources, 1, { name = "copilot" })
    for i = #opts.sources, 1, -1 do
      if opts.sources[i].name == "typr" then
        table.remove(opts.sources, i)
      end
    end
    opts.view = {
      docs = {
        auto_open = false,
      },
      entries = {
        -- selection_order = "near_cursor",
      },
    }
    opts.mapping = {
      ["<UP>"] = {
        i = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end,
        c = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end,
      },
      ["<DOWN>"] = {
        i = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end,
        c = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end,
      },
      ["<Tab>"] = {
        i = cmp.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
        c = false,
      },
      ["<S-Tab>"] = {
        c = false,
      },
      ["<C-p>"] = {
        c = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
      },
      ["<C-o>"] = {
        i = function()
          if cmp.visible() then
            cmp.abort()
          else
            cmp.complete()
          end
        end,
        c = function()
          if cmp.visible() then
            cmp.abort()
          else
            cmp.complete()
          end
        end,
      },
      ["<C-f>"] = function()
        if cmp.visible_docs() then
          cmp.close_docs()
        else
          cmp.open_docs()
        end
      end,
    }
    return opts
  end,
}
