-- ================================================================================================
-- TITLE : Formatter Configuration
-- ================================================================================================

-- write your formatters configurations here
-- Names and example can be check on: https://github.com/stevearc/conform.nvim/tree/master/lua/conform/formatters
-- or check on `:help conform-formatters`
local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettierd" },
    javascriptreact = { "prettierd" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    vue = { "prettierd" },
    json = { "prettierd" },
  },
  formatters = {},
  default_format_opts = {
    lsp_format = "fallback",
    stop_after_first = true,
  },
}

return options
