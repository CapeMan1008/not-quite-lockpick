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
    unstar = "Unstar",
    auralock = "Aura Lock",
    auraunlock = "Aura Unlock",
}

---@type table<KeyType, string>
KEY_TYPE_IMAGES = {
    add = "sprKey",
    exact = "sprKeyAbs",
    multiply = "sprKey",
    square = "sprKeySquare",
    star = "sprKeyStar",
    unstar = "sprKeyStar2",
    auralock = "sprKeyAuraLock",
    auraunlock = "sprKeyAuraUnlock",
}

---@type table<KeyType, boolean>
KEY_TYPE_AMOUNT_DISPLAY = {
    add = true,
    exact = true,
    multiply = true,
    square = false,
    star = false,
    unstar = false,
    auralock = false,
    auraunlock = false,
}

---@type AuraType[]
AURA_TYPES = {
    "unfreeze",
    "unerode",
    "unpaint",
    "curse",
    "uncurse",
}

---@type table<AuraType, string>
AURA_IMAGES = {
    unfreeze = "sprAura_0",
    unerode = "sprAura_1",
    unpaint = "sprAura_2",
    curse = "sprBrownAura_0", -- Hardcoded to use a subtractive blend mode.
    uncurse = "sprBrownAura_0",
}