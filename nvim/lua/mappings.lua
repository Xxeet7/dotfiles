-- ================================================================================================
-- TITLE : Keymappings
-- ================================================================================================

require "nvchad.mappings"
local map = vim.keymap.set
local unmap = vim.keymap.del

-- unmappin default nvchad mappings
-- needed for changing default
unmap("n", "<leader>n") --line number
unmap("n", "<leader>b") --new buffer
unmap("n", "<leader>rn") --relative number
unmap("n", "<leader>h") --horizontal term
unmap("n", "<leader>v") --vertical term
unmap("n", "<leader>pt") --telescope list terminal
unmap("n", "<leader>ma") --find mark
unmap("n", "<leader>gt") --git status
unmap("n", "<leader>ds") --lsp doc
unmap("n", "<leader>cm") --find commit
unmap("n", "<leader>ch") --old Nvcheatsheet map
unmap("n", "<leader>th") --old Nvchad theme map
unmap("x", "<leader>fm") --old format mapping for visual

-- general mappings
map({ "n", "v" }, ";", ":", { desc = "CMD enter command mode" }) -- ";" to ":"
map("i", "jk", "<ESC>") -- easy exit insert mode
map("n", "<C-q>", "<cmd>q<CR>", { desc = "general quit vim" }) -- quit
map({ "n", "i" }, "<C-s>", "<cmd>w<CR>", { desc = "general save" }) -- save
map("n", "K", function()
  if not vim.diagnostic.open_float { scope = "cursor" } then
    vim.lsp.buf.hover { silent = true, max_height = 7, border = "single" }
  end
  vim.diagnostic.open_float { focus = false, silent = true, max_height = 7, border = "single", scope = "cursor" }
end, { desc = "hover info" }) -- lsp Hover info
map("n", "<leader>X", "<cmd>lua require('nvchad.tabufline').closeAllBufs(true)<CR>", { desc = "buffer close all" }) -- close all buffers

-- turn Change, Select, Delete to not yank with defer_fn after 200ms (idk why it's not working without defer_fn)
-- for delete (d) add leader command without yank
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" }) -- delete without yanking
vim.defer_fn(function()
  map("n", "D", '"_D', { desc = "Delete to end without yanking", noremap = true }) -- D
  map({ "n", "v", "x" }, "c", '"_c', { desc = "Replace/Change without yanking", noremap = true }) -- make "c" not yanking by default
  map("n", "C", '"_C', { desc = "Replace/Change to end without yanking", noremap = true }) -- C
  map({ "n", "v", "x" }, "s", '"_s', { desc = "Select without yanking", noremap = true }) -- make "s" not yanking by default
  map("n", "S", '"_S', { desc = "Select to end without yanking", noremap = true }) -- S
end, 200)

-- nvim tree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Explorer (Root)" })
map(
  "n",
  "<leader>E",
  "<cmd>lua require('nvim-tree.api').tree.toggle({ path = vim.fn.getcwd() })<CR>",
  { desc = "Explorer (CWD)" }
)

-- Toggle terminal <ALT>
map(
  { "n", "t" },
  "<A-I>",
  "<cmd>lua require('nvchad.term').toggle { pos = 'float' }<CR>",
  { desc = "open/close wide term" }
) -- wide term
map({ "n", "t" }, "<A-i>", "<cmd>FloatermToggle<CR>", { desc = "open/close Terminal Hub" }) -- Terminal Hub (alt-i)

-- Toggle Utils
map("n", "<leader>tt", ToggleTransparency, { desc = "Toggle Transparency" }) -- Transparency
map("n", "<leader>ts", "<cmd>lua require('base46').toggle_theme()<CR>", { desc = "toggle switch theme" }) -- Theme switch
map("n", "<leader>tk", "<cmd>ShowkeysToggle<CR>", { desc = "Toggle show Keystroke" }) -- Show keystroke
map("n", "<leader>tw", function()
  vim.opt.wrap = not vim.opt.wrap._value
end, { desc = "toggle wrap line" }) -- Wrap line
map("n", "<leader>ta", ToggleAnimation, { desc = "toggle editor animation" }) -- animation

-- Code Utils
map(
  { "n", "x" },
  "<leader>cf",
  " <cmd>lua require('conform').format { lsp_fallback = true, async = true }<CR>",
  { desc = "Format file" }
) -- format with conform
map("x", "<leader>cc", "<cmd>CodeSnap<cr>", { desc = "Save selected code snapshot into clipboard" }) -- CodeSnap to clipboard
map(
  "x",
  "<leader>cs",
  "<cmd>CodeSnapSave<cr>",
  { desc = "Save selected code snapshot in ~/Pictures/Screenshots/codesnaps/" }
) -- CodeSnap save to file
map("n", "<leader>cq", "<cmd>lua require('quicker').toggle({ focus = true, height = 10 })<cr>", { desc = "quickfix" })
map("n", "<leader>cl", function()
  vim.diagnostic.config {
    virtual_lines = not vim.diagnostic.config().virtual_lines,
    virtual_text = not vim.diagnostic.config().virtual_text,
  }
end, { desc = "Diagnostic virtual_lines" })

-- Open Utils buffer
map("n", "<leader>om", "<cmd>Mason<CR>", { desc = "Open Mason" }) -- Mason
map("n", "<leader>on", "<cmd>Nvdash<CR>", { desc = "Open NvDash" }) -- Nvchad dashboard
map("n", "<leader>ol", "<cmd>Lazy<CR>", { desc = "Open Lazy" }) -- Lazy
map(
  "n",
  "<leader>og",
  "<cmd>lua require('lazy.util').float_term({ 'lazygit' }, { border = 'rounded' })<CR>",
  { desc = "Open Lazy git" }
) -- Lazy git
map("n", "<leader>oc", "<cmd>NvCheatsheet<CR>", { desc = "open nvcheatsheet" }) --NvCheatsheet
map("n", "<leader>oto", "<cmd>Typr<CR>", { desc = "Typr open (typing test)" }) -- Typr
map("n", "<leader>ots", "<cmd>TyprStats<CR>", { desc = "Typr Stats" }) -- Typr stats
map("n", "<leader>ov", "<cmd>lua require('nvchad.themes').open()<CR>", { desc = "open nvchad themes selector" }) -- Nvchad themes
map(
  "n",
  "<leader>of",
  "<cmd>lua require('grug-far').open({ transient = true })<CR>",
  { desc = "open Find and Replace (grug-far)" }
) -- Find and Replace (grug-far)

-- Yazi file explorer
map({ "n", "v" }, "<leader>yf", "<cmd>Yazi<cr>", { desc = "Open yazi at the current file" }) -- Yazi open at current file
map("n", "<leader>yc", "<cmd>Yazi cwd<cr>", { desc = "Open the file manager in nvim's working directory" }) -- Yazi open at working dir
map("n", "<leader>yt", "<cmd>Yazi toggle<cr>", { desc = "Resume the last yazi session" }) -- Yazi Resume last session

-- Telescope (find)
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fs", "<cmd>Telescope themes<CR>", { desc = "telescope set themes" })
map("n", "<leader>ft", "<cmd>Telescope todo-comments<CR>", { desc = "telescope todo highlight" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "telescope find keymaps" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "telescope search diagnostics" })
map("n", "<leader>fn", "<cmd>Telescope notify<CR>", { desc = "telescope notifications history" }) -- Notifications
map("n", "<leader>fr", "<cmd>Telescope resume<CR>", { desc = "telescope resume last search" }) -- Command resume

-- vim commands
map("n", "<leader>vs", "<cmd>suspend<CR>", { desc = "vim suspend" })
map("n", "<leader>vw", "<cmd>w<CR>", { desc = "vim write (save)" })
map("n", "<leader>vq", "<cmd>q<CR>", { desc = "vim quit" })
map("n", "<leader>vQ", "<cmd>q!<CR>", { desc = "vim force quit" })
map(
  "n",
  "<leader>vc",
  ":lua require('telescope.builtin').find_files({cwd = vim.fn.stdpath('config')})<CR>",
  { desc = "Find files on config folder" }
)

-- center screen when jumping
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Better indenting in visual mode
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Splitting & Resizing
map("n", "<leader>sv", "<Cmd>vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>sh", "<Cmd>split<CR>", { desc = "Split window horizontally" })
map("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<Cmd>vertical resize +2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<Cmd>vertical resize -2<CR>", { desc = "Increase window width" })

-- Split/Join code
map({ "n" }, "J", "<Cmd>TSJToggle<CR>", { desc = "Split/Join code" })

-- move lines and selections
map("n", "<A-j>", ":.move.+1<cr>", { desc = "Move Line ( below )", silent = true }) -- below
map("n", "<A-k>", ":.move.-2<cr>", { desc = "Move Line ( above )", silent = true }) -- above

map("x", "<A-j>", ":'<'>move'>+1<cr>gv", { desc = "Move selected ( below )", silent = true }) -- below
map("x", "<A-k>", ":'<'>move'<-2<cr>gv", { desc = "Move selected ( above )", silent = true }) -- above

-- duplicate line and selections
map("n", "<A-S-j>", ":.copy.<cr>", { desc = "duplicate line ( below )", silent = true }) -- below
map("n", "<A-S-k>", ":.copy.-1<cr>", { desc = "duplicate line ( above )", silent = true }) -- above

map("x", "<A-S-j>", ":'<'>copy'><cr>gv", { desc = "duplicate selected ( below )", silent = true }) -- below
map("x", "<A-S-k>", ":'<'>copy'<-1<cr>gv", { desc = "duplicate selected ( above )", silent = true }) -- above

-- move buffer
map("n", "<C-Tab>", "<cmd>lua require('nvchad.tabufline').move_buf(1)<cr>", { desc = "Move Buffer to right" }) -- Right
map("n", "<C-S-Tab>", "<cmd>lua require('nvchad.tabufline').move_buf(-1)<cr>", { desc = "Move Buffer to left" }) -- Left

-- hop
map("n", "<leader>h", "<cmd>HopChar1<cr>", { desc = "Quick jump to char" }) -- quick hop char
map("n", "<leader>jw", "<cmd>HopWord<cr>", { desc = "Jump to word" }) -- hop word
map("n", "<leader>jc", "<cmd>HopCamelCase<cr>", { desc = "Jump to camelcase" }) -- hop CamelCase
map("n", "<leader>j2", "<cmd>HopChar2<cr>", { desc = "Jump to 2 char" }) -- hop Char 2
map("n", "<leader>j/", "<cmd>HopPattern<cr>", { desc = "Jump to pattern" }) -- hop pattern
map("n", "<leader>jl", "<cmd>HopLine<cr>", { desc = "Jump to line" }) -- hop line

-- virtual symbol usage toggle
map("n", "<leader>tu", function()
  require("symbol-usage").toggle_globally()
  require("symbol-usage").refresh()
end, { desc = "Toggle virtual symbol usage near a function", silent = true })

-- Tabs
map("n", "[<Tab>", "<cmd>tabp<cr>", { desc = "Previous tab" }) -- Previous tab
map("n", "]<Tab>", "<cmd>tabn<cr>", { desc = "Next tab" }) -- Next tab
map("n", "tx", "<cmd>tabc<cr>", { desc = "Close tab" }) -- Close tab
map("n", "tn", "<cmd>tab split<cr>", { desc = "New tab" }) -- New tab

-- Sidekick / Ai
map({ "n", "t", "i", "x" }, "<c-.>", function()
  require("sidekick.cli").toggle()
end, { desc = "Sidekick Toggle", silent = true })

map("n", "<leader>aa", function()
  require("sidekick.cli").toggle()
end, { desc = "Sidekick Toggle CLI", silent = true })

map("n", "<leader>as", function()
  require("sidekick.cli").select()
end, { desc = "AI Select", silent = true })

map("n", "<leader>ad", function()
  require("sidekick.cli").close()
end, { desc = "AI detach", silent = true })

map({ "x", "n" }, "<leader>at", function()
  require("sidekick.cli").send { msg = "{this}" }
end, { desc = "Send this to AI", silent = true })

map("n", "<leader>af", function()
  require("sidekick.cli").send { msg = "{file}" }
end, { desc = "Send this file to AI", silent = true })

map("x", "<leader>av", function()
  require("sidekick.cli").send { msg = "{selection}" }
end, { desc = "Send visual selection to AI", silent = true })

map({ "n", "x" }, "<leader>ap", function()
  require("sidekick.cli").prompt()
end, { desc = "AI Select Prompt", silent = true })
