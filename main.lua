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
        type = "door",
        color = "fire",
        active = true,
        copies = CreateComplexNum(1),
        negativeborder = false,
        cursed = false,
        eroded = false,
        frozen = false,
        painted = false,
        width = 32,
        height = 32,
        locks = {
            {
                x = 8,
                y = 8,
                width = 16,
                height = 16,
                color = "fire",
                type = "normal",
                amount = CreateComplexNum(1)
            },
        }
    } --[[@as Door]]

    ObjectList[2] = {
        x = 96,
        y = 32,
        type = "key",
        color = "fire",
        key_type = "add",
        active = true,
        amount = CreateComplexNum(1),
        reusable = false
    } --[[@as Key]]

    ObjectList[3] = {
        x = 32,
        y = 96,
        type = "door",
        color = "ice",
        active = true,
        copies = CreateComplexNum(1),
        negativeborder = false,
        cursed = false,
        eroded = false,
        frozen = false,
        painted = false,
        width = 32,
        height = 32,
        locks = {
            {
                x = 8,
                y = 8,
                width = 16,
                height = 16,
                color = "ice",
                type = "normal",
                amount = CreateComplexNum(1)
            },
        }
    } --[[@as Door]]

    ObjectList[4] = {
        x = 96,
        y = 96,
        type = "key",
        color = "ice",
        key_type = "add",
        active = true,
        amount = CreateComplexNum(1),
        reusable = false
    } --[[@as Key]]


    LoadResources()

    InitKeys()
end