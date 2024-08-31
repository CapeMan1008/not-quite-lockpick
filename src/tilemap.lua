---@type integer[]
Tilemap = {}

---@class Mapdata
---@field width integer
---@field height integer
---@field tileset string
Mapdata = {
    width = 25,
    height = 19,
    tileset = "placeholder",
}

function InitializeTilemap()
    for i = 0, Mapdata.width * Mapdata.height - 1 do
        Tilemap[i] = -1
    end
end

---@param x integer
---@param y integer
---@return integer
---@nodiscard
function TileCoordsToId(x,y)
    return x + y * Mapdata.width
end

---@param id integer
---@return integer x
---@return integer y
---@nodiscard
function TileIdToCoords(id)
    return id % Mapdata.width, id * Mapdata.width
end

---@param x integer
---@param y integer
---@return integer x
---@return integer y
---@nodiscard
function PixelCoordsToTileCoords(x,y)
    return math.floor(x / TILE_SIZE), math.floor(y / TILE_SIZE)
end

---@param x integer
---@param y integer
---@return integer x
---@return integer y
---@nodiscard
function PixelCoordsToTileCoords(x,y)
    return x * TILE_SIZE, y * TILE_SIZE
end

---@param id integer
function DrawTile(id)
    if Tilemap[id] < 0 then
        return
    end

    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", id % Mapdata.width * TILE_SIZE, id * Mapdata.width * TILE_SIZE, TILE_SIZE, TILE_SIZE)
end

function DrawTilemap()
    for _, id in ipairs(Tilemap) do
        DrawTile(id)
    end
end