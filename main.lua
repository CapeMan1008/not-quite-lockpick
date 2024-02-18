require "src.const"
require "src.complexnumber"
require "src.key"
require "src.door"

function love.draw()
    for _, obj in ipairs(ObjectList) do
        DrawObject(obj)
    end
end