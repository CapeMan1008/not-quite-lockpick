---@class Door : Object
---@field type "door"
---@field width integer The width of the door.
---@field height integer The height of the door.
---@field color KeyColor The "spend color" of the door. Used as the color of key to spend.
---@field locks Lock[] The list of locks on the door.
---@field active boolean Only active doors check for collision. Doors are deactivated once all copies have been opened.
---@field negativeborder boolean Determines the appearance of the door's border.
---@field copies ComplexNumber The number of copies this door has.
---@field cursed boolean If this door is cursed or not.
---@field frozen boolean If this door is frozen or not.
---@field eroded boolean If this door is eroded or not.
---@field painted boolean If this door is painted or not.
---@field mimic KeyColor? The mimic color for glitched doors or locks (locks use the mimic color of the door they're attached to).
---@field core_switch boolean? Whether fire and ice are switched or not.

---@class Lock
---@field x integer The x position of the lock relative to the door.
---@field y integer The y position of the lock relative to the door.
---@field width integer The width of the lock.
---@field height integer The height of the lock.
---@field color KeyColor The color of the lock. Determines which keys are required to open the door, but not which key count is changed.
---@field type LockType The lock's type. See LockType for descriptions of the lock types.

---@class NormalLock : Lock
---@field type "normal"
---@field amount ComplexNumber The amount of keys required for the lock to open.
---@field negative boolean Whether the lock checks if your keys are greater than or less than the real amount.
---@field imaginary_negative boolean Whether the lock checks if your keys are greater than or less than the imaginary amount.

---@class BlankLock : Lock
---@field type "blank"

---@class BlastLock : Lock
---@field type "blast"
---@field negative boolean Whether the lock checks if your keys are greater than or less than 0.
---@field imaginary boolean  Whether the lock checks your real or imaginary keys.

---@class AllLock : Lock
---@field type "all"

---@alias LockType
---| '"normal"' # Normal lock, requires at least the specified amount of keys and adds that many to the cost of the door.
---| '"blank"' # Requires exactly 0 keys and doesn't affect cost.
---| '"blast"' # Requires any amount of keys greater than 0, and adds all keys of the lock color to the cost.
---| '"all"' # Like blast locks, but works with any non-zero key amount.

--- Tries to open a door, while checking if you meet the requirements.
---@param door Door The door to try opening.
---@param use_master boolean? If true, checks if you can use a master key on the door before preforming normal checks.
---@param imaginary boolean? If true, tries to open an imaginary copy of the door instead of a real copy.
---@param no_open boolean? If true, returns a value without opening the door.
---@return boolean can_open If you can open the door.
---@return ComplexNumber? cost The number of keys spent to open the door.
---@return ComplexNumber? wild_cost The number of wildcard keys spent to open the door.
function TryOpenDoor(door, use_master, imaginary, no_open)
    if door.frozen or door.eroded or door.painted then
        return false
    end

    if door.copies == CreateComplexNum() then
        if not no_open then
            OpenDoor(door, imaginary, nil, nil, true)
        end

        return true
    end

    local negative = false

    if imaginary then
        negative = door.copies.imaginary < 0
    else
        negative = door.copies.real < 0
    end

    if use_master then
        return CheckMasterKey(door, imaginary, no_open)
    end

    if door.copies.imaginary == 0 and imaginary then
        return false
    end

    if door.copies.real == 0 and not imaginary then
        return false
    end

    ---@type ComplexNumber, ComplexNumber
    local cost, wild_cost = CreateComplexNum(), CreateComplexNum()

    for _, lock in ipairs(door.locks) do
        ---@type boolean, ComplexNumber?, ComplexNumber?
        local check, lock_cost, lock_wild_cost = CheckLock(lock, door, imaginary, negative)

        if not check then
            return false
        end

        if lock_cost then
            cost = cost + lock_cost
        end
        if lock_wild_cost then
            wild_cost = wild_cost + lock_wild_cost
        end
    end

    if no_open then
        return true, cost, wild_cost
    end

    ---@type KeyColor
    local effective_color = GetEffectiveColor(door.color, door.cursed, door.mimic, door.core_switch)

    if not (KeyStates[effective_color].count or effective_color == "null") then
        KeyStates[effective_color].count = CreateComplexNum()
    end
    if not (KeyStates[effective_color].star or effective_color == "null") then
        KeyStates[effective_color].count = KeyStates[effective_color].count - cost
    end

    if not KeyStates.wild.count then
        KeyStates.wild.count = CreateComplexNum()
    end
    if not KeyStates.wild.star then
        KeyStates.wild.count = KeyStates.wild.count - wild_cost
    end

    OpenDoor(door, imaginary, negative)

    return true, cost, wild_cost
end

---@param door Door The door to try opening.
---@param imaginary boolean? If true, tries to open an imaginary copy of the door instead of a real copy.
---@param no_open boolean? If true, returns a value without opening the door.
---@return boolean can_open If you can open the door.
function CheckMasterKey(door, imaginary, no_open)
    ---@type boolean
    local master_immune = DoesDoorHaveColor(door, "pure") or DoesDoorHaveColor(door, "master")

    if master_immune then
        return false
    end

    if KeyStates.master.count.real > 0 and not imaginary then
        if not no_open then
            if not KeyStates.master.star then
                KeyStates.master.count = KeyStates.master.count - CreateComplexNum(1)
            end

            if door.copies.real <= 0 then
                CopyDoor(door, false, true)
            else
                OpenDoor(door, false, false, true)
            end
        end

        return true
    elseif KeyStates.master.count.imaginary > 0 and imaginary then
        if not no_open then
            if not KeyStates.master.star then
                KeyStates.master.count = KeyStates.master.count - CreateComplexNum(0,1)
            end

            if door.copies.imaginary <= 0 then
                CopyDoor(door, true, true)
            else
                OpenDoor(door, true, false, true)
            end
        end

        return true
    elseif KeyStates.master.count.real < 0 and not imaginary then
        if not no_open then
            if not KeyStates.master.star then
                KeyStates.master.count = KeyStates.master.count + CreateComplexNum(1)
            end

            if door.copies.real < 0 then
                OpenDoor(door, false, true, true)
            else
                CopyDoor(door, false, false)
            end
        end

        return false
    elseif KeyStates.master.count.imaginary < 0 and imaginary then
        if not no_open then
            if not KeyStates.master.star then
                KeyStates.master.count = KeyStates.master.count + CreateComplexNum(0,1)
            end

            if door.copies.imaginary < 0 then
                OpenDoor(door, true, true, true)
            else
                CopyDoor(door, true, false)
            end
        end

        return false
    end

    return false
end

---Returns if a lock is openable, as well as how many keys it would cost to open.
---@param lock Lock The lock being checked.
---@param parent_door Door The door the lock is on (since the lock doesn't store this itself).
---@param imaginary? boolean If this door copy is imaginary.
---@param negative? boolean If this door copy is negative.
---@return boolean can_open
---@return ComplexNumber? cost
---@return ComplexNumber? wild_cost
function CheckLock(lock, parent_door, imaginary, negative)
    if lock.type == "normal" then
        ---@cast lock NormalLock
        return CheckNormalLock(lock, parent_door, imaginary, negative)
    elseif lock.type == "blank" then
        ---@cast lock BlankLock
        return CheckBlankLock(lock, parent_door)
    elseif lock.type == "blast" then
        ---@cast lock BlastLock
        return CheckBlastLock(lock, parent_door, imaginary, negative)
    elseif lock.type == "all" then
        ---@cast lock AllLock
        return CheckAllLock(lock, parent_door)
    end

    return false
end

---Returns if a normal lock is openable, as well as how many keys it would cost to open.
---@param lock NormalLock The lock being checked.
---@param parent_door Door The door the lock is on (since the lock doesn't store this itself).
---@param imaginary? boolean If this door copy is imaginary.
---@param negative? boolean If this door copy is negative.
---@return boolean can_open
---@return ComplexNumber? cost
---@return ComplexNumber? wild_cost
function CheckNormalLock(lock, parent_door, imaginary, negative)
    if imaginary or negative then
        return CheckNormalLock(CreateNonPositiveRealNormalLock(lock, imaginary, negative), parent_door, false, false)
    end

    ---@type KeyColor
    local required_color = GetEffectiveColor(lock.color, parent_door.cursed, parent_door.mimic, parent_door.core_switch)

    if required_color == "null" then
        return true, lock.amount, CreateComplexNum()
    end

    ---@type boolean
    local check_real, check_imaginary = true,true

    if lock.amount.real == 0 then
        check_real = false
    end
    if lock.amount.imaginary == 0 then
        check_imaginary = false
    end

    ---@type boolean
    local can_open = true
    ---@type ComplexNumber
    local cost, wild_cost = CreateComplexNum(), CreateComplexNum()

    if check_real then
        if lock.negative then
            if KeyStates[required_color].count.real <= lock.amount.real then
                cost = cost + lock.amount.real
            elseif not DoesDoorHaveColor(parent_door, "wild") and not DoesDoorHaveColor(parent_door, "pure") and KeyStates[required_color].count.real + KeyStates.wild.count.real <= lock.amount.real then
                cost = cost + CreateComplexNum(KeyStates[required_color].count.real)
                wild_cost = wild_cost + CreateComplexNum(lock.amount.real) - CreateComplexNum(KeyStates[required_color].count.real)
            else
                can_open = false
            end
        else
            if KeyStates[required_color].count.real >= lock.amount.real then
                cost = cost + lock.amount.real
            elseif not DoesDoorHaveColor(parent_door, "wild") and not DoesDoorHaveColor(parent_door, "pure") and KeyStates[required_color].count.real + KeyStates.wild.count.real >= lock.amount.real then
                cost = cost + CreateComplexNum(KeyStates[required_color].count.real)
                wild_cost = wild_cost + CreateComplexNum(lock.amount.real) - CreateComplexNum(KeyStates[required_color].count.real)
            else
                can_open = false
            end
        end
    end

    if check_imaginary then
        if lock.imaginary_negative then
            if KeyStates[required_color].count.imaginary <= lock.amount.imaginary then
                cost = cost + lock.amount.imaginary
            elseif not DoesDoorHaveColor(parent_door, "wild") and not DoesDoorHaveColor(parent_door, "pure") and KeyStates[required_color].count.imaginary + KeyStates.wild.count.imaginary <= lock.amount.imaginary then
                cost = cost + CreateComplexNum(KeyStates[required_color].count.imaginary)
                wild_cost = wild_cost + CreateComplexNum(lock.amount.imaginary) - CreateComplexNum(KeyStates[required_color].count.imaginary)
            else
                can_open = false
            end
        else
            if KeyStates[required_color].count.imaginary >= lock.amount.imaginary then
                cost = cost + lock.amount.imaginary
            elseif not DoesDoorHaveColor(parent_door, "wild") and not DoesDoorHaveColor(parent_door, "pure") and KeyStates[required_color].count.imaginary + KeyStates.wild.count.imaginary >= lock.amount.imaginary then
                cost = cost + CreateComplexNum(KeyStates[required_color].count.imaginary)
                wild_cost = wild_cost + CreateComplexNum(lock.amount.imaginary) - CreateComplexNum(KeyStates[required_color].count.imaginary)
            else
                can_open = false
            end
        end
    end

    if can_open then
        return true, cost, wild_cost
    end

    return false
end

---Returns if a black lock is openable.
---@param lock BlankLock The lock being checked.
---@param parent_door Door The door the lock is on (since the lock doesn't store this itself).
---@return boolean can_open
function CheckBlankLock(lock, parent_door)
    local effective_color = GetEffectiveColor(lock.color, parent_door.cursed, parent_door.mimic, parent_door.core_switch)

    if effective_color == "null" then
        return true
    end

    return KeyStates[effective_color].count == CreateComplexNum()
end

---Returns if a blast lock is openable, as well as how many keys it would cost to open.
---@param lock BlastLock The lock being checked.
---@param parent_door Door The door the lock is on (since the lock doesn't store this itself).
---@param imaginary? boolean If this door copy is imaginary.
---@param negative? boolean If this door copy is negative.
---@return boolean can_open
---@return ComplexNumber? cost
function CheckBlastLock(lock, parent_door, imaginary, negative)
    ---@type boolean
    local check_imaginary, check_negative = lock.imaginary, lock.negative

    if imaginary then
        check_imaginary = not lock.imaginary
        check_negative = (lock.imaginary and not lock.negative) or (not lock.imaginary and lock.negative)
    end

    if negative then
        check_negative = not check_negative
    end

    ---@type KeyColor
    local required_color = GetEffectiveColor(lock.color, parent_door.cursed, parent_door.mimic, parent_door.core_switch)

    if not check_imaginary and not check_negative then
        if KeyStates[required_color].count.real > 0 then
            return true, CreateComplexNum(KeyStates[required_color].count.real)
        end
    end

    if not check_imaginary and check_negative then
        if KeyStates[required_color].count.real < 0 then
            return true, CreateComplexNum(KeyStates[required_color].count.real)
        end
    end

    if check_imaginary and not check_negative then
        if KeyStates[required_color].count.imaginary > 0 then
            return true, CreateComplexNum(0,KeyStates[required_color].count.imaginary)
        end
    end

    if check_imaginary and check_negative then
        if KeyStates[required_color].count.imaginary < 0 then
            return true, CreateComplexNum(0,KeyStates[required_color].count.imaginary)
        end
    end

    return false
end

---Returns if a blast lock is openable, as well as how many keys it would cost to open.
---@param lock AllLock The lock being checked.
---@param parent_door Door The door the lock is on (since the lock doesn't store this itself).
---@return boolean can_open
---@return ComplexNumber? cost
function CheckAllLock(lock, parent_door)
    ---@type KeyColor
    local required_color = GetEffectiveColor(lock.color, parent_door.cursed, parent_door.mimic, parent_door.core_switch)

    if KeyStates[required_color].count ~= CreateComplexNum() then
        return true, KeyStates[required_color].count
    end

    return false
end

---Generates a version of a normal lock that has been multiplied by i, -1, or -i.
---@param lock NormalLock The lock being used as the base for the new lock.
---@param imaginary? boolean If the lock should be multiplied by i.
---@param negative? boolean If the lock should be multiplied by -1.
---@return NormalLock
function CreateNonPositiveRealNormalLock(lock, imaginary, negative)
    ---@type table
    local new_lock = {}

    for k, v in pairs(lock) do
        new_lock[k] = v
    end

    ---@cast new_lock NormalLock
    local new_amount = lock.amount()

    if imaginary then
        new_amount.real = -new_amount.imaginary
        new_amount.imaginary = new_amount.real

        new_lock.negative = not new_lock.imaginary_negative
        new_lock.imaginary_negative = new_lock.negative
    end

    if negative then
        new_amount.real = -new_amount.real
        new_amount.imaginary = -new_amount.imaginary

        new_lock.negative = not new_lock.negative
        new_lock.imaginary_negative = not new_lock.imaginary_negative
    end

    new_lock.amount = new_amount
    return new_lock
end

--[[
---Checks if the door has any pure parts on it.
---@param door Door
---@return boolean
function GetDoorPure(door)
    if GetEffectiveColor(door.color, door.cursed, door.mimic) == "pure" then
        return true
    end

    for _, lock in ipairs(door.locks) do
        ---@type KeyColor
        local lock_color = GetEffectiveColor(lock.color, door.cursed, door.mimic)

        if lock_color == "pure" then
            return true
        end
    end

    return false
end

---Checks if the door has any glitch parts on it, for deciding whether or not to tell the player the door's mimic color.
---@param door Door
---@return boolean
function GetDoorGlitched(door)
    if door.color == "glitch" then
        return true
    end

    for _, lock in ipairs(door.locks) do
        ---@type KeyColor
        local lock_color = lock.color

        if lock_color == "glitch" then
            return true
        end
    end

    return false
end
]]

---Opens one copy of a door, without checking any requirements, nor spending any keys. Not to be confused with TryOpenDoor, which does all necessary checks first.
---@param door Door
---@param imaginary boolean?
---@param negative boolean?
---@param no_mimic boolean?
---@param always_deactivate boolean? Always deactivates the door and sets its copies to 0, no matter how many copies it actually has.
---@return boolean deactivated
function OpenDoor(door, imaginary, negative, no_mimic, always_deactivate)
    local return_val = false

    if always_deactivate then
        door.copies = CreateComplexNum()

        door.active = false

        return_val = true
    else
        local to_subtract = CreateComplexNum(1)

        if imaginary then
            to_subtract = to_subtract * CreateComplexNum(0,1)
        end

        if negative then
            to_subtract = to_subtract * CreateComplexNum(-1)
        end

        door.copies = door.copies - to_subtract

        if door.copies == CreateComplexNum() then
            door.active = false

            return_val = true
        end
    end

    if not no_mimic then
        ChangeAllMimic(GetEffectiveColor(door.color, door.cursed, door.mimic, door.core_switch))
    end

    return return_val
end

---Changes the mimic of all active non-cursed objects.
---@param color KeyColor
function ChangeAllMimic(color)
    for _, obj in ipairs(ObjectList) do
        if obj.type == "door" then
            ---@cast obj Door
            if obj.active and not obj.cursed then
                obj.mimic = color
            end
        elseif obj.type == "key" then
            ---@cast obj Key
            if obj.active then
                obj.mimic = color
            end
        end
    end
end

---Adds one copy to a door, either real or imaginary.
---@param door Door
---@param imaginary boolean?
---@param negative boolean?
---@return boolean deactivated
function CopyDoor(door, imaginary, negative)
    local to_add = CreateComplexNum(1)

    if imaginary then
        to_add = to_add * CreateComplexNum(0,1)
    end

    if negative then
        to_add = to_add * CreateComplexNum(-1)
    end

    door.copies = door.copies + to_add

    if door.copies == CreateComplexNum() then
        return OpenDoor(door, imaginary, negative, true)
    end

    return false
end

---@alias AuraType
---| '"unfreeze"' Frozen doors must be unfrozen with at least 1 red key before being opened.
---| '"unerode"' Eroded doors must be uneroded with at least 5 green keys.
---| '"unpaint"' Painted doors must be unpainted with at least 3 blue keys.
---| '"curse"' If you have more than 0 brown keys, doors are cursed, turning them brown.
---| '"uncurse"' If you have less than 0 brown keys, cursed doors are uncursed.

---Checks if an aura is active, probably not complex enough to put into a function like this.
---@param aura_type AuraType
---@return boolean
---@nodiscard
function CheckAura(aura_type)
    if type(AuraLocks) == "table" and type(AuraLocks[aura_type]) == "boolean" then
        return AuraLocks[aura_type]
    end

    if aura_type == "unfreeze" and KeyStates[UNFREEZE_KEY_TYPE].count.real >= UNFREEZE_KEY_AMOUNT then
        return true
    end
    if aura_type == "unerode" and KeyStates[UNERODE_KEY_TYPE].count.real >= UNERODE_KEY_AMOUNT then
        return true
    end
    if aura_type == "unpaint" and KeyStates[UNPAINT_KEY_TYPE].count.real >= UNPAINT_KEY_AMOUNT then
        return true
    end

    if aura_type == "curse" and KeyStates.brown.count.real > 0 then
        return true
    end

    if aura_type == "uncurse" and KeyStates.brown.count.real < 0 then
        return true
    end

    return false
end

---Tries all auras on the specified door.
---@param door Door
function TryAurasOnDoor(door)
    if door.frozen and CheckAura("unfreeze") then
        door.frozen = false
    end
    if door.eroded and CheckAura("unerode") then
        door.eroded = false
    end
    if door.painted and CheckAura("unpaint") then
        door.painted = false
    end

    if not door.cursed and CheckAura("curse") and not DoesDoorHaveColor(door, "pure") then
        door.cursed = true
    elseif door.cursed and CheckAura("uncurse") then
        door.cursed = false
    end
end

---Returns whether a given door has a given color anywhere on it.
---@param door Door
---@param color KeyColor
---@param use_raw boolean? Whether to ignore curse, glitch, and other color changing effects.
---@return boolean
---@nodiscard
function DoesDoorHaveColor(door, color, use_raw)
    local door_color
    if use_raw then
        door_color = door.color
    else
        door_color = GetEffectiveColor(door.color, door.cursed, door.mimic, door.core_switch)
    end

    if door_color == color then
        return true
    end

    for _, lock in ipairs(door.locks) do
        ---@type KeyColor
        local lock_color
        if use_raw then
            lock_color = lock.color
        else
            lock_color = GetEffectiveColor(lock.color, door.cursed, door.mimic, door.core_switch)
        end

        if lock_color == color then
            return true
        end
    end

    return false
end

---@param obj Door
function DrawDoor(obj)
    if not obj.active then
        return
    end

    local visible_color = obj.color

    if obj.cursed then
        visible_color = "brown"
    end

    love.graphics.setColor(Palette[visible_color] or {1,1,1})
    love.graphics.rectangle("fill", obj.x, obj.y, obj.width, obj.height)

    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line", obj.x+0.5, obj.y+0.5, obj.width-1, obj.height-1)

    for _, lock in ipairs(obj.locks) do
        visible_color = lock.color

        if obj.cursed then
            visible_color = "brown"
        end

        love.graphics.setColor(Palette[visible_color] or {1,1,1})
        love.graphics.rectangle("fill", obj.x+lock.x, obj.y+lock.y, lock.width, lock.height)

        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("line", obj.x+lock.x+0.5, obj.y+lock.y+0.5, lock.width-1, lock.height-1)

        if lock.type == "normal" then
            ---@cast lock NormalLock
            love.graphics.setFont(Fonts.default)

            local text_width, text_height = Fonts.default:getWidth(tostring(lock.amount)), Fonts.default:getHeight()

            love.graphics.print(tostring(lock.amount), obj.x+lock.x+lock.width/2-text_width/2, obj.y+lock.y+lock.height/2-text_height/2)
        end
    end

    if obj.copies ~= CreateComplexNum(1) then
        local text = "x"..tostring(obj.copies)

        love.graphics.setFont(Fonts.default)

        local text_width, text_height = Fonts.default:getWidth(text), Fonts.default:getHeight()

        love.graphics.setColor(1,1,1)

        love.graphics.print(text, obj.x+obj.width/2-text_width/2, obj.y-text_height)
    end
end