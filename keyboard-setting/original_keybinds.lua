local Original_keybindings_left = {
    "terminal",
    "fullscreen",
    "kill",
    "floating",
    "window_switch",
    "launcher",
    "browser",
    "filemanager",
    "systemmonitor",
    "previous_workspace",
    "next_workspace",
    "swap_workspace",
    "action_center",
    "toggle_focus",
    "lock",
    "notification_panel"
  }
  local Original_keybindings_right = {
    "restart_wm",
    "quit_wm",
    "next_layout",
    "previous_layout",
    "restore_minimized",
    "dropdown_terminal",
    "toggle_sound",
    "previous_song",
    "next_song",
    "screen",
    "printscreen",
    "snapshot_area",
    "window_screenshot",
    "emoji",
    "clipboard",
    "settings"
  }
  local Original_KeyBinds_LeftBox = {
    "Mod4+Return",
    "Mod4+f",
    "Mod4+q",
    "Mod4+c",
    "Mod4+b",
    "Mod4+d",
    "Mod4+shift+b",
    "Mod4+shift+e",
    "Mod4+shift+Escape",
    "Mod4+w",
    "Mod4+a",
    "Mod4+Escape",
    "Mod4+e",
    "Mod4+Tab",
    "Mod4+l",
    "Mod4+x"
  }
  local Original_KeyBinds_RightBox = {
    "Mod4+Control+r",
    "Mod4+Control+q",
    "Mod4+space",
    "Mod4+shift+space",
    "Mod4+Control+n",
    "F12",
    "Mod4+t",
    "Mod4+k",
    "Mod4+n",
    "Mod4+r",
    "Print",
    "Mod4+Print",
    "Mod4+shift +Print",
    "Mod4+m",
    "Mod4+p",
    "Mod4+s"
  }

  return {
    Original_keybindings_left = Original_keybindings_left,
    Original_keybindings_right = Original_keybindings_right,
    Original_KeyBinds_LeftBox = Original_KeyBinds_LeftBox,
    Original_KeyBinds_RightBox = Original_KeyBinds_RightBox
  }