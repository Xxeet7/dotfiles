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

-- Initialize a flag to toggle LSPs on or off
local lsp_enabled = true
-- Store buffers attached to each LSP client
local attached_buffers_by_client = {}
-- Store configurations for each LSP client
local client_configs = {}

-- Store a reference to the original buf_attach_client function
local original_buf_attach_client = vim.lsp.buf_attach_client

-- Function to add a buffer to the client's buffer table
local function add_buf(client_id, buf)
  if not attached_buffers_by_client[client_id] then
    attached_buffers_by_client[client_id] = {}
  end

  -- Check if the buffer is already in the list
  local exists = false
  for _, value in ipairs(attached_buffers_by_client[client_id]) do
    if value == buf then
      exists = true
      break
    end
  end

  -- Add the buffer if it doesn’t already exist in the client’s list
  if not exists then
    table.insert(attached_buffers_by_client[client_id], buf)
  end
end

-- Middleware function to control LSP client attachment to buffers
-- Prevents LSP client from reattaching if LSPs are disabled
vim.lsp.buf_attach_client = function(bufnr, client_id)
  if not lsp_enabled then
    -- Cache client configuration if not already stored
    if not client_configs[client_id] then
      local client_config = vim.lsp.get_client_by_id(client_id)
      client_configs[client_id] = (client_config and client_config.config) or {}
    end

    -- Add buffer to client’s attached buffer list and stop the client
    add_buf(client_id, bufnr)
    vim.lsp.stop_client(client_id)

    return false -- Indicate the client should not attach
  end
  return original_buf_attach_client(bufnr, client_id) -- Use the original attachment method if enabled LSP
end

-- Update state with new client IDs after a toggle
local function update_clients_ids(ids_map)
  local new_attached_buffers_by_client = {}
  local new_client_configs = {}

  -- Map each client ID to its new ID and carry over configurations
  for client_id, buffers in pairs(attached_buffers_by_client) do
    local new_id = ids_map[client_id]
    new_attached_buffers_by_client[new_id] = buffers
    new_client_configs[new_id] = client_configs[client_id]
  end

  attached_buffers_by_client = new_attached_buffers_by_client -- Update global attached buffer table
  client_configs = new_client_configs -- Update global client config table
end

-- Stops the client, waiting up to 5 seconds; force quits if needed
local function client_stop(client)
  vim.lsp.stop_client(client.id, false)

  local timer = vim.uv.new_timer() -- Create a timer
  local max_attempts = 50 -- Set max attempts to check if stopped
  local attempts = 0 -- Track the number of attempts

  timer:start(
    100,
    100,
    vim.schedule_wrap(function()
      attempts = attempts + 1

      if client:is_stopped() then -- Check if the client is stopped
        timer:stop()
        timer:close()
        vim.diagnostic.reset() -- Reset diagnostics for the client
      elseif attempts >= max_attempts then -- If max attempts reached
        vim.lsp.stop_client(client.id, true) -- Force stop the client
        timer:stop()
        timer:close()
        vim.diagnostic.reset() -- Reset diagnostics for the client
      end
    end)
  )
end

-- Toggle LSPs on or off, managing client states and attached buffers
function _G.toggle_lsp()
  if lsp_enabled then -- If LSP is currently enabled, disable it
    client_configs = {} -- Clear client configurations
    attached_buffers_by_client = {} -- Clear attached buffers

    -- Loop through all active LSP clients
    for _, client in ipairs(vim.lsp.get_clients()) do
      client_configs[client.id] = client.config -- Cache client config

      -- Loop through all buffers attached to the client
      for buf, _ in pairs(client.attached_buffers) do
        add_buf(client.id, buf) -- Add buffer to the client’s buffer table
        vim.lsp.buf_detach_client(buf, client.id) -- Detach the client from the buffer
      end

      client_stop(client) -- Stop the client
    end

    vim.notify("LSPs Disabled", vim.log.levels.INFO) -- Notify that LSPs are disabled
  else -- If LSP is currently disabled, enable it
    local new_ids = {}

    -- Reinitialize clients with previous configurations
    for client_id, buffers in pairs(attached_buffers_by_client) do
      local client_config = client_configs[client_id] -- Retrieve client config
      local new_client_id, err = vim.lsp.start_client(client_config) -- Start client with config

      new_ids[client_id] = new_client_id -- Map old client ID to new client ID

      if err then -- Notify if there was an error starting the client
        vim.notify(err, vim.log.levels.WARN)
        return nil
      end

      -- Reattach buffers to the newly started client
      for _, buf in ipairs(buffers) do
        original_buf_attach_client(buf, new_client_id)
      end
    end

    update_clients_ids(new_ids) -- Update client IDs
    vim.notify("LSPs Enabled", vim.log.levels.INFO) -- Notify that LSPs are disabled
  end

  lsp_enabled = not lsp_enabled -- Toggle the LSP enabled flag
end
