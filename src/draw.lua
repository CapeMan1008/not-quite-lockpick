---@type table<string, love.Font>
Fonts = {}
---@type table<string, love.Texture>
Textures = {}

---@type table<KeyColor, { [1]: number, [2]: number, [3]: number }>
Palette = {
    white = {214/255,207/255,201/255},
    orange = {214/255,143/255,73/255},
    cyan = {80/255,175/255,175/255},
    purple = {143/255,95/255,192/255},
    pink = {207/255,112/255,159/255},
    red = {200/255,55/255,55/255},
    green = {53/255,159/255,80/255},
    blue = {95/255,113/255,160/255},
    brown = {112/255,64/255,16/255},
    black = {54/255,48/255,41/255},
    pure = {1,1,1},
    master = {1,1,0.5},
    glitch = {0.3,0.3,0.3},
    fire = {1,0.3,0},
    ice = {0.4,0.9,1},
}

AnimationTimer = 0

---@param h number
---@param s number
---@param v number
---@param a number?
---@return number r
---@return number g
---@return number b
---@return number a
function HSVtoRGB(h,s,v,a)
    ---@param n number
    ---@return number
    local function f(n)
        local k = (n+h/60)%6

        return v-v*s*math.max(0,math.min(k,4-k,1))
    end

    return f(5),f(3),f(1),a or 1
end

function LoadResources()
    Fonts.default = love.graphics.newFont(12)
end

---Gets a texture by it's name, loading the texture from res/textures if it currently isn't in the Textures table. If the texture doesn't exist, returns nil (it's up to you to check this).
---@param name string
---@param extension string? Appended to the end of the filepath without affecting the name of the texture. Defaults to ".png".
---@return love.Texture?
---@nodiscard
function GetTexture(name, extension)
    if Textures[name] then
        return Textures[name]
    end

    if not extension then
        extension = ".png"
    end

    local filepath = "res/textures/" .. name .. extension

    local file_info = love.filesystem.getInfo(filepath, "file")

    if file_info then
        Textures[name] = love.graphics.newImage(filepath)
        Textures[name]:setFilter("nearest", "nearest")
        return Textures[name]
    end
end

function love.draw()
    love.graphics.clear(0.5,0.5,0.5)

    for _, obj in ipairs(ObjectList) do
        DrawObject(obj)
    end

    if RightClickMenu.obj then
        DrawRightClickMenu()
    elseif HoverBox.text then
        DrawHoverBox()
    end

    local key_display_text = ""
    local first_line = true

    for key, value in pairs(Keys) do
        if first_line then
            key_display_text = key .. ": " .. tostring(value)

            first_line = false
        else
            key_display_text = key_display_text .. "\n" .. key .. ": " .. tostring(value)
        end
    end

    love.graphics.setColor(1,1,1)
    love.graphics.print(key_display_text, love.graphics.getWidth()-128, 16)
end

---@param obj Door
function DrawDoorObject(obj)
    if not obj.active then
        return
    end

    local visible_color = obj.color

    if obj.cursed then
        visible_color = "brown"
    end

    love.graphics.setColor(Palette[visible_color] or {1,1,1})
    love.graphics.rectangle("fill", obj.x, obj.y, obj.width, obj.height)

    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line", obj.x+0.5, obj.y+0.5, obj.width-1, obj.height-1)

    for _, lock in ipairs(obj.locks) do
        visible_color = lock.color

        if obj.cursed then
            visible_color = "brown"
        end

        love.graphics.setColor(Palette[visible_color] or {1,1,1})
        love.graphics.rectangle("fill", obj.x+lock.x, obj.y+lock.y, lock.width, lock.height)

        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("line", obj.x+lock.x+0.5, obj.y+lock.y+0.5, lock.width-1, lock.height-1)

        if lock.type == "normal" then
            ---@cast lock NormalLock
            love.graphics.setFont(Fonts.default)

            local text_width, text_height = Fonts.default:getWidth(tostring(lock.amount)), Fonts.default:getHeight()

            love.graphics.print(tostring(lock.amount), obj.x+lock.x+lock.width/2-text_width/2, obj.y+lock.y+lock.height/2-text_height/2)
        end
    end

    if obj.copies ~= CreateComplexNum(1) then
        local text = "x"..tostring(obj.copies)

        love.graphics.setFont(Fonts.default)

        local text_width, text_height = Fonts.default:getWidth(text), Fonts.default:getHeight()

        love.graphics.setColor(1,1,1)

        love.graphics.print(text, obj.x+obj.width/2-text_width/2, obj.y-text_height)
    end
end

---@param obj Key
function DrawKeyObject(obj)
    if not obj.active then
        return
    end

    local key_image_prefix = KEY_TYPE_IMAGES[obj.key_type]

    love.graphics.setColor(Palette[obj.color] or {1,1,1})
    love.graphics.draw(GetTexture(key_image_prefix .. "_1") --[[@as love.Texture]], obj.x, obj.y)

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(GetTexture(key_image_prefix .. "_0") --[[@as love.Texture]], obj.x, obj.y)

    if not obj.amount or obj.amount == CreateComplexNum(1) then
        return
    end

    local text = tostring(obj.amount)

    love.graphics.setFont(Fonts.default)

    local text_width, text_height = Fonts.default:getWidth(text), Fonts.default:getHeight()

    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", obj.x+31-text_width, obj.y+31-text_height, text_width+2, text_height+2)

    love.graphics.setColor(1,1,1)
    love.graphics.print(text, obj.x+32-text_width, obj.y+32-text_height)
end

function DrawHoverBox()
    love.graphics.setFont(Fonts.default)

    local _,linebreaks = string.gsub(HoverBox.text, "\n", "\n")

    local text_width, text_height = Fonts.default:getWidth(HoverBox.text), Fonts.default:getHeight()*(linebreaks+1)

    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill", HoverBox.x, HoverBox.y, text_width+HOVER_BOX_SPACING*2, text_height+HOVER_BOX_SPACING*2)

    love.graphics.setColor(0,0,0,1)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", HoverBox.x+0.5, HoverBox.y+0.5, text_width+HOVER_BOX_SPACING*2-1, text_height+HOVER_BOX_SPACING*2-1)

    love.graphics.print(HoverBox.text, HoverBox.x+HOVER_BOX_SPACING, HoverBox.y+HOVER_BOX_SPACING)
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