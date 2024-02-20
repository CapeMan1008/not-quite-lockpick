require "src.const"
require "src.draw"
require "src.complexnumber"
require "src.key"
require "src.door"
require "src.objects"
require "src.hoverinfo"
require "src.mouse"

function love.load()
    ObjectList[1] = {
        x = 16,
        y = 16,
        type = "key",
        data = {
            color = "orange",
            type = "add",
            active = true,
            amount = CreateComplexNum(1),
            reusable = false
        }
    } --[[@as KeyObject]]

    ObjectList[2] = {
        x = 64,
        y = 16,
        type = "door",
        data = {
            color = "cyan",
            active = true,
            copies = CreateComplexNum(1),
            negativeborder = false,
            cursed = false,
            eroded = false,
            frozen = false,
            painted = false,
            width = 64,
            height = 32,
            locks = {
                {
                    x = 8,
                    y = 8,
                    width = 16,
                    height = 16,
                    color = "cyan",
                    type = "normal",
                    amount = CreateComplexNum(-1)
                },
                {
                    x = 40,
                    y = 8,
                    width = 16,
                    height = 16,
                    color = "master",
                    type = "blank"
                }
            }
        }
    } --[[@as DoorObject]]

    ObjectList[3] = {
        x = 16,
        y = 64,
        type = "door",
        data = {
            color = "orange",
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
                    color = "orange",
                    type = "normal",
                    amount = CreateComplexNum(1)
                },
            }
        }
    } --[[@as DoorObject]]

    ObjectList[4] = {
        x = 64,
        y = 64,
        type = "door",
        data = {
            color = "glitch",
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
                    color = "orange",
                    type = "normal",
                    amount = CreateComplexNum(1)
                },
            }
        }
    } --[[@as DoorObject]]

    ObjectList[5] = {
        x = 96,
        y = 64,
        type = "door",
        data = {
            color = "cyan",
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
                    color = "cyan",
                    type = "blank"
                },
            }
        }
    } --[[@as DoorObject]]

    ObjectList[6] = {
        x = 144,
        y = 16,
        type = "key",
        data = {
            color = "master",
            type = "add",
            active = true,
            amount = CreateComplexNum(1),
            reusable = false
        }
    } --[[@as KeyObject]]

    ObjectList[7] = {
        x = 144,
        y = 64,
        type = "key",
        data = {
            color = "master",
            type = "add",
            active = true,
            amount = CreateComplexNum(-1),
            reusable = false
        }
    } --[[@as KeyObject]]

    LoadResources()

    InitKeys()
end