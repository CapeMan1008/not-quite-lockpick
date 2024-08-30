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

        if menu_click then
            local selected_obj = RightClickMenu.obj
            ---@cast selected_obj Object

            if selected_obj.type == "key" then
                ---@cast selected_obj Key
                if menu_click == "Collect" then
                    CollectKey(selected_obj)
                end
            elseif selected_obj.type == "door" then
                ---@cast selected_obj Door
                if menu_click == "Open" then
                    TryOpenDoor(selected_obj, false, false)
                elseif menu_click == "Use Master Key" then
                    TryOpenDoor(selected_obj, true, false)
                elseif menu_click == "Try Auras" then
                    TryAurasOnDoor(selected_obj)
                end
            end

            RightClickMenu.obj = nil

            return
        end
    end

    if b == 2 then
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

        RightClickMenu.x = x
        RightClickMenu.y = y

        RightClickMenu.obj = clicked_obj
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

function DrawRightClickMenu()
    local buttons = GetRightClickButtons()

    love.graphics.setFont(Fonts.default)

    local text_width, text_height = 0, Fonts.default:getHeight()

    for _, text in ipairs(buttons) do
        if Fonts.default:getWidth(text) >= text_width then
            text_width = Fonts.default:getWidth(text)
        end
    end

    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill", RightClickMenu.x, RightClickMenu.y, text_width+RIGHT_CLICK_MENU_SPACING*2, RIGHT_CLICK_MENU_OPTION_HEIGHT*#buttons)

    love.graphics.setColor(0,0,0,1)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", RightClickMenu.x+0.5, RightClickMenu.y+0.5, text_width+RIGHT_CLICK_MENU_SPACING*2-1, RIGHT_CLICK_MENU_OPTION_HEIGHT*#buttons-1)

    for i, text in ipairs(buttons) do
        love.graphics.print(text, RightClickMenu.x+RIGHT_CLICK_MENU_SPACING, RightClickMenu.y+(RIGHT_CLICK_MENU_OPTION_HEIGHT-text_height)*0.5+(RIGHT_CLICK_MENU_OPTION_HEIGHT)*(i-1))

        if i ~= 1 then
            love.graphics.line(RightClickMenu.x, RightClickMenu.y+(RIGHT_CLICK_MENU_OPTION_HEIGHT)*(i-1), RightClickMenu.x+text_width+RIGHT_CLICK_MENU_SPACING*2, RightClickMenu.y+(RIGHT_CLICK_MENU_OPTION_HEIGHT)*(i-1))
        end
    end
end