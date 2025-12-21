-- ================================================================================================
-- TITLE : Custom Functions
-- ================================================================================================

local g = vim.g

-- Toggle transparency
function _G.ToggleTransparency()
  local transparency = not require("nvconfig").base46.transparency
  if g.neovide then
    g.neovide_opacity = transparency and 0.8 or 1.0
  end

  require("base46").toggle_transparency()
end

function _G.ToggleAnimation()
  if vim.g.animation then
    if vim.g.neovide then
      vim.g.neovide_scroll_animation_length = 0
      vim.g.neovide_cursor_animation_length = 0
    else
      smear_cursor.setup { enabled = false }
      vim.keymap.del({ "n", "v" }, "<C-u>")
      vim.keymap.del({ "n", "v" }, "<C-d>")
      vim.keymap.del({ "n", "v" }, "<C-b>")
      vim.keymap.del({ "n", "v" }, "<C-f>")
      vim.keymap.del({ "n", "v" }, "<C-y>")
      vim.keymap.del({ "n", "v" }, "<C-e>")
      vim.keymap.del({ "n", "v" }, "zt")
      vim.keymap.del({ "n", "v" }, "zz")
      vim.keymap.del({ "n", "v" }, "zb")
    end
    vim.g.animation = not vim.g.animation
  else
    if vim.g.neovide then
      vim.g.neovide_scroll_animation_length = 0.3
      vim.g.neovide_cursor_animation_length = 0.150
    else
      smear_cursor.setup { stiffness = 0.8, trailing_stiffness = 0.5, transparent_bg_fallback_color = "#303030" }
      neoscroll.setup {
        easing = "quintic",
        mappings = { -- Keys to be mapped to their corresponding default scrolling animation
          "<C-u>",
          "<C-d>",
          "<C-b>",
          "<C-f>",
          "<C-y>",
          "<C-e>",
          "zt",
          "zz",
          "zb",
        },
      }
    end
    vim.g.animation = not vim.g.animation
  end
end

-- modify wezterm user variables
function _G.SetWeztermUserVar(name, value)
  local ty = type(value)

  if ty == "table" then
    value = vim.json.encode(value)
  elseif ty == "function" or ty == "thread" then
    error("cannot serialize " .. ty)
  elseif ty == "boolean" then
    value = value and "true" or "false"
  elseif ty == "nil" then
    value = ""
  end

  local template = "\x1b]1337;SetUserVar=%s=%s\a"
  local command = template:format(name, vim.base64.encode(tostring(value)))
  vim.api.nvim_chan_send(vim.v.stderr, command)
end

-- dump variable contents in print
function _G.vardump(value, depth, key, visited)
  local linePrefix = ""
  local spaces = ""

  if key ~= nil then
    linePrefix = "[" .. key .. "] = "
  end

  if depth == nil then
    depth = 0
  else
    depth = depth + 1
  end

  if visited == nil then
    visited = {}
  end

  for i = 1, depth do
    spaces = spaces .. "  "
  end

  if type(value) == "table" then
    if visited[value] then
      print(spaces .. linePrefix .. "(table) *recursive*")
      return
    end
    visited[value] = true
    local mtable = getmetatable(value)
    if mtable == nil then
      print(spaces .. linePrefix .. "(table) ")
    else
      print(spaces .. "(metatable) ")
      value = mtable
    end
    for tableKey, tableValue in pairs(value) do
      vardump(tableValue, depth, tableKey, visited)
    end
  elseif type(value) == "function" or type(value) == "thread" or type(value) == "userdata" then
    print(spaces .. linePrefix .. tostring(value))
  else
    print(spaces .. linePrefix .. "(" .. type(value) .. ") " .. tostring(value))
  end
end

-- dump variable contents in notification
local MAX_INSPECT_LINES = 2000
function _G.dd(...)
  local len = select("#", ...) ---@type number
  local obj = { ... } ---@type unknown[]
  local caller = debug.getinfo(1, "S")
  for level = 2, 10 do
    local info = debug.getinfo(level, "S")
    if
      info
      and info.source ~= caller.source
      and info.what ~= "C"
      and info.source ~= "lua"
      and info.source ~= "@" .. (os.getenv "MYVIMRC" or "")
    then
      caller = info
      break
    end
  end
  vim.schedule(function()
    local title = "Debug: " .. vim.fn.fnamemodify(caller.source:sub(2), ":~:.") .. ":" .. caller.linedefined
    local lines = vim.split(vim.inspect(len == 1 and obj[1] or len > 0 and obj or nil), "\n")
    if #lines > MAX_INSPECT_LINES then
      local c = #lines
      lines = vim.list_slice(lines, 1, MAX_INSPECT_LINES)
      lines[#lines + 1] = ""
      lines[#lines + 1] = (c - MAX_INSPECT_LINES) .. " more lines have been truncated …"
    end
    vim.notify(lines, "info", {
      title = title,
      render = "default",
      on_open = function(win)
        local buf = vim.api.nvim_win_get_buf(win)
        vim.api.nvim_set_option_value("filetype", "lua", { buf = buf })
      end,
    })
  end)
end

-- show backtrace in notification
function _G.bt(msg, opts)
  opts = vim.tbl_deep_extend("force", {
    level = vim.log.levels.WARN,
    title = "Backtrace",
    render = "default",
    on_open = function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })
    end,
  }, opts or {})
  ---@type string[]
  local trace = type(msg) == "table" and msg or type(msg) == "string" and { msg } or {}
  for level = 2, 20 do
    local info = debug.getinfo(level, "Sln")
    local bufnr = info and tonumber(info.source:sub(16)) or nil
    if info and info.what ~= "C" and info.source ~= "lua" then
      local line = "- `"
        .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:~:.")
        .. "` line "
        .. info.currentline
      if info.name then
        line = line .. " in " .. info.name
      end
      table.insert(trace, line)
    end
  end
  vim.notify(#trace > 0 and (table.concat(trace, "\n")) or "", "info", opts)
end
