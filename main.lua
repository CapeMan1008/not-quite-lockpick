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
    ObjectList[1] = {
        x = 32,
        y = 32,
        type = "key",
        color = "white",
        key_type = "add",
        active = true,
        amount = CreateComplexNum(2),
        reusable = false
    } --[[@as Key]]

    ObjectList[2] = {
        x = 96,
        y = 32,
        type = "key",
        color = "white",
        key_type = "add",
        active = true,
        amount = CreateComplexNum(1),
        reusable = false
    } --[[@as Key]]

    ObjectList[3] = {
        x = 32,
        y = 96,
        type = "key",
        color = "white",
        key_type = "multiply",
        active = true,
        amount = CreateComplexNum(2),
        reusable = false
    } --[[@as Key]]

    ObjectList[4] = {
        x = 96,
        y = 96,
        type = "key",
        color = "white",
        key_type = "multiply",
        active = true,
        amount = CreateComplexNum(3),
        reusable = false
    } --[[@as Key]]

    ObjectList[5] = {
        x = 512,
        y = 32,
        type = "keyhandle",
        colors = {
            "white",
            "orange",
        },
        width = 128,
        height = 128,
    } --[[@as KeyHandle]]


    LoadResources()

    InitKeys()
end