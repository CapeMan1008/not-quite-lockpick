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
    master = {1,1,0},
    glitch = {0.3,0.3,0.3},
    wild = {1,0,0},
}

function LoadResources()
    Textures.key_border = love.graphics.newImage("res/sprKey_0.png")
    Textures.key_border:setFilter("nearest", "nearest")

    Textures.key_inside = love.graphics.newImage("res/sprKey_1.png")
    Textures.key_inside:setFilter("nearest", "nearest")

    Fonts.default = love.graphics.newFont(12)
end

function love.draw()
    love.graphics.clear(0.5,0.5,0.5)

    for _, obj in ipairs(ObjectList) do
        DrawObject(obj)
    end

    if HoverBox.text then
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

---@param obj DoorObject
function DrawDoorObject(obj)
    if not obj.data.active then
        return
    end

    love.graphics.setColor(Palette[obj.data.color] or {1,1,1})
    love.graphics.rectangle("fill", obj.x, obj.y, obj.data.width, obj.data.height)

    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line", obj.x+0.5, obj.y+0.5, obj.data.width-1, obj.data.height-1)

    for _, lock in ipairs(obj.data.locks) do
        love.graphics.setColor(Palette[lock.color] or {1,1,1})
        love.graphics.rectangle("fill", obj.x+lock.x, obj.y+lock.y, lock.width, lock.height)

        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("line", obj.x+lock.x+0.5, obj.y+lock.y+0.5, lock.width-1, lock.height-1)

        if lock.type == "normal" then
            ---@cast lock NormalLock
            local text = love.graphics.newText(Fonts.default, tostring(lock.amount))

            local text_width, text_height = text:getDimensions()

            love.graphics.draw(text, obj.x+lock.x+lock.width/2-text_width/2, obj.y+lock.y+lock.height/2-text_height/2)
        end
    end

    if obj.data.copies ~= CreateComplexNum(1) then
        local text = love.graphics.newText(Fonts.default, "x"..tostring(obj.data.copies))

        local text_width, text_height = text:getDimensions()

        love.graphics.setColor(1,1,1)

        love.graphics.draw(text, obj.x+obj.data.width/2-text_width/2, obj.y+obj.data.height/2-text_height/2)
    end
end

---@param obj KeyObject
function DrawKeyObject(obj)
    if not obj.data.active then
        return
    end

    love.graphics.setColor(Palette[obj.data.color] or {1,1,1})
    love.graphics.draw(Textures.key_inside, obj.x, obj.y)

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(Textures.key_border, obj.x, obj.y)

    if not obj.data.amount then
        return
    end

    local text = love.graphics.newText(Fonts.default, tostring(obj.data.amount))

    local text_width, text_height = text:getDimensions()

    love.graphics.setColor(1,1,1)
    love.graphics.draw(text, obj.x+32-text_width, obj.y+32-text_height)
end

function DrawHoverBox()
    local text = love.graphics.newText(Fonts.default, HoverBox.text)

    local text_width, text_height = text:getDimensions()

    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill", HoverBox.x, HoverBox.y, text_width+16, text_height+16)

    love.graphics.setColor(0,0,0,1)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", HoverBox.x+0.5, HoverBox.y+0.5, text_width+15, text_height+15)

    love.graphics.draw(text, HoverBox.x+8, HoverBox.y+8)
end