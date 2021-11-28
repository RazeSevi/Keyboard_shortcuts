local wibox = require("wibox")
local location = require ('lib-tde.plugin').path()
local svgColor = require('theme.icons.dark-light')
local card = require('lib-widget.card')
local button = require('lib-widget.button')
local dpi = require('beautiful').xresources.apply_dpi
local capitalize = require('lib-tde.function.common').capitalize
local input = require('keyboard-setting.input')
local naughty = require('naughty')
local Original_Keybinds = require('keyboard-setting.original_keybinds')
local rounded_rect = require('lib-tde.widget.rounded')
--local rounded_rect = require('lib-tde.signals')
local gears = require('gears')


local keybindings_left = {
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
local keybindings_right = {
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
local KeyBinds_LeftBox = {
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
--TODO: key.conf set previous_song ->(mod4 + shift + k (line 36)) to Mod4+k
local KeyBinds_RightBox = {
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

local function update_lists()
  for i, value in ipairs(Original_Keybinds.Original_KeyBinds_LeftBox) do
    KeyBinds_LeftBox[i] = tostring(value)
  end

  for i, value in ipairs(Original_Keybinds.Original_KeyBinds_RightBox) do
    KeyBinds_RightBox[i] = tostring(value)
  end

  for i, value in ipairs(Original_Keybinds.Original_keybindings_left) do
    keybindings_left[i] = tostring(value)
  end

  for i, value in ipairs(Original_Keybinds.Original_keybindings_right) do
    keybindings_right[i] = tostring(value)
  end
end

local function is_unique(keybind)
  for i, value in ipairs(KeyBinds_LeftBox) do
    if keybind == value then
      return false, capitalize(keybindings_left[i])
    end
  end

  for i, value in ipairs(KeyBinds_RightBox) do
    if keybind == value then
      return false, capitalize(keybindings_right[i])
    end
  end

  return true, ""

end

local function Generate_keyboard_Input(text, binds, binds_index)
  local textBoxMargin = dpi(10)
  local textBox = wibox.widget {
    align = 'left',
    text = text,
    widget = wibox.widget.textbox
  }
  -- return wibox.container.margin(textbox, 0, 0, textBoxMargin, textBoxMargin)

  local buttonTextBox = wibox.widget {
    align = 'center',
    text = binds[binds_index],
    widget = wibox.widget.textbox
  }

  local addTextRight
  addTextRight = button({
    body = buttonTextBox,
    callback = function()
      input.stop_grabber()
      print("Changing keybinding for: " .. text)
      input.get_keyboard_input(function(keyboardShortcut)
        local unique, keybind = is_unique(keyboardShortcut)
        if unique or keybind == text then
          binds[binds_index] = keyboardShortcut
          buttonTextBox.text = binds[binds_index]
        else
          naughty.notify(
            {
              title = "Keyboard shortcuts",
              message = "Keybinding already exists for '" .. keybind .."'",
              icon = svgColor(location .. "keyboard.svg"),
              timeout = 5,
              screen = mouse.screen,
              urgency = 'critical',
            })

        end
      end)
    end
  })

  local horizontalBindLayout = wibox.widget {
    textBox,
    wibox.widget.base.empty_widget(),
    addTextRight,
    forced_height = dpi(30),
    layout = wibox.layout.ratio.horizontal
  }

  local background = wibox.widget{
    widget = wibox.container.background,
    bg = '#8c8c8c',
    --shape = rounded_rect.emit_change_rounded_corner_dpi(dpi(10)),
    shape = rounded_rect(dpi(10)), -- TODO: set to system defaults
    wibox.container.margin(horizontalBindLayout, dpi(10)),
    horizontalBindLayout
  }

  horizontalBindLayout:adjust_ratio(2, 0.45, 0.1, 0.45)

  local textBoxText = wibox.widget{
    top = textBoxMargin,
    bottom = textBoxMargin,
    left = textBoxMargin,
    right = textBoxMargin,
    background,
    widget = wibox.container.margin
  }
  --shape.transform(shape.rounded_rect) : transform(0.25) (background, textBoxMargin, textBoxMargin, 12)
    return textBoxText
end

local function LayoutAlign(leftbox, left, rightbox, right)
  local leftBox = wibox.widget{
    layout = wibox.layout.fixed.vertical
  }
  local rightBox = wibox.widget{
    layout = wibox.layout.fixed.vertical
  }

  for i, value in ipairs(left) do
    -- value = keybindings_left[i]
    value = capitalize(value)
    leftBox:add(Generate_keyboard_Input(value,leftbox, i))
  end

  for i, value in ipairs(right) do
    value = capitalize(value)
    rightBox:add(Generate_keyboard_Input(value, rightbox, i))
  end

  local widget = wibox.widget {
    leftBox,
    wibox.widget.base.empty_widget(),
    rightBox,
    layout = wibox.layout.ratio.horizontal
  }

  widget:adjust_ratio(2, 0.45, 0.1, 0.45)

  return widget
end

local cardBody = wibox.widget {
  layout = wibox.layout.fixed.vertical
}

local alignLayout = LayoutAlign(KeyBinds_LeftBox, keybindings_left, KeyBinds_RightBox, keybindings_right)

local reset = button({
  body = "Reset",
  callback = function()
    update_lists()

    alignLayout = LayoutAlign(KeyBinds_LeftBox, keybindings_left, KeyBinds_RightBox, keybindings_right)

    cardBody.children = {}
    cardBody:add(alignLayout)

    input.stop_grabber()
  end
})

cardBody:add(alignLayout)

local cardWidget = card({title="Key binds"})
cardWidget.update_body(cardBody)

local cardMargin = dpi(40)
local cardWithMargin = wibox.container.margin(wibox.widget {
  cardWidget,
  wibox.container.margin(reset, 0, 0, dpi(20)),
  layout = wibox.layout.fixed.vertical
}, cardMargin, cardMargin)

return {
  icon = svgColor(location .. "keyboard.svg"),
  name = "Keyboard shortcuts",
  widget = cardWithMargin
}


