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
        amount = CreateComplexNum(2),
        reusable = false
    } --[[@as Key]]

    ObjectList[2] = {
        x = 96,
        y = 32,
        type = "key",
        color = "orange",
        key_type = "add",
        active = true,
        amount = CreateComplexNum(3),
        reusable = false
    } --[[@as Key]]

    ObjectList[3] = {
        x = 32,
        y = 96,
        type = "key",
        color = "white",
        key_type = "square",
        active = true,
        amount = CreateComplexNum(1),
        reusable = false
    } --[[@as Key]]

    ObjectList[4] = {
        x = 96,
        y = 96,
        type = "key",
        color = "orange",
        key_type = "square",
        active = true,
        amount = CreateComplexNum(1),
        reusable = false
    } --[[@as Key]]

    ObjectList[5] = {
        x = 160,
        y = 32,
        type = "key",
        color = "pink",
        key_type = "add",
        active = true,
        amount = CreateComplexNum(1, 1),
        reusable = false
    } --[[@as Key]]

    ObjectList[6] = {
        x = 160,
        y = 96,
        type = "key",
        color = "pink",
        key_type = "square",
        active = true,
        amount = CreateComplexNum(1),
        reusable = false
    } --[[@as Key]]

    ObjectList[7] = {
        x = 224,
        y = 96,
        type = "key",
        color = "glitch",
        key_type = "square",
        active = true,
        amount = CreateComplexNum(1),
        reusable = false
    } --[[@as Key]]

    ObjectList[8] = {
        x = 224,
        y = 32,
        type = "door",
        color = "white",
        active = true,
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
        width = 32,
        height = 32,
        cursed = false,
        frozen = false,
        eroded = false,
        painted = false,
        copies = CreateComplexNum(1),
        negativeborder = false,
    } --[[@as Door]]


    LoadResources()

    InitKeys()
end