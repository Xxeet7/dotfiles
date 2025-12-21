-- ================================================================================================
-- TITLE : Autocommands Configuration
-- ================================================================================================

require "nvchad.autocmds"
local autocmd = vim.api.nvim_create_autocmd

-- open nvchad dashboard when no buffers are open
autocmd("BufDelete", {
  callback = function()
    local bufs = vim.t.bufs
    if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
      vim.cmd "Nvdash"
    end
  end,
})

-- save cursor position when leaving a buffer
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line "'\""
    if
      line > 1
      and line <= vim.fn.line "$"
      and vim.bo.filetype ~= "commit"
      and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
    then
      vim.cmd 'normal! g`"'
    end
  end,
})

-- wezterm padding configuration
-- set wezterm padding to 0 when enter Neovim
autocmd("VimEnter", {
  callback = function()
    _G.SetWeztermUserVar("nvim_padding", "0")
  end,
})
-- Restore padding when Neovim exits
autocmd("VimLeave", {
  callback = function()
    _G.SetWeztermUserVar("nvim_padding", "default")
  end,
})

-- check for file changes
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = "checktime",
})

-- hihlight on yank
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYank", {})
autocmd("TextYankPost", {
  group = highlight_yank_group,
  pattern = "*",
  callback = function()
    vim.hl.on_yank {
      higroup = "IncSearch",
      timeout = 200,
    }
  end,
})

-- autocmd for nvdash recent projects
autocmd("FileType", {
  callback = function(args)
    if vim.bo[args.buf].buflisted then
      local recent_folders = vim.g.RECENT_PROJECTS or {}

      local pwd = vim.uv.cwd()
      local home = os.getenv "HOME" .. "/"

      if not (home ~= pwd and not vim.tbl_contains(recent_folders, pwd)) then
        return
      end

      if #recent_folders == 5 then
        table.remove(recent_folders, 1)
      end

      table.insert(recent_folders, pwd)
      vim.g.RECENT_PROJECTS = recent_folders
    end
  end,
})

-- inline completion for nvim 0.12
-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local bufnr = args.buf
--     local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
--
--     if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
--       vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
--
--       vim.keymap.set(
--         "i",
--         "<C-s-f>",
--         vim.lsp.inline_completion.get,
--         { desc = "LSP: accept inline completion", buffer = bufnr }
--       )
--       vim.keymap.set(
--         "i",
--         "<C-s-g>",
--         vim.lsp.inline_completion.select,
--         { desc = "LSP: switch inline completion", buffer = bufnr }
--       )
--     end
--   end,
-- })

autocmd("BufHidden", {
  callback = function(event)
    if event.file == "" and vim.bo[event.buf].buftype == "" and not vim.bo[event.buf].modified then
      vim.schedule(function()
        pcall(vim.api.nvim_buf_delete, event.buf, {})
      end)
    end
  end,
})
