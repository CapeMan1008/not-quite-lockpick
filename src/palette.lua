---@type table<KeyColor, { [1]: number, [2]: number, [3]: number, [4]: number? }>
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

--TODO
---@param filepath string
function LoadPaletteFromFile(filepath)
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

    ParsePaletteData(lines)
end

---@param lines string[]
function ParsePaletteData(lines)
    ---@type string
    local currentColor = nil

    for _, line in ipairs(lines) do
        ---@type string,string
        local cmd, params = string.match(line, "^%s*(%S*)%s*(.*)")

        if cmd == "color" then
            ---@type string
            local color = string.match(params, "^([%w_]+)")

            if color then
                currentColor = color
            end
        end

        if cmd == "base" then
            local r,g,b,a = string.match(params, "^(b?[%d%.]*)%s*(b?[%d%.]*)%s*(b?[%d%.]*)%s*(b?[%d%.]*)")

            ---@param str string
            ---@return number?
            local function annoyingConversion(str)
                if string.find(str, "^b") then
                    local num = tonumber(string.sub(str, 2))

                    if num then
                        return num / 255
                    end

                    return num
                end

                return tonumber(str)
            end

            r,g,b,a = annoyingConversion(r),annoyingConversion(g),annoyingConversion(b),annoyingConversion(a)

            if currentColor then
                Palette[currentColor] = {r or 0, g or 0, b or 0, a or 1}
            end
        end
    end
end