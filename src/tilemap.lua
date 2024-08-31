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
    return id % Mapdata.width, math.floor(id / Mapdata.width)
end

---@param x integer
---@param y integer
---@return integer x
---@return integer y
---@nodiscard
function PixelCoordsToTileCoords(x,y)
    return math.floor(x / TILE_SIZE), math.floor(y / TILE_SIZE)
end

---Returns the top-left corner of the tile.
---@param x integer
---@param y integer
---@return integer x
---@return integer y
---@nodiscard
function TileCoordsToPixelCoords(x,y)
    return x * TILE_SIZE, y * TILE_SIZE
end

---Returns the top-left corner of the tile.
---@param x integer
---@param y integer?
---@return integer x
---@return integer? y
---@nodiscard
function RoundPixelCoordsToTile(x,y)
    return math.floor(x / TILE_SIZE) * TILE_SIZE, y and math.floor(y / TILE_SIZE) * TILE_SIZE
end

---@param id integer
---@return boolean
---@nodiscard
function IsTileSolid(id)
    return (Tilemap[id] or false) and Tilemap[id] >= 0
end

---@param id integer
function DrawTile(id)
    if Tilemap[id] < 0 then
        return
    end

    love.graphics.setColor(1,1,1)

    local x,y = TileCoordsToPixelCoords(TileIdToCoords(id))
    love.graphics.rectangle("fill", x, y, TILE_SIZE, TILE_SIZE)
end

function DrawTilemap()
    for id = 0, Mapdata.width * Mapdata.height - 1 do
        DrawTile(id)
    end
end