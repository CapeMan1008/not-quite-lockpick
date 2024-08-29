---@class KeyHandle : RectObject
---@field type "keyhandle"
---@field colors KeyColor[]

---@param obj KeyHandle
function DrawKeyHandle(obj)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", obj.x,obj.y, obj.width,obj.height)

    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", obj.x+0.5,obj.y+0.5, obj.width-1,obj.height-1)

    for i, color in ipairs(obj.colors) do
        local x = obj.x+KEY_HANDLE_MARGIN
        local y = obj.y+(i-1)*KEY_HANDLE_SPACING+KEY_HANDLE_MARGIN

        local star_texture = GetTexture("sprStarGlow")
        if KeyStates[color].star and star_texture then
            love.graphics.setColor(1,1,0.75,1)
            love.graphics.draw(star_texture, x+16,y+16, AnimationTimer, KEY_HANDLE_STAR_SCALE, KEY_HANDLE_STAR_SCALE, KEY_HANDLE_STAR_OFFSET_X, KEY_HANDLE_STAR_OFFSET_Y)
        end

        -- Construct a dummy key to draw.
        ---@type Key
        local key = {
            x = x,
            y = y,
            type = "key",
            color = color,
            key_type = "add",
            active = true,
            amount = CreateComplexNum(1),
            reusable = false
        }

        DrawKey(key)

        local text = tostring(KeyStates[color].count or "N/A")

        local text_height = Fonts.default:getHeight()

        love.graphics.print(text, obj.x+KEY_HANDLE_TEXT_OFFSET, y+KEY_HANDLE_TEXT_HEIGHT/2-text_height/2)
    end
end