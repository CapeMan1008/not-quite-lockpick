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