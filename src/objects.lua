---@class Object
---@field type ObjectType
---@field x integer
---@field y integer

---@class DoorObject : Object
---@field type "door"
---@field data Door

---@class KeyObject : Object
---@field type "key"
---@field data Key

---@alias ObjectType
---| '"door"'
---| '"key"'

---@type Object[]
ObjectList = {}

---Draws an object to the screen at it's coordinates.
---@param object Object
function DrawObject(object)
    if not object then
        return
    end

    if object.type == "door" then
        ---@cast object DoorObject
        DrawDoorObject(object)
    elseif object.type == "key" then
        ---@cast object KeyObject
        DrawKeyObject(object)
    end
end

---@param object DoorObject
function DrawDoorObject(object)
    if not object.data.active then
        return
    end

    love.graphics.rectangle("fill", object.x, object.y, object.data.width, object.data.height)
end

---@param object KeyObject
function DrawKeyObject(object)
    if not object.data.active then
        return
    end

    love.graphics.circle("fill", object.x+16, object.y+16, 16)
end

---Gets if an object is touching a certain point.
---@param obj Object
---@param x number
---@param y number
---@return boolean
---@nodiscard
function IsObjectOTouchingPoint(obj, x, y)
    if obj.type == "key" then
        ---@cast obj KeyObject

        if x >= obj.x and
        x <= obj.x+32 and
        y >= obj.y and
        y <= obj.y+32 then
            return true
        end
    elseif obj.type == "door" then
        ---@cast obj DoorObject

        if x >= obj.x and
        x <= obj.x+obj.data.width and
        y >= obj.y and
        y <= obj.y+obj.data.height then
            return true
        end
    end

    return false
end