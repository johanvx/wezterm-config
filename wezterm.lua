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

-- Modify Dracula colorscheme
local dracula = wezterm.color.get_builtin_schemes()["Dracula (Official)"]
dracula.background = "#22212c"
dracula.foreground = "#f8f8f2"
dracula.ansi = {
  "#21222c",
  "#ff5555",
  "#8aff80",
  "#ffff80",
  "#9580ff",
  "#ff80bf",
  "#80ffea",
  "#f8f8f2",
}
dracula.compose_cursor = "#ff9580"

return {
  -- UI
  color_schemes = {
    ["Dracula (Modified)"] = dracula,
  },
  color_scheme = "Dracula (Modified)",
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  colors = {
    tab_bar = {
      background = dracula.background,
      active_tab = {
        bg_color = dracula.background,
        fg_color = dracula.foreground,
        intensity = "Bold",
        italic = true,
        underline = "Single",
      },
      inactive_tab = {
        bg_color = dracula.background,
        fg_color = dracula.foreground,
      },
      inactive_tab_hover = {
        bg_color = dracula.background,
        fg_color = dracula.foreground,
        intensity = "Bold",
      },
      new_tab = {
        bg_color = dracula.background,
        fg_color = dracula.foreground,
      },
      new_tab_hover = {
        bg_color = dracula.background,
        fg_color = dracula.foreground,
        intensity = "Bold",
      },
    },
  },
  tab_max_width = 40,
  font = wezterm.font_with_fallback({ "Hack Nerd Font", "Sarasa Mono SC" }),
  font_size = 16,
  window_decorations = "RESIZE",
  -- Key map
  leader = { key = "g", mods = "CTRL", timeout_milliseconds = 1000 },
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

-- vim:sw=2:ts=2:sts=2:et:tw=80:norl:
