---@class HoverBox
---@field x number
---@field y number
---@field text string?

---@type HoverBox
HoverBox = {
    x = 0,
    y = 0,
    text = nil
}

---Sets HoverBox to have the proper text
---@param obj? Object
function GenerateHoverInfo(obj)
    HoverBox.text = nil

    if not obj then
        return
    end

    HoverBox.text = ""

    if obj.type == "key" then
        ---@cast obj Key

        local text = ""

        if obj.type == "add" then
            text = COLOR_NAMES[obj.color] .. " Key\nAmount: " .. tostring(obj.amount)
        else
            text = KEY_TYPE_NAMES[obj.key_type] .. " " .. COLOR_NAMES[obj.color] .. " Key\nAmount: " .. tostring(obj.amount)
        end

        if obj.color == "glitch" and obj.mimic then
            text = text .. "\nMimic: " .. COLOR_NAMES[obj.mimic]
        end

        if obj.color == "fire" or obj.color == "ice" then
            text = text .. "\nCore: " .. tostring(obj.core_switch)
        end

        HoverBox.text = text

        return
    elseif obj.type == "door" then
        ---@cast obj Door

        local text = ""

        if #obj.locks == 0 then
            text = "Lockless " .. COLOR_NAMES[obj.color] .. " Door"
        elseif #obj.locks == 1 then
            text = COLOR_NAMES[obj.color] .. " Door\n"

            local lock = obj.locks[1]

            text = text .. "Cost: " .. LockCostAsString(lock) .. " " .. COLOR_NAMES[lock.color]
        else
            text = "Combo " .. COLOR_NAMES[obj.color] .. " Door"

            for _, lock in ipairs(obj.locks) do
                text = text .. "\nLock: " .. COLOR_NAMES[lock.color] .. ", Cost: " .. LockCostAsString(lock)
            end
        end

        if DoesDoorHaveColor(obj, "glitch", true) and obj.mimic then
            text = text .. "\nMimic: " .. COLOR_NAMES[obj.mimic]
        end

        if DoesDoorHaveColor(obj, "fire", true) or DoesDoorHaveColor(obj, "ice", true) then
            text = text .. "\nCore: " .. tostring(obj.core_switch)
        end

        if obj.frozen or obj.eroded or obj.painted or obj.cursed then
            text = text .. "\n- Effects -"

            if obj.cursed then
                text = text .. "\nCursed!"
            end

            if obj.frozen then
                text = text .. "\nFrozen! (1xRed)"
            end

            if obj.eroded then
                text = text .. "\nEroded! (5xGreen)"
            end

            if obj.painted then
                text = text .. "\nPainted! (3xBlue)"
            end
        end

        HoverBox.text = text

        return
    end

    HoverBox.text = nil
end

---Returns a string describing the cost of a lock, not accounting for color.
---@param lock Lock
---@return string
function LockCostAsString(lock)
    if lock.type == "normal" then
        ---@cast lock NormalLock

        return tostring(lock.amount)
    elseif lock.type == "blank" then
        ---@cast lock BlankLock

        return "None"
    elseif lock.type == "blast" then
        ---@cast lock BlastLock

        local sign = ""

        if lock.negative then
            sign = "-"
        else
            sign = "+"
        end

        if lock.imaginary then
            sign = sign .. "i"
        end

        return "[All " .. sign .. "]"
    elseif lock.type == "all" then
        ---@cast lock AllLock

        return "[ALL]"
    end

    return "ERROR"
end