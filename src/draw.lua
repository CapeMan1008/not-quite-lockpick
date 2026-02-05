---@type table<string, love.Font>
Fonts = {}

---@class TextureData

---@class ImageTexture : TextureData
---@field file string
---@field image love.Texture
---@field minFilter love.FilterMode
---@field maxFilter love.FilterMode

---@class SheetTexture : TextureData
---@field sheet string
---@field sprite string

---@alias TextureEntry { type: string, data: TextureData }
---@type table<string, TextureEntry>
Textures = {}

---@alias SpriteData { x: integer, y: integer, w: integer, h: integer }
---@alias Spritesheet { texture: string, spriteData: table<string, SpriteData> }
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

    local error_t,error_d = ParseTextureData("error")

    if not error_t then
        error()
    end

    Textures.error = { type = error_t, data = error_d }

    DrawQuad = love.graphics.newQuad(0,0,1,1,1,1)
end

---Gets a texture by it's name, loading the texture from res/textures if it currently isn't in the Textures table. If the texture doesn't exist, returns nil (it's up to you to check this).
---@param name string
---@return TextureEntry
---@nodiscard
function GetTexture(name, extension)
    if Textures[name] then
        return Textures[name]
    end

    local textureType, textureData = ParseTextureData(name)

    if not textureType then
        return Textures.error
    end

    Textures[name] = {
        type = textureType,
        data = textureData,
    }
    return Textures[name]
end

function love.draw()
    love.graphics.clear(0.5,0.5,0.5)

    love.graphics.setLineStyle("rough")

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
                local sx,sy = TextureSize(texture)
                x,y = x-sx,y-sy

                love.graphics.setColor(1,1,1)
                DrawTexture(texture, {x,y})
            end
        end
    end

    love.graphics.setBlendMode("alpha")
end

---@param name string
---@return Spritesheet
function GetSpritesheet(name)
    if Spritesheets[name] then
        return Spritesheets[name]
    end

    return LoadSpritesheetFromFile("res/spritesheets/"..name..".txt", name)
end

---@param filepath string
---@param name string
---@return Spritesheet
function LoadSpritesheetFromFile(filepath, name)
    local fileInfo = love.filesystem.getInfo(filepath, "file")

    if not fileInfo then
        error()
    end

    local file = love.filesystem.newFile(filepath, "r")

    if not file then
        error()
    end

    local lines = {}

    for line in file:lines() do
        lines[#lines+1] = line
    end

    Spritesheets[name] = ParseSpritesheetData(lines, name)
    return Spritesheets[name]
end

---@param lines string[]
---@param defaultTexture string
---@return Spritesheet
---@nodiscard
function ParseSpritesheetData(lines, defaultTexture)
    ---@type table<string, SpriteData>
    local spriteData = {}
    local texture = defaultTexture

    for _, line in ipairs(lines) do
        ---@type string,string
        local cmd, params = string.match(line, "^%s*(%S*)%s*(.*)")

        if cmd == "texture" then
            local name = string.match(params, "^[%w_]*")

            texture = name
        end

        if cmd == "sprite" then
            local name, x,y,w,h = string.match(params, "^([%w_]*)%s*(%d*)%s*(%d*)%s*(%d*)%s*(%d*)")

            x,y,w,h = tonumber(x) or 0, tonumber(y) or 0, tonumber(w) or 1, tonumber(h) or 1

            spriteData[name] = {x=x,y=y,w=w,h=h}
        end
    end

    return {
        texture = texture,
        spriteData = spriteData,
    }
end

---Filepath returned starts from folder "res".
---@param textureName string
---@return string? type
---@return TextureData textureData
---@nodiscard
function ParseTextureData(textureName)
    local textureDataFile = love.filesystem.newFile("res/textureData.txt", "r")

    if not textureDataFile then
        error("where the hell is textureData.txt")
    end

    ---@type string
    local currentTexture = nil
    ---@type table
    local textureData = {}
    ---@type string
    local textureType

    for line in textureDataFile:lines() do
        ---@type string,string
        local cmd, params = string.match(line, "^%s*(%S*)%s*(.*)")

        if cmd == "filetex" then
            ---@type string,string
            local name, path = string.match(params, "^([%w_]*)%s*(%S*)")

            currentTexture = name

            if currentTexture == textureName then
                textureType = "image"
                textureData.file = path
                textureData.minFilter = "nearest"
                textureData.maxFilter = "nearest"
            end
        end

        if cmd == "sheettex" then
            ---@type string,string,string
            local name, sheet, sprite = string.match(params, "^([%w_]*)%s*([%w_]*)%s*([%w_]*)")

            currentTexture = name

            if currentTexture == textureName then
                textureType = "sheet"
                textureData.sheet = sheet
                textureData.sprite = sprite
            end
        end

        if currentTexture == textureName and textureType == "image" and cmd == "filter" then
            ---@type string?, string?
            local minFilter, maxFilter = string.match(params, "^(%S*)%s*(%S*)")

            if minFilter == "nearest" or minFilter == "linear" then
                textureData.minFilter = minFilter
            end
            if maxFilter == "nearest" or maxFilter == "linear" then
                textureData.maxFilter = maxFilter
            end
        end
    end

    if textureType == "image" then
        textureData.image = LoadImage(textureData.file)
    end

    return textureType, textureData
end

---@param filepath string
---@return love.Image
---@nodiscard
function LoadImage(filepath)
    local path = "res/" .. filepath

    local file_info = love.filesystem.getInfo(path, "file")

    if not file_info then
        error("missing file")
    end

    return love.graphics.newImage(path)
end

---@param texture TextureEntry
---@param drawParams table
---@param quad love.Quad?
function DrawTexture(texture, drawParams, quad)
    if texture.type == "image" then
        ---@cast texture { type: string, data: ImageTexture }
        
        if quad then
            love.graphics.draw(texture.data.image, quad, unpack(drawParams))
            return
        end

        love.graphics.draw(texture.data.image, unpack(drawParams))
        return
    end

    if texture.type == "sheet" then
        ---@cast texture { type: string, data: SheetTexture }

        if quad then
            error()
        end

        local sheet = GetSpritesheet(texture.data.sheet)
        local sprite = sheet.spriteData[texture.data.sprite]
        local tex = GetTexture(sheet.texture)

        DrawQuad:setViewport(sprite.x,sprite.y, sprite.w,sprite.h, TextureSize(tex))
        DrawTexture(tex, drawParams, DrawQuad)
        
        return
    end
end

---@param texture TextureEntry
---@return number
---@return number
function TextureSize(texture)
    if texture.type == "image" then
        ---@cast texture { type: string, data: ImageTexture }
        return texture.data.image:getWidth(), texture.data.image:getHeight()
    end

    if texture.type == "sheet" then
        ---@cast texture { type: string, data: SheetTexture }
        local sheet = GetSpritesheet(texture.data.sheet)
        local sprite = sheet.spriteData[texture.data.sprite]

        return sprite.w, sprite.h
    end

    error()
end