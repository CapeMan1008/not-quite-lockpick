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