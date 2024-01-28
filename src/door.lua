---@class Door
---@field x integer The x position of the door.
---@field y integer The y position of the door.
---@field color KeyColor The "spend color" of the door. Used as the color of key to spend.
---@field locks Lock[] The list of locks on the door.
---@field active boolean Only active doors check for collision. Doors are deactivated once all copies have been opened.
---@field negativeborder boolean Determines the appearance of the door's border.
---@field copies ComplexNumber The number of copies this door has.
---@field cursed boolean If this door is cursed or not.
---@field mimic KeyColor? The mimic color for glitched doors or locks (locks use the mimic color of the door they're attached to).

---@class Lock
---@field x integer The x position of the lock relative to the door.
---@field y integer The y position of the lock relative to the door.
---@field width integer The width of the lock.
---@field height integer The height of the lock.
---@field color KeyColor The color of the lock. Determines which keys are required to open the door, but not which key count is changed.
---@field type LockType The lock's type. See LockType for descriptions of the lock types.

---@class NormalLock : Lock
---@field type "normal"
---@field amount ComplexNumber The amount of keys required for the lock to open. Only functions properly if the amount is purely real or purely imaginary.
---@field negative boolean Whether the lock checks if your keys are greater than or less than the amount.

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
---@param use_master boolean If true, checks if you can use a master key on the door before preforming normal checks.
---@param imaginary boolean If true, tries to open an imaginary copy of the door instead of a real copy.
---@param no_open boolean If true, returns a value without opening the door.
---@return boolean can_open If you can open the door.
---@return ComplexNumber? cost The number of keys spent to open the door.
---@return ComplexNumber? wild_cost The number of wildcard keys spent to open the door.
function TryOpenDoor(door, use_master, imaginary, no_open)
    if door.copies == 0 then
        return true
    end

    if door.copies.imaginary == 0 and imaginary then
        return false
    end

    if door.copies.real == 0 and not imaginary then
        return false
    end

    if use_master then
        ---@type boolean
        local master_immune = false

        ---@type KeyColor
        local effective_color = GetEffectiveColor(door.color, door.cursed, door.mimic)

        if effective_color == "master" or effective_color == "pure" then
            master_immune = true
        end

        for _, lock in ipairs(door.locks) do
            ---@type KeyColor
            local lock_color = GetEffectiveColor(lock.color, door.cursed, door.mimic)

            if lock_color == "master" or lock_color == "pure" then
                master_immune = true
                break
            end
        end

        if master_immune then
            return TryOpenDoor(door, false, imaginary, no_open)
        end

        if Keys.master.real > 0 and not imaginary then
            if not no_open then
                Keys.master = Keys.master - CreateComplexNum(1)

                OpenDoor(door, false)
            end

            return true
        end

        if Keys.master.imaginary > 0 and imaginary then
            if not no_open then
                Keys.master = Keys.master - CreateComplexNum(0,1)

                OpenDoor(door, true)
            end

            return true
        end

        if Keys.master.real < 0 and not imaginary then
            if not no_open then
                Keys.master = Keys.master + CreateComplexNum(1)

                CopyDoor(door, false)
            end

            return false
        end

        if Keys.master.imaginary < 0 and imaginary then
            if not no_open then
                Keys.master = Keys.master + CreateComplexNum(0,1)

                CopyDoor(door, true)
            end

            return false
        end
    end

    ---@type ComplexNumber, ComplexNumber
    local cost, wild_cost = CreateComplexNum(), CreateComplexNum()

    for _, lock in ipairs(door.locks) do
        ---@type boolean, ComplexNumber?, ComplexNumber?
        local check, lock_cost, lock_wild_cost = CheckLock(lock, door, imaginary)

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
    local effective_color = GetEffectiveColor(door.color, door.cursed, door.mimic)

    if not Keys[effective_color] then
        Keys[effective_color] = CreateComplexNum()
    end
    if not StarKeys[effective_color] then
        Keys[effective_color] = Keys[effective_color] - cost
    end

    if not Keys.wild then
        Keys.wild = CreateComplexNum()
    end
    if not StarKeys.wild then
        Keys.wild = Keys.wild - wild_cost
    end

    return true, cost, wild_cost
end

---@param lock Lock The lock being checked
---@param parent_door Door The door the lock is on (since the lock doesn't store this itself).
---@param imaginary? boolean Used for imaginary copies of doors.
---@return boolean can_open
---@return ComplexNumber? cost
---@return ComplexNumber? wild_cost
function CheckLock(lock, parent_door, imaginary)
    return false
end

---Opens one copy of a door, without checking any requirements, nor spending any keys. Not to be confused with TryOpenDoor, which does all necessary checks first.
---@param door Door
---@param imaginary boolean
---@param always_deactivate boolean?
---@return boolean deactivated
function OpenDoor(door, imaginary, always_deactivate)
    if always_deactivate then
        door.active = false

        return true
    end

    if imaginary then
        door.copies = door.copies - CreateComplexNum(0,1)
    else
        door.copies = door.copies - CreateComplexNum(1)
    end

    if door.copies == 0 then
        door.active = false

        return true
    end

    return false
end

---Adds one copy to a door, either real or imaginary.
---@param door Door
---@param imaginary boolean
---@return boolean deactivated
function CopyDoor(door, imaginary)
    if imaginary then
        door.copies = door.copies + CreateComplexNum(0,1)
    else
        door.copies = door.copies + CreateComplexNum(1)
    end

    if door.copies == 0 then
        return OpenDoor(door, imaginary, true)
    end

    return false
end