-- ================================================================================================
-- TITLE : Chadrc Configuration
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- ================================================================================================

local home = os.getenv "HOME" .. "/"
local g = vim.g

local replace_home_path = function(path)
  if path:find(home) then
    return "~/" .. string.gsub(path, "^" .. home, "")
  end
  return path
end

local letters = {}
for i = string.byte "A", string.byte "Z" do
  local letter = string.char(i)
  table.insert(letters, letter)
end

local function set_recent_files(tb)
  local files = {}

  for _, v in ipairs(vim.v.oldfiles) do
    if #files == 5 then
      break
    end
    if vim.uv.fs_stat(v) then
      table.insert(files, v)
    end
  end

  for i, v in ipairs(files) do
    local devicon, devicon_hl = require("nvim-web-devicons").get_icon(v)
    local icon = devicon or ""
    local path = replace_home_path(v):sub(1, 100)
    local keybind = letters[i]

    local line = {
      multicolumn = true,
      no_gap = true,
      content = "fit",
      group = "recent_files",
      cmd = "e " .. path,
      keys = keybind,
    }

    table.insert(line, { txt = icon .. "  ", hl = devicon_hl })
    table.insert(line, { txt = path })
    table.insert(line, { txt = string.rep(" ", 3), pad = "full" })
    table.insert(line, { txt = keybind, hl = "comment" })

    table.insert(tb, line)
  end
end

local function set_recent_folders(tb)
  local dirs = vim.g.RECENT_PROJECTS or {}
  dirs = vim.list_slice(dirs, 0, 5)

  for i, v in ipairs(dirs) do
    local path = replace_home_path(v):sub(1, 100)
    local keybind = letters[i + 5]

    local line = {
      keys = keybind,
      multicolumn = true,
      no_gap = true,
      content = "fit",
      group = "recent_files",
      cmd = "lua vim.fn.chdir('" .. path .. "') vim.notify('Changed working directory to " .. path .. "')",
    }

    table.insert(line, { txt = "  ", hl = "nviminternalError" })
    table.insert(line, { txt = path })
    table.insert(line, { txt = string.rep(" ", 3), pad = "full" })
    table.insert(line, { txt = keybind, hl = "comment" })

    table.insert(tb, line)
  end
end

-- global options for toggle checks
g.animation = true

---@type ChadrcConfig
local M = {}

-- base46 configuration
M.base46 = {
  theme = "flouromachine",
  transparency = false,
  integrations = {
    "notify",
    "hop",
    "semantic_tokens",
    "todo",
    "grug_far",
  },
  theme_toggle = { "flouromachine", "oceanic-light" },
  hl_override = {
    NvDashAscii = { fg = "#FFC6C6", bold = true },
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
  hl_add = {
    tabuflineArrowsPrev = { fg = "grey_fg2", bold = true },
    tabuflineArrowsNext = { fg = "grey_fg2", bold = true },
    transparencyToggle = { bg = "blue", fg = "NONE", reverse = false },
  },
}

-- nvdash configuration
M.nvdash = {
  load_on_startup = true,
  header = {
    "██╗    ██╗ ██████╗ ███╗   ██╗██████╗ ███████╗██████╗ ██╗  ██╗ ██████╗ ██╗   ██╗",
    "██║    ██║██╔═══██╗████╗  ██║██╔══██╗██╔════╝██╔══██╗██║  ██║██╔═══██╗╚██╗ ██╔╝",
    "██║ █╗ ██║██║   ██║██╔██╗ ██║██║  ██║█████╗  ██████╔╝███████║██║   ██║ ╚████╔╝ ",
    "██║███╗██║██║   ██║██║╚██╗██║██║  ██║██╔══╝  ██╔══██╗██╔══██║██║   ██║  ╚██╔╝  ",
    "╚███╔███╔╝╚██████╔╝██║ ╚████║██████╔╝███████╗██║  ██║██║  ██║╚██████╔╝   ██║   ",
    " ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝    ╚═╝   ",
    "                                                                               ",
  },
  buttons = function()
    local layout = {

      {
        multicolumn = true,
        pad = 3,
        no_gap = true,
        content = "fit",
        { txt = "  Lazy [l]", hl = "DevIconpng", keys = "l", cmd = ":Lazy<cr>" },
        { txt = "  Files [f]", hl = "NvDashAscii", keys = "f", cmd = ":Telescope find_files <cr>" },
        {
          txt = "  Config [c]",
          hl = "DevIconpy",
          keys = "c",
          cmd = ":lua require('telescope.builtin').find_files({cwd = vim.fn.stdpath('config')})<cr>",
        },
      },

      {
        multicolumn = true,
        pad = 3,
        content = "fit",
        {
          txt = "󰇥  yazi [y]",
          hl = "DevIconrpm",
          keys = "y",
          cmd = "Yazi cwd",
        },
        { txt = "  quit [q]", hl = "nviminternalError", keys = "q", cmd = "q" },
      },

      {
        txt = "  Most Recent files",
        hl = "floatborder",
        no_gap = true,
        group = "recent_files",
      },

      { txt = "─", hl = "comment", no_gap = true, rep = true, group = "recent_files", content = "fit" },
    }

    set_recent_files(layout)
    table.insert(layout, { txt = "", no_gap = true })

    table.insert(layout, {
      txt = "  Recent Projects",
      hl = "String",
      no_gap = true,
      group = "recent_files",
    })

    table.insert(
      layout,
      { txt = "─", hl = "comment", no_gap = true, rep = true, group = "recent_files", content = "fit" }
    )

    set_recent_folders(layout)

    return layout
  end,
}

-- ui configuration
M.ui = {
  -- telescope
  telescope = {
    style = "borderless",
  },
  -- cmp
  cmp = {
    style = "flat_light",
    icons_left = true,
  },
  -- statusline
  statusline = {
    theme = "minimal",
    order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "cursor" },
    modules = {},
  },
  -- tabufline
  tabufline = {
    lazyload = false,
    order = {
      "treeOffset",
      "buffers",
      "tabs",
      -- "arrowsPrev",
      -- "arrowsNext",
      -- "transparencyToggle",
      -- "btns",
    },
    modules = {
      transparencyToggle = function()
        return "%@v:lua.ToggleTransparency@%#transparencyToggle# "
          .. (require("nvconfig").base46.transparency and "" or "")
          .. " "
      end,
      arrowsPrev = function()
        local bufs = vim.t.bufs

        if #bufs <= 1 then
          return ""
        else
          return "%#tabuflineArrowsPrev#" .. "%@v:lua.TabuflinePrev@" .. "  " .. "%X"
        end
      end,
      arrowsNext = function()
        local bufs = vim.t.bufs

        if #bufs <= 1 then
          return ""
        else
          return "%#tabuflineArrowsNext#" .. "%@v:lua.TabuflineNext@" .. "  " .. "%X"
        end
      end,
    },
  },
}

-- lsp configuration
M.lsp = {
  signature = true,
}

-- terminal configuration
M.term = {
  sizes = {
    vsp = 0.3,
  },
  float = {
    row = 0,
    col = 0,
    width = 0.9,
    height = 0.87,
    border = "rounded",
  },
}

M.colorify = {
  enabled = true,
  mode = "bg", -- fg, bg, virtual
  -- virt_text = "󱓻 ",
  highlight = { hex = true, lspvars = true },
}

M.mason = {
  pkgs = {
    "copilot-language-server",
  },
}

return M
