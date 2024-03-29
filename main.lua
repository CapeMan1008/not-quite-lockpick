require "src.const"
require "src.update"
require "src.draw"
require "src.mouse"
require "src.complexnumber"
require "src.key"
require "src.door"
require "src.objects"
require "src.hoverinfo"

function love.load()
    ObjectList[1] = {
        x = 32,
        y = 32,
        type = "key",
        color = "red",
        key_type = "add",
        active = true,
        amount = CreateComplexNum(1),
        reusable = false
    } --[[@as Key]]

    ObjectList[1] = {
        x = 96,
        y = 32,
        type = "key",
        color = "red",
        key_type = "add",
        active = true,
        amount = CreateComplexNum(-1),
        reusable = false
    } --[[@as Key]]

    ObjectList[1] = {
        x = 32,
        y = 96,
        type = "key",
        color = "null",
        key_type = "auralock",
        active = true,
        amount = CreateComplexNum(1),
        reusable = false
    } --[[@as Key]]


    LoadResources()

    InitKeys()
end