require "src.const"
require "src.update"
require "src.palette"
require "src.draw"
require "src.mouse"
require "src.complexnumber"
require "src.objects"
require "src.key"
require "src.door"
require "src.keyhandle"
require "src.hoverinfo"
require "src.controls"
require "src.player"
require "src.tilemap"

function love.load()
    InitializeTilemap()

    Tilemap[TileCoordsToId(0,8)] = 0
    Tilemap[TileCoordsToId(1,8)] = 0
    Tilemap[TileCoordsToId(2,8)] = 0
    Tilemap[TileCoordsToId(3,8)] = 0
    Tilemap[TileCoordsToId(4,8)] = 0
    Tilemap[TileCoordsToId(5,8)] = 0
    Tilemap[TileCoordsToId(5,5)] = 0
    Tilemap[TileCoordsToId(5,4)] = 0

    ObjectList[2] = {
        x = 160,
        y = 192,
        type = "door",
        width = 32,
        height = 64,
        color = "orange",
        locks = {
            {
                x = 8,
                y = 8,
                width = 16,
                height = 48,
                color = "orange",
                type = "normal",
                amount = CreateComplexNum(1),
                negative = false,
                imaginary_negative = false
            } --[[@as NormalLock]]
        },
        active = true,
        negativeborder = false,
        copies = CreateComplexNum(1),
        cursed = false,
        eroded = false,
        frozen = false,
        painted = false,
    } --[[@as Door]]
    ObjectList[3] = {
        type = "key",
        x = 96,
        y = 192,
        color = "orange",
        key_type = "add",
        active = true,
        amount = CreateComplexNum(1),
        reusable = false,
    } --[[@as Key]]

    ObjectList[1] = {
        x = 640,
        y = 32,
        type = "keyhandle",
        colors = {
            "white",
            "orange",
        },
        width = 128,
        height = 96,
    } --[[@as KeyHandle]]

    LoadResources()

    InitKeys()
    InitPlayer()

    LoadPaletteFromFile("res/palettes/default.txt")
end