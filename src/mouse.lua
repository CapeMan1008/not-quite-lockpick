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
    if b == 1 and RightClickMenu.obj then
        local menu_click = CheckRightClickMenuButtonsPressed(x, y)

        print(menu_click)

        if menu_click then
            return
        end
    end

    if b == 1 or b == 2 then
        if RightClickMenu.obj then
            RightClickMenu.obj = nil
        end

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

        if b == 2 then
            RightClickMenu.x = x
            RightClickMenu.y = y

            RightClickMenu.obj = clicked_obj
        elseif clicked_obj.type == "key" then
            ---@cast clicked_obj KeyObject

            CollectKey(clicked_obj.data)
        elseif clicked_obj.type == "door" then
            ---@cast clicked_obj DoorObject

            TryOpenDoor(clicked_obj.data, b == 2)
        end
    end
end

---@param x number
---@param y number
---@return string?
function CheckRightClickMenuButtonsPressed(x, y)
    local ox,oy = x-RightClickMenu.x,y-RightClickMenu.y

    local buttons = GetRightClickButtons()

    local text_width = 0

    for _, text in ipairs(buttons) do
        if Fonts.default:getWidth(text) >= text_width then
            text_width = Fonts.default:getWidth(text)
        end
    end

    if ox < 0 or ox > text_width+RIGHT_CLICK_MENU_SPACING*2 then
        return
    end

    local selected_option = math.floor((oy/RIGHT_CLICK_MENU_OPTION_HEIGHT)+1)

    print(selected_option)

    if selected_option < 1 or selected_option > #buttons then
        return
    end
    return buttons[selected_option]
end

function GetRightClickButtons()
    if not RightClickMenu.obj then
        return {}
    end

    if RightClickMenu.obj.type == "key" then
        return {"Collect"}
    elseif RightClickMenu.obj.type == "door" then
        return {"Open", "Use Master Key", "Try Auras"}
    end
end