HOVER_BOX_SPACING = 8
RIGHT_CLICK_MENU_SPACING = 4
RIGHT_CLICK_MENU_OPTION_HEIGHT = 24

KEY_HANDLE_SPACING = 32
KEY_HANDLE_MARGIN = 16
KEY_HANDLE_TEXT_OFFSET = 64
KEY_HANDLE_TEXT_HEIGHT = 32
KEY_HANDLE_STAR_OFFSET_X = 46
KEY_HANDLE_STAR_OFFSET_Y = 48
KEY_HANDLE_STAR_SCALE = 0.4

UNFREEZE_KEY_TYPE = "red"
UNERODE_KEY_TYPE = "green"
UNPAINT_KEY_TYPE = "blue"

UNFREEZE_KEY_AMOUNT = 1
UNERODE_KEY_AMOUNT = 5
UNPAINT_KEY_AMOUNT = 3

PLAYER_WIDTH = 14
PLAYER_HEIGHT = 22
PLAYER_GRAVITY = 1830
PLAYER_JUMP_SPEED = -540
PLAYER_AIR_JUMP_SPEED = -480
PLAYER_JUMP_CANCEL_SPEED = -200
PLAYER_WALK_SPEED = 180
PLAYER_RUN_SPEED = 360
PLAYER_SLOW_WALK_SPEED = 60
PLAYER_MAX_COYOTE_TIME = 0.1
PLAYER_MIDAIR_JUMP_COUNT = 1 -- Number of doublejumps the player has.
PLAYER_AURA_RADIUS = 32 -- Actually a square

KEY_SIZE = 32

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

--- List of all colors (excluding null, as it's the lack of a color) to reduce redundancy.
---@type KeyColor[]
COLOR_LIST = {
    "white",
    "orange",
    "cyan",
    "purple",
    "pink",
    "black",
    "red",
    "green",
    "blue",
    "brown",
    "pure",
    "master",
    "glitch",
    "wild",
    "fire",
    "ice",
    "null",
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