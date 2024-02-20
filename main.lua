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
        data = {
            color = "white",
            active = true,
            copies = CreateComplexNum(1),
            negativeborder = false,
            cursed = false,
            eroded = false,
            frozen = false,
            painted = false,
            width = 32,
            height = 64,
            locks = {
                {
                    x = 8,
                    y = 8,
                    width = 16,
                    height = 48,
                    color = "white",
                    type = "normal",
                    amount = CreateComplexNum(3)
                },
                {
                    x = 40,
                    y = 8,
                    width = 16,
                    height = 48,
                    color = "white",
                    type = "normal",
                    amount = CreateComplexNum(3)
                }
            }
        }
    } --[[@as DoorObject]]

    ObjectList[2] = {
        x = 96,
        y = 32,
        type = "key",
        data = {
            color = "white",
            type = "exact",
            active = true,
            amount = CreateComplexNum(2),
            reusable = false
        }
    } --[[@as KeyObject]]

    ObjectList[3] = {
        x = 96,
        y = 64,
        type = "key",
        data = {
            color = "wild",
            type = "exact",
            active = true,
            amount = CreateComplexNum(1),
            reusable = false
        }
    } --[[@as KeyObject]]


    LoadResources()

    InitKeys()
end