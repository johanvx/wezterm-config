local wezterm = require("wezterm")
local act = wezterm.action

-- Modify copy mode
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

-- Font settings
local font_table = {
  normal = { "Monaspace Neon", "Noto Sans CJK SC", "Symbols Nerd Font" },
  pixel = {
    "Departure Mono",
    "Ark Pixel 12px Proportional zh_cn",
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

return {
  -- UI
  adjust_window_size_when_changing_font_size = false,
  color_scheme = scheme_for_appearance(get_appearance()),
  enable_scroll_bar = true,
  font = selected_font,
  font_size = 20,
  tab_max_width = 40,
  use_fancy_tab_bar = false,
  window_decorations = "INTEGRATED_BUTTONS|RESIZE",
  window_padding = { top = 0, bottom = 0, left = 8 },
  -- Key map
  leader = { key = "'", mods = "CTRL", timeout_milliseconds = 1000 },
  keys = {
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
  },
  key_tables = {
    copy_mode = copy_mode,
  },
}
