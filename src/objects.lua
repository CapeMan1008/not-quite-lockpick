---@class Object
---@field type ObjectType
---@field x integer
---@field y integer

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
        ---@cast object Door
        DrawDoorObject(object)
    elseif object.type == "key" then
        ---@cast object Key
        DrawKeyObject(object)
    end
end

---Gets if an object is touching a certain point.
---@param obj Object
---@param x number
---@param y number
---@return boolean
---@nodiscard
function IsObjectOTouchingPoint(obj, x, y)
    if obj.type == "key" then
        ---@cast obj Key

        if not obj.active then
            return false
        end

        if x >= obj.x and
        x <= obj.x+32 and
        y >= obj.y and
        y <= obj.y+32 then
            return true
        end
    elseif obj.type == "door" then
        ---@cast obj Door

        if not obj.active then
            return false
        end

        if x >= obj.x and
        x <= obj.x+obj.width and
        y >= obj.y and
        y <= obj.y+obj.height then
            return true
        end
    end

    return false
end