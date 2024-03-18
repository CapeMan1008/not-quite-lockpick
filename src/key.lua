---@class Key : Object
---@field type "key"
---@field color KeyColor
---@field key_type KeyType
---@field active boolean
---@field amount ComplexNumber
---@field reusable boolean
---@field mimic KeyColor?

---@alias KeyType
---| '"add"' # Adds to key count
---| '"exact"' # Sets key count to an exact value
---| '"multiply"' # Multiplies by an arbitrary number (includes signflip and rotor keys)
---| '"star"' # Locks the key count in place
---| '"unstar"' # Unlocks the key count if it has been previously locked with a star key
---| '"square"' # Squares your key count (pain with complex numbers)

---@alias KeyColor
---| '"white"' # White keys
---| '"orange"' # Orange keys
---| '"cyan"' # Cyan keys
---| '"purple"' # Purple keys
---| '"pink"' # Pink keys
---| '"black"' # Black keys
---| '"red"' # Red keys (if you have at least 1, you can unfreeze doors)
---| '"green"' # Green keys (if you have at least 5, you can unerode doors)
---| '"blue"' # Blue keys (if you have at least 3, you can unpaint doors)
---| '"brown"' # Brown keys (curses doors, turning them brown)
---| '"master"' # Master keys (can open any door)
---| '"pure"' # Pure keys (pure keys have no special function, but pure doors are immune to master keys, brown keys, and wildcard keys)
---| '"glitch"' # Glitch keys (change color to the last opened door's color)
---| '"stone"' # Stone keys (no special properties, but the amount you start with is equal to the number of worlds you've cleared)
---| '"wild"' # Wildcard keys (makes up for keys you don't have)
---| '"fire"' # Fire keys (change to ice whenever you pick up a fire or ice key)
---| '"ice"' # Ice keys (change to fire whenever you pick up a fire or ice key)

---@type table<KeyColor,ComplexNumber>
Keys = {}
---@type table<KeyColor,boolean>
StarKeys = {}

function InitKeys()
    Keys.white = CreateComplexNum()
    Keys.orange = CreateComplexNum()
    Keys.cyan = CreateComplexNum()
    Keys.purple = CreateComplexNum()
    Keys.pink = CreateComplexNum()
    Keys.black = CreateComplexNum()
    Keys.red = CreateComplexNum()
    Keys.green = CreateComplexNum()
    Keys.blue = CreateComplexNum()
    Keys.brown = CreateComplexNum()
    Keys.master = CreateComplexNum()
    Keys.pure = CreateComplexNum()
    Keys.glitch = CreateComplexNum()
    Keys.stone = CreateComplexNum()
    Keys.wild = CreateComplexNum()
    Keys.fire = CreateComplexNum()
    Keys.ice = CreateComplexNum()

    StarKeys.white = false
    StarKeys.orange = false
    StarKeys.cyan = false
    StarKeys.purple = false
    StarKeys.pink = false
    StarKeys.black = false
    StarKeys.red = false
    StarKeys.green = false
    StarKeys.blue = false
    StarKeys.brown = false
    StarKeys.master = false
    StarKeys.pure = false
    StarKeys.glitch = false
    StarKeys.stone = false
    StarKeys.wild = false
    StarKeys.fire = false
    StarKeys.ice = false
end

---Gets the effective color (the color used for most purposes) from the true color and the mimic status.
---@param color KeyColor
---@param cursed boolean? Only applies to doors (so far).
---@param mimic KeyColor?
---@return KeyColor
function GetEffectiveColor(color, cursed, mimic)
    if cursed then
        return "brown"
    end

    if color == "glitch" and mimic then
        return mimic
    end

    return color
end

---Collect a key, deactivating it and changing your key count accordingly.
---@param key Key
function CollectKey(key)
    local color = GetEffectiveColor(key.color, nil, key.mimic)

    if key.key_type == "add" and not StarKeys[color] then
        Keys[color] = Keys[color] + key.amount
    end

    if key.key_type == "exact" and not StarKeys[color] then
        Keys[color] = key.amount
    end

    if key.key_type == "multiply" and not StarKeys[color] then
        Keys[color] = Keys[color] * key.amount
    end

    if key.key_type == "square" and not StarKeys[color] then
        Keys[color] = Keys[color] * Keys[color]
    end

    if key.key_type == "star" then
        StarKeys[color] = true
    end

    if key.key_type == "unstar" then
        StarKeys[color] = false
    end

    if not key.reusable then
        key.active = false
    end
end