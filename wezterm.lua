local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

--
-- OS related
--

local is_linux = wezterm.target_triple:find("linux") ~= nil
local is_darwin = wezterm.target_triple:find("darwin") ~= nil
local is_windows = wezterm.target_triple:find("windows") ~= nil

if is_windows then
  config.default_prog = { "pwsh", "--NoLogo" }
end

--
-- UI
--

-- Font settings
local font_table = {
  normal = { "Monaspace Neon", "Noto Sans CJK SC", "Symbols Nerd Font" },
  pixel = {
    -- "Doto",
    "Departure Mono",
    -- "Ark Pixel 12px Proportional zh_cn",
    "Unifont",
    "Symbols Nerd Font",
  },
}
local selected_font = wezterm.font_with_fallback(font_table.pixel)

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return "Dark"
end

-- Sync with OS
local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Lettepa Dark"
  else
    return "Lettepa Light"
  end
end

local color_scheme = scheme_for_appearance(get_appearance())

config.adjust_window_size_when_changing_font_size = false
config.color_scheme = color_scheme
config.enable_scroll_bar = true
config.font = selected_font
config.font_size = 16
config.tab_max_width = 40
config.use_fancy_tab_bar = true
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_padding = { top = 0, bottom = 0, left = 8 }

--
-- Key mappings
--

-- Copy mode
local copy_mode = nil
if wezterm.gui then
  copy_mode = wezterm.gui.default_key_tables().copy_mode
  table.insert(
    copy_mode,
    { key = "[", mods = "CTRL", action = act.CopyMode("Close") }
  )
  table.insert(copy_mode, {
    key = "Enter",
    mods = "NONE",
    action = act.Multiple({
      { CopyTo = "ClipboardAndPrimarySelection" },
      { CopyMode = "Close" },
    }),
  })
end
config.key_tables = { copy_mode = copy_mode }

-- Leader key
config.leader = { key = "'", mods = "CTRL", timeout_milliseconds = 1000 }

-- Key maps
config.keys = {
  {
    key = "y",
    mods = "LEADER",
    action = act.ActivateCopyMode,
  },
  {
    key = "p",
    mods = "LEADER",
    action = act.PasteFrom("PrimarySelection"),
  },
  {
    key = "s",
    mods = "LEADER",
    action = act.QuickSelect,
  },
  {
    key = "n",
    mods = "LEADER",
    action = act.PaneSelect,
  },
  {
    key = "%",
    mods = "LEADER",
    action = act.SplitHorizontal,
  },
  {
    key = '"',
    mods = "LEADER",
    action = act.SplitVertical,
  },
}

-- END
return config
