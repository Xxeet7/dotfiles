-- ================================================================================================
-- TITLE : LSP Configuration
-- ================================================================================================

local nvlsp = require "nvchad.configs.lspconfig"
local map = vim.keymap.set
local x = vim.diagnostic.severity

-- write your language server configurations here
-- Names and example can be check on: https://github.com/neovim/nvim-lspconfig/tree/master/lsp
-- or check on `:help lspconfig-all`
local servers = {
  lua_ls = {
    filetypes = { "lua" },
    settings = {
      Lua = {
        hint = { enable = true },
        runtime = { version = "LuaJIT" },
        workspace = {
          library = {
            vim.fn.expand "$VIMRUNTIME/lua",
            vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
            vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
            "${3rd}/luv/library",
          },
        },
      },
    },
  },
  jsonls = {
    filetypes = { "json" },
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
  yamlls = {
    filetypes = { "yaml" },
    settings = {
      yaml = {
        schemaStore = {
          -- You must disable built-in schemaStore support if you want to use
          -- this plugin and its advanced options like `ignore`.
          enable = false,
          -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          url = "",
        },
        schemas = require("schemastore").yaml.schemas(),
      },
    },
  },
  copilot = {
    filetypes = nil,
    on_attach = "lspconfig", -- needed for the signin and logout command to exist
  },
  html = {
    filetypes = { "html" },
  },
  cssls = {
    filetypes = { "css" },
  },
  intelephense = {
    filetypes = { "php" },
  },
  ts_ls = {
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },
  tinymist = {
    filetypes = { "typst" },
    settings = {
      formatterMode = "typstyle",
      semanticTokens = "disable",
    },
  },
  -- Add other servers configuration here
  -- add minimal configuration like filetypes for `:MasonInstallAll` to work
  -- example:
  -- pyright = {
  --   filetypes = { "python" },
  -- },
  -- rust_analyzer = {
  --   filetypes = { "rust" },
  -- },
}

-- Custom intructions to run when lsp server attaches to buffer
-- write your custom keymaps or other things here
local on_attach = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "<leader>lI", "<cmd>Telescope lsp_implementations<CR>", opts "Go to implementation")
  map("n", "<leader>ld", "<cmd>Telescope lsp_definitions<CR>", opts "Go to definition")
  map("n", "<leader>lD", "<cmd>Telescope lsp_type_definitions<CR>", opts "Go to type definition")
  map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", opts "list symbols (var, function, etc.) in buffer")
  map(
    "n",
    "<leader>lS",
    "<cmd>Telescope lsp_workspace_symbols<CR>",
    opts "list symbols (var, function, etc.) in workspace"
  )
  map("n", "<leader>lR", "<cmd>Telescope lsp_references<CR>", opts "show references")

  map("n", "<leader>lr", require "nvchad.lsp.renamer", opts "Variable rename")
end

-- Loop through servers and set them up
for name, opts in pairs(servers) do
  vim.tbl_deep_extend("force", {}, {
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }, opts or {})

  if opts.on_attach == nil then
    opts.on_attach = on_attach
  end

  if opts.on_attach == "lspconfig" then
    opts.on_attach = nil
  end

  vim.lsp.config[name] = opts
  vim.lsp.enable(name)
end

-- for diagnostic configuration
vim.diagnostic.config {
  virtual_text = true,
  signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
  underline = true,
  float = { border = "single" },
}
