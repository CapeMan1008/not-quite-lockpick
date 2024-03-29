---@class KeyHandle : Object
---@field type "keyhandle"
---@field colors KeyColor[]
---@field width integer
---@field height integer

---@param obj KeyHandle
function DrawKeyHandle(obj)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", obj.x,obj.y, obj.width,obj.height)

    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", obj.x+0.5,obj.y+0.5, obj.width-1,obj.height-1)

    for i, color in ipairs(obj.colors) do
        local color_y = obj.y+(i-1)*KEY_HANDLE_SPACING+KEY_HANDLE_MARGIN

        -- Construct a dummy key to draw.
        ---@type Key
        local key = {
            x = obj.x+KEY_HANDLE_MARGIN,
            y = color_y,
            type = "key",
            color = color,
            key_type = "add",
            active = true,
            amount = CreateComplexNum(1),
            reusable = false
        }

        DrawKey(key)

        local text = tostring(Keys[color])

        local text_height = Fonts.default:getHeight()

        love.graphics.print(text, obj.x+KEY_HANDLE_TEXT_OFFSET, color_y+KEY_HANDLE_TEXT_HEIGHT/2-text_height/2)
    end
end