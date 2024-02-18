---@type table<string, love.Font>
Fonts = {}
---@type table<string, love.Texture>
Textures = {}

---@type table<KeyColor, { [1]: number, [2]: number, [3]: number }>
Palette = {
    white = {0.8,0.85,0.85},
    orange = {1,0.5,0},
    cyan = {0,1,1},
    purple = {0.5,0,1},
    pink = {1,0,1},
    red = {1,0,0},
    green = {0,1,0},
    blue = {0,0,1},
    brown = {0.5,0.25,0},
    pure = {1,1,1},
    master = {1,1,0},
    glitch = {0.5,0.5,0.5},
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
    for _, obj in ipairs(ObjectList) do
        DrawObject(obj)
    end

    if HoverBox.text then
        DrawHoverBox()
    end
end

---@param obj DoorObject
function DrawDoorObject(obj)
    if not obj.data.active then
        return
    end

    love.graphics.setColor(Palette[obj.data.color] or {1,1,1})
    love.graphics.rectangle("fill", obj.x, obj.y, obj.data.width, obj.data.height)
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