local wezterm = require("wezterm")

return {
  -- For macOS
  default_prog = { "/opt/homebrew/bin/fish", "--login" },
  color_scheme = "Dracula (Official)",
  -- enable_tab_bar = false,
  font = wezterm.font_with_fallback({
    "Hack Nerd Font", "Sarasa Mono SC Nerd Font"
  }),
  font_size = 16,
  -- window_decorations = "RESIZE",
}

-- vim:sw=2:ts=2:sts=2:et:tw=80:cc=+1:norl:
