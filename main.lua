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

function love.load()
    ObjectList[2] = {
        x = 32,
        y = 32,
        type = "key",
        color = "white",
        key_type = "add",
        active = true,
        amount = CreateComplexNum(1),
        reusable = false
    } --[[@as Key]]

    ObjectList[3] = {
        x = 96,
        y = 32,
        type = "key",
        color = "orange",
        key_type = "add",
        active = true,
        amount = CreateComplexNum(1),
        reusable = false
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
end