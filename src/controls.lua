---@enum (key) ControlType
local controlKeys = {
    left = {"left"},
    right = {"right"},
    up = {"up"}, -- in menus
    down = {"down"}, -- in menus
    jump = {"space"},
    select = {"space"}, -- in menus
    undo = {"z"},
    restart = {"r"},
    leave = {"backspace"},
    warp = {"w"},
    camera = {"c"},
    auto_run = {"e"},
    run = {"lshift"},
    slow_walk = {"lctrl"},
    interact = {"up"}, -- enter levels and talk to npcs
    action = {"x"}, -- use master keys and probably other things too
    i_view = {"s"},
    keypad = {"a"},
}

---@param control ControlType
---@return boolean
function IsControlDown(control)
    for _, v in ipairs(controlKeys[control]) do
        if love.keyboard.isDown(v) then
            return true
        end
    end

    return false
end

---@param control ControlType
---@param key love.KeyConstant
---@return boolean
function DoesControlHaveKey(control, key)
    for _, v in ipairs(controlKeys[control]) do
        if v == key then
            return true
        end
    end

    return false
end