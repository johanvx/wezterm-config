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

local mono_font = wezterm.font_with_fallback({
  "Monaspace Neon",
  "Symbols Nerd Font",
  "Noto Sans CJK SC",
})

return {
  -- UI
  adjust_window_size_when_changing_font_size = false,
  color_scheme = "Matataki", -- or "Kagayaki" if in light mode
  enable_scroll_bar = true,
  font = mono_font,
  font_size = 24,
  tab_max_width = 40,
  use_fancy_tab_bar = false,
  window_decorations = "INTEGRATED_BUTTONS|RESIZE",
  -- Key map
  leader = { key = "Enter", mods = "CTRL", timeout_milliseconds = 1000 },
  keys = {
    {
      key = "c",
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
  },
  key_tables = {
    copy_mode = copy_mode,
  },
}
