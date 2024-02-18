require "src.const"
require "src.complexnumber"
require "src.key"
require "src.door"
require "src.objects"
require "src.hoverinfo"

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
                    amount = 5
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

    Font = love.graphics.newFont(12)
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

    HoverBox.x = x
    HoverBox.y = y

    GenerateHoverInfo(hovered_obj)
end

function love.draw()
    for _, obj in ipairs(ObjectList) do
        DrawObject(obj)
    end

    if HoverBox.text then
        love.graphics.setFont(Font)

        local _, newlines = string.gsub(HoverBox.text, "\n", "\n")

        local text_height = Font:getHeight() * Font:getLineHeight() * (newlines+1)

        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("fill", HoverBox.x, HoverBox.y, Font:getWidth(HoverBox.text)+16, text_height+16)

        love.graphics.setColor(0,0,0,1)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle("line", HoverBox.x+0.5, HoverBox.y+0.5, Font:getWidth(HoverBox.text)+15, text_height+15)

        love.graphics.print(HoverBox.text, HoverBox.x+8, HoverBox.y+8)
    end
end