---@type table<string, love.Font>
Fonts = {}
---@type table<string, love.Texture>
Textures = {}
---@type table<string, love.Shader>
--Shaders = {
--    static = love.graphics.newShader("src/shaders/static.glsl")
--}

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
    null = {0,0,0,0},
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

    --if Shaders.static:hasUniform("time") then
    --    Shaders.static:send("time", AnimationTimer)
    --end

    for _, obj in ipairs(ObjectList) do
        DrawObject(obj)
    end

    DrawAuras()

    DrawPlayer()

    if RightClickMenu.obj then
        DrawRightClickMenu()
    elseif HoverBox.text then
        DrawHoverBox()
    end
end

--- Draws auras. Wow this comment is useless.
function DrawAuras()
    for aura, texture_name in pairs(AURA_IMAGES) do
        if CheckAura(aura) then
            local texture = GetTexture(texture_name)
            if texture then
                if aura == "curse" then
                    love.graphics.setBlendMode("subtract")
                else
                    love.graphics.setBlendMode("add")
                end

                local x,y = Player.x + PLAYER_WIDTH/2, Player.y + PLAYER_HEIGHT/2
                x,y = x-texture:getWidth()/2,y-texture:getHeight()/2

                love.graphics.setColor(1,1,1)
                love.graphics.draw(texture, x, y)
            end
        end
    end

    love.graphics.setBlendMode("alpha")
end