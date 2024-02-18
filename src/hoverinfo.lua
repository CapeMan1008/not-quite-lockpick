---@class HoverBox
---@field x number
---@field y number
---@field text string?

---@type HoverBox
HoverBox = {
    x = 0,
    y = 0,
    text = ""
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
        ---@cast obj KeyObject

        HoverBox.text = obj.data.type .. " " .. COLOR_NAMES[obj.data.color] .. " Key\nAmount: " .. tostring(obj.data.amount)

        return
    elseif obj.type == "door" then
        ---@cast obj DoorObject

        local text = ""

        if #obj.data.locks == 0 then
            text = "Lockless " .. COLOR_NAMES[obj.data.color] .. " Door"
        elseif #obj.data.locks == 1 then
            text = COLOR_NAMES[obj.data.color] .. " Door\n"

            local lock = obj.data.locks[1]

            text = text .. "Cost: " .. LockCostAsString(lock) .. " " .. COLOR_NAMES[lock.color]
        else
            text = "Combo " .. COLOR_NAMES[obj.data.color] .. " Door"

            for _, lock in ipairs(obj.data.locks) do
                text = text .. "\nLock: " .. COLOR_NAMES[lock.color] .. ", Cost: " .. LockCostAsString(lock)
            end
        end

        if GetDoorGlitched(obj.data) then
            text = text .. "\nMimic: " .. COLOR_NAMES[obj.data.mimic]
        end

        if obj.data.frozen or obj.data.eroded or obj.data.painted or obj.data.cursed then
            text = text .. "\n- Effects -"

            if obj.data.cursed then
                text = text .. "\nCursed!"
            end

            if obj.data.frozen then
                text = text .. "\nFrozen! (1xRed)"
            end

            if obj.data.eroded then
                text = text .. "\nEroded! (5xGreen)"
            end

            if obj.data.painted then
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