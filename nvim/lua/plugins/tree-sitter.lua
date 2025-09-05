-- ================================================================================================
-- TITLE : nvim-treesitter
-- ABOUT : Treesitter configurations and abstraction layer for Neovim.
-- LINKS : https://github.com/nvim-treesitter/nvim-treesitter
-- ================================================================================================

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter.configs").setup {
      -- language parsers that MUST be installed
      ensure_installed = {
        "bash",
        -- "c",
        -- "cpp",
        "css",
        "dockerfile",
        -- "go",
        "html",
        "javascript",
        "json",
        "yaml",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "rust",
        -- "svelte",
        "typescript",
        -- "vue",
        -- "yaml",
        "php",
      },
      auto_install = true, -- auto-install any other parsers on opening new language files
      sync_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    }
  end,
}
