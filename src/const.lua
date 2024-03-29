HOVER_BOX_SPACING = 8
RIGHT_CLICK_MENU_SPACING = 4
RIGHT_CLICK_MENU_OPTION_HEIGHT = 24

UNFREEZE_KEY_TYPE = "red"
UNERODE_KEY_TYPE = "green"
UNPAINT_KEY_TYPE = "blue"

UNFREEZE_KEY_AMOUNT = 1
UNERODE_KEY_AMOUNT = 5
UNPAINT_KEY_AMOUNT = 3

---@type table<KeyColor, string>
COLOR_NAMES = {
    white = "White",
    orange = "Orange",
    cyan = "Cyan",
    purple = "Purple",
    pink = "Pink",
    black = "Black",
    red = "Red",
    green = "Green",
    blue = "Blue",
    brown = "Brown",
    pure = "Pure",
    master = "Master",
    glitch = "Glitch",
    wild = "Wildcard",
    fire = "Fire",
    ice = "Ice",
    null = "Null",
}

---@type table<KeyType, string>
KEY_TYPE_NAMES = {
    add = "Normal",
    exact = "Exact",
    multiply = "Multiply",
    square = "Square",
    star = "Star",
    unstar = "Unstar"
}

---@type table<KeyType, string>
KEY_TYPE_IMAGES = {
    add = "sprKey",
    exact = "sprKeyAbs",
    multiply = "sprKey",
    square = "sprKeySquare",
    star = "sprKeyStar",
    unstar = "sprKeyStar2",
    auralock = "sprKeyAuraLock", -- This entry in the table is a failsafe.
    auraunlock = "sprKeyAuraUnlock", -- This entry in the table is a failsafe.
}

---@type AuraType[]
AURA_TYPES = {
    "unfreeze",
    "unerode",
    "unpaint",
    "curse",
    "uncurse",
}