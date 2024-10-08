---@class Object
---@field type ObjectType
---@field x integer
---@field y integer

---@class RectObject : Object
---@field width integer
---@field height integer

---@alias ObjectType
---| '"door"'
---| '"key"'
---| '"keyhandle"'

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
        DrawDoor(object)
    elseif object.type == "key" then
        ---@cast object Key
        DrawKey(object)
    elseif object.type == "keyhandle" then
        ---@cast object KeyHandle
        DrawKeyHandle(object)
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
        x <= obj.x+KEY_SIZE and
        y >= obj.y and
        y <= obj.y+KEY_SIZE then
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

---Gets if an object is solid.
---@param obj Object
---@return boolean
---@nodiscard
function IsObjectSolid(obj)
    if obj.type == "door" then
        ---@cast obj Door
        return obj.active
    end

    return false
end