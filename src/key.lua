---@class Key
---@field x integer
---@field y integer
---@field color KeyColor
---@field type KeyType
---@field amount ComplexNumber
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
---| '"red"' # Red keys (if you have at least 1, you can unfreeze doors)
---| '"green"' # Green keys (if you have at least 5, you can unerode doors)
---| '"blue"' # Blue keys (if you have at least 3, you can unpaint doors)
---| '"brown"' # Brown keys (curses doors, turning them brown)
---| '"master"' # Master keys (can open any door)
---| '"pure"' # Pure keys (pure keys have no special function, but pure doors are immune to master keys, brown keys, and wildcard keys)
---| '"glitch"' # Glitch keys (change color to the last opened door's color)
---| '"wild"' # Wildcard keys (makes up for keys you don't have)

---@type table<KeyColor,ComplexNumber>
Keys = {}
---@type table<KeyColor,boolean>
StarKeys = {}

---Gets the effective color (the color used for most purposes) from the true color and the mimic status.
---@param color KeyColor
---@param cursed boolean?
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

--- Collect a key, deactivating it and changing your key count accordingly.
---@param key Key
function CollectKey(key)
    
end