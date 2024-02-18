require "src.const"
require "src.complexnumber"
require "src.key"
require "src.door"
require "src.objects"

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
    }
end

function love.draw()
    for _, obj in ipairs(ObjectList) do
        DrawObject(obj)
    end
end