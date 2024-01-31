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

---@type ObjectType[]
ObjectList = {}