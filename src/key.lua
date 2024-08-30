---@class Key : Object
---@field type "key"
---@field color KeyColor
---@field key_type KeyType
---@field active boolean
---@field amount ComplexNumber
---@field reusable boolean
---@field mimic KeyColor?
---@field core_switch boolean?

---@alias KeyType
---| '"add"' # Adds to key count
---| '"exact"' # Sets key count to an exact value
---| '"multiply"' # Multiplies by an arbitrary number (includes signflip and rotor keys)
---| '"star"' # Locks the key count in place
---| '"unstar"' # Unlocks the key count if it has been previously locked with a star key
---| '"square"' # Squares your key count (pain with complex numbers)
---| '"auralock"' # Keeps your auras from changing, even if your keys change to no longer meet aura requirements.
---| '"auraunlock"' # Undoes the effect of an aura lock key.

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
---| '"null"' # Used only for doors (doesn't affect any key count when opened (may change in the future))

-----@type table<KeyColor,ComplexNumber>
--Keys = {}
-----@type table<KeyColor,boolean>
--StarKeys = {}
---@type table<AuraType,boolean>?
AuraLocks = nil

---@class KeyState
---@field count ComplexNumber
---@field star boolean

---@type table<KeyColor,KeyState>
KeyStates = {}

function InitKeys()
    ---@type table<KeyColor,KeyState>
    KeyStates = {}
    for _, color in ipairs(COLOR_LIST) do
        KeyStates[color] = {
            count = CreateComplexNum(),
            star = false,
        }
    end

    AuraLocks = nil
end

---Gets the effective color (the color used for most purposes) from the true color and the mimic status.
---@param color KeyColor
---@param cursed boolean? Only applies to doors (so far).
---@param mimic KeyColor?
---@param core_switch boolean?
---@return KeyColor
function GetEffectiveColor(color, cursed, mimic, core_switch)
    if cursed then
        return "brown"
    end

    if color == "glitch" and mimic then
        return mimic
    end

    if color == "fire" and core_switch then
        return "ice"
    end
    if color == "ice" and core_switch then
        return "fire"
    end

    return color
end

---Collect a key, deactivating it and changing your key count accordingly.
---@param key Key
function CollectKey(key)
    local color = GetEffectiveColor(key.color, nil, key.mimic, key.core_switch)

    if not (KeyStates[color] and KeyStates[color].count) then
        KeyStates[color].count = CreateComplexNum()
    end

    if key.key_type == "add" and not KeyStates[color].star then
        KeyStates[color].count = KeyStates[color].count + key.amount
    end

    if key.key_type == "exact" and not KeyStates[color].star then
        KeyStates[color].count = key.amount
    end

    if key.key_type == "multiply" and not KeyStates[color].star then
        KeyStates[color].count = KeyStates[color].count * key.amount
    end

    if key.key_type == "square" and not KeyStates[color].star then
        KeyStates[color].count = KeyStates[color].count * KeyStates[color].count
    end

    if key.key_type == "star" then
        KeyStates[color].star = true
    end

    if key.key_type == "unstar" then
        KeyStates[color].star = false
    end

    if key.key_type == "auralock" then
        AuraLocks = {}
        for _, aura in ipairs(AURA_TYPES) do
            AuraLocks[aura] = CheckAura(aura)
        end
    end

    if key.key_type == "auraunlock" then
        AuraLocks = nil
    end

    if not key.reusable then
        key.active = false
    end

    if key.color == "fire" or key.color == "ice" then
        SwitchFireIce()
    end
end

---Switch fire and ice for all active non-cursed objects.
function SwitchFireIce()
    for _, obj in ipairs(ObjectList) do
        if obj.type == "door" then
            ---@cast obj Door
            if obj.active and not obj.cursed then
                obj.core_switch = not obj.core_switch
            end
        elseif obj.type == "key" then
            ---@cast obj Key
            if obj.active then
                obj.core_switch = not obj.core_switch
            end
        end
    end
end

---@param obj Key
function DrawKey(obj)
    if not obj.active then
        return
    end

    local key_image_prefix = KEY_TYPE_IMAGES[obj.key_type]

    if obj.key_type == "auralock" or obj.key_type == "auraunlock" then
        love.graphics.setColor(1,1,1,1)
        love.graphics.setShader()

        love.graphics.draw(GetTexture(key_image_prefix .. "_0") --[[@as love.Texture]], obj.x, obj.y)

        return
    end

    --if obj.color == "glitch" then
    --    love.graphics.setColor(1,1,1,1)
    --    love.graphics.setShader(Shaders.static)
    --else
    love.graphics.setColor(Palette[obj.color] or {1,1,1})
    love.graphics.setShader()
    --end
    love.graphics.draw(GetTexture(key_image_prefix .. "_1") --[[@as love.Texture]], obj.x, obj.y)
    love.graphics.setShader()

    if obj.color == "glitch" and obj.mimic and obj.mimic ~= "glitch" then
        love.graphics.setColor(Palette[obj.mimic] or {1,1,1})
        love.graphics.draw(GetTexture(key_image_prefix .. "_4") --[[@as love.Texture]], obj.x, obj.y)
    end

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(GetTexture(key_image_prefix .. "_0") --[[@as love.Texture]], obj.x, obj.y)

    if (not obj.amount or obj.amount == CreateComplexNum(1)) and obj.key_type ~= "multiply" then
        return
    end

    local text = tostring(obj.amount)

    if obj.key_type == "multiply" then
        text = "x" .. text
    end

    love.graphics.setFont(Fonts.default)

    local text_width, text_height = Fonts.default:getWidth(text), Fonts.default:getHeight()

    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", obj.x+KEY_SIZE-1-text_width, obj.y+KEY_SIZE-1-text_height, text_width+2, text_height+2)

    love.graphics.setColor(1,1,1)
    love.graphics.print(text, obj.x+KEY_SIZE-text_width, obj.y+KEY_SIZE-text_height)
end