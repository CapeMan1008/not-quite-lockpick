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
        color = "white",
        key_type = "add",
        active = true,
        amount = CreateComplexNum(1),
        reusable = false
    } --[[@as Key]]

    ObjectList[2] = {
        x = 96,
        y = 32,
        type = "key",
        color = "orange",
        key_type = "exact",
        active = true,
        amount = CreateComplexNum(1),
        reusable = false
    } --[[@as Key]]

    ObjectList[3] = {
        x = 32,
        y = 96,
        type = "key",
        color = "purple",
        key_type = "star",
        active = true,
        amount = CreateComplexNum(1),
        reusable = false
    } --[[@as Key]]

    ObjectList[4] = {
        x = 96,
        y = 96,
        type = "key",
        color = "pink",
        key_type = "unstar",
        active = true,
        amount = CreateComplexNum(1),
        reusable = false
    } --[[@as Key]]


    LoadResources()

    InitKeys()
end