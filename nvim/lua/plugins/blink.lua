-- ================================================================================================
-- TITLE : blink.cmp
-- ABOUT : Performant, batteries-included completion plugin for Neovim
-- LINKS : https://github.com/saghen/blink.cmp
-- ================================================================================================

return {
  { import = "nvchad.blink.lazyspec" },
  {
    "saghen/blink.cmp",
    opts = {
      cmdline = {
        completion = {
          menu = {
            auto_show = function()
              return vim.fn.getcmdtype() == ":"
              -- enable for inputs as well, with:
              -- or vim.fn.getcmdtype() == '@'
            end,
          },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            async = true,
          },
        },
      },
    },
  },
}
