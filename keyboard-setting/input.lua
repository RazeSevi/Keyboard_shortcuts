local keygrabber = require("awful.keygrabber")

local prev_grabber
local grabber

local stop_key = "Escape"

local function get_keyboard_input(update_cb)
    if keygrabber.is_running then
        prev_grabber = keygrabber.current_instance
        prev_grabber:stop()
    end

    grabber = awful.keygrabber {
        autostart = true,
        keypressed_callback = function(_, mod, key)
            if key == stop_key or key == "Super_L" or key == "Super_R" then
                return
            end

            local str = ""
            for _, modkey in ipairs(mod) do
                str = str .. modkey .. "+"
            end
            str = str .. key

            update_cb(str)
        end,

        -- Note that it is using the key name and not the modifier name.
        stop_key           = stop_key,
        stop_event         = 'release',
        start_callback     = awful.client.focus.history.disable_tracking,
        stop_callback      = function ()
            if prev_grabber ~= nil then
                prev_grabber:start()
                prev_grabber = nil
            end
        end,
        export_keybindings = false,
    }
end

local function  stop_grabber()
    if grabber ~= nil then
        grabber:stop()
        grabber = nil
    end
end

return {
    get_keyboard_input = get_keyboard_input,
    stop_grabber = stop_grabber,
}