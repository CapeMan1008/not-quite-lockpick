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
    } --[[@as KeyObject]]

    ObjectList[2] = {
        x = 64,
        y = 16,
        type = "door",
        data = {
            color = "orange",
            active = true,
            amount = CreateComplexNum(1),
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
                    type = "normal"
                }
            }
        }
    } --[[@as DoorObject]]
end

---@param x any
---@param y any
function love.mousemoved(x, y)
    local hovered_obj

    for _, obj in ipairs(ObjectList) do
        if IsObjectOTouchingPoint(obj, x, y) then
            hovered_obj = obj
            break
        end
    end
end

---Gets if an object is touching a certain point.
---@param obj Object
---@param x number
---@param y number
function IsObjectOTouchingPoint(obj, x, y)
    if obj then
        
    end
end

function love.draw()
    for _, obj in ipairs(ObjectList) do
        DrawObject(obj)
    end
end