---@class RightClickMenu
---@field x number
---@field y number
---@field obj Object?
RightClickMenu = {
    x = 0,
    y = 0
}

---@param x number
---@param y number
function love.mousemoved(x, y)
    local hovered_obj

    for _, obj in ipairs(ObjectList) do
        if IsObjectOTouchingPoint(obj, x, y) then
            hovered_obj = obj
            break
        end
    end

    HoverBox.x = x
    HoverBox.y = y

    GenerateHoverInfo(hovered_obj)
end

---@param x number
---@param y number
---@param b integer
function love.mousepressed(x, y, b)
    if b == 1 or b == 2 or b == 3 then
        local clicked_obj

        for _, obj in ipairs(ObjectList) do
            if IsObjectOTouchingPoint(obj, x, y) then
                clicked_obj = obj
                break
            end
        end

        if not clicked_obj then
            return
        end

        if clicked_obj.type == "key" and b ~= 3 then
            ---@cast clicked_obj KeyObject

            CollectKey(clicked_obj.data)
        elseif clicked_obj.type == "door" then
            ---@cast clicked_obj DoorObject

            if b == 3 then
                TryAurasOnDoor(clicked_obj.data)
            else
                TryOpenDoor(clicked_obj.data, b == 2)
            end
        end
    end
end