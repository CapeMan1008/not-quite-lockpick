require "src.const"
require "src.update"
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

function love.load()
    ObjectList[2] = {
        x = 64,
        y = 128,
        type = "door",
        width = 128,
        height = 32,
        color = "white",
        locks = {
            {
                x = 8,
                y = 8,
                width = 16,
                height = 16,
                color = "white",
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

    ObjectList[1] = {
        x = 640,
        y = 32,
        type = "keyhandle",
        colors = {
            "white",
        },
        width = 128,
        height = 96,
    } --[[@as KeyHandle]]


    LoadResources()

    InitKeys()
end