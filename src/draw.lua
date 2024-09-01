---@type table<string, love.Font>
Fonts = {}
---@type table<string, love.Texture>
Textures = {}
Textures.error = love.graphics.newImage("res/textures/error.png")
Textures.error:setFilter("nearest", "nearest")
---@alias SpriteData { x: integer, y: integer, w: integer, h: integer }
---@alias Spritesheet { image: love.Texture, quad: love.Quad, spriteData: table<string, SpriteData> }
---@type table<string, Spritesheet>
Spritesheets = {}
---@type table<string, love.Shader>
Shaders = {
--    static = love.graphics.newShader("src/shaders/static.glsl")
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

---Gets a texture by it's name, loading the texture from res/textures if it currently isn't in the Textures table. If the texture doesn't exist, returns an error texture.
---@param name string
---@return love.Texture
---@nodiscard
function GetTexture(name)
    if Textures[name] then
        return Textures[name]
    end

    local filepath = "res/textures/" .. name

    local file_info = love.filesystem.getInfo(filepath, "file")

    if file_info then
        Textures[name] = love.graphics.newImage(filepath)
        Textures[name]:setFilter("nearest", "nearest")
        return Textures[name]
    end

    return Textures.error
end

function love.draw()
    love.graphics.clear(0.5,0.5,0.5)

    --if Shaders.static:hasUniform("time") then
    --    Shaders.static:send("time", AnimationTimer)
    --end

    DrawTilemap()

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

---@param filepath string
---@param name string
function LoadSpritesheetFromFile(filepath, name)
    local fileInfo = love.filesystem.getInfo(filepath, "file")

    if not fileInfo then
        return
    end

    local file = love.filesystem.newFile(filepath, "r")

    if not file then
        return
    end

    local lines = {}

    for line in file:lines() do
        lines[#lines+1] = line
    end

    Spritesheets[name] = ParseSpritesheetData(lines, string.match(filepath, "^res/spritesheets/(.-)%.?.*$"))
end

---@param lines string[]
---@param defaultImage string
---@return Spritesheet
function ParseSpritesheetData(lines, defaultImage)
    ---@type table<string, SpriteData>
    local spriteData = {}
    local sheetImage = defaultImage

    for _, line in ipairs(lines) do
        ---@type string,string
        local cmd, params = string.match(line, "^%s*(%S*)%s*(.*)")

        if cmd == "sprite" then
            local name, x,y,w,h = string.match(params, "^([%w_]*)%s*(%d*)%s*(%d*)%s*(%d*)%s*(%d*)")

            x,y,w,h = tonumber(x) or 0, tonumber(y) or 0, tonumber(w) or 1, tonumber(h) or 1

            spriteData[name] = {x=x,y=y,w=w,h=h}
        end

        if cmd == "setimage" then
            local name = string.match(params, "^[%w_]*")

            sheetImage = name
        end
    end

    local imageTexture = GetTexture(sheetImage)

    return {
        image = imageTexture,
        spriteData = spriteData,
        quad = love.graphics.newQuad(0,0, 1,1, imageTexture),
    } --[[@as Spritesheet]]
end