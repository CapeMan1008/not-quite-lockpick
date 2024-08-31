---@class Player
---@field x number
---@field y number
---@field velY number
---@field jumps integer
---@field coyoteTime number
Player = {
    x = 0,
    y = 0,
    velY = 0,
    jumps = 0,
    coyoteTime = 0,
    useMaster = false,
}

function InitPlayer()
    Player.x = 0
    Player.y = 0
    Player.velY = 0
    Player.jumps = 0
    Player.coyoteTime = 0
    Player.useMaster = false
end

function DrawPlayer()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", Player.x, Player.y, PLAYER_WIDTH, PLAYER_HEIGHT)

    if Player.useMaster then
        love.graphics.setColor(1,1,1,0.5)

        local masterTexture = GetTexture("sprKMaster_0") --[[@as love.Texture]]

        local masterX, masterY = Player.x + PLAYER_WIDTH / 2 - masterTexture:getWidth() / 2, Player.y + PLAYER_HEIGHT / 2  - masterTexture:getHeight() / 2
    
        love.graphics.draw(masterTexture, masterX, masterY)
    end
end

---@param dt number
function UpdatePlayer(dt)
    Player.coyoteTime = Player.coyoteTime - dt

    PlayerWalk(dt)

    PlayerMoveY(dt)

    Player.velY = Player.velY + PLAYER_GRAVITY * dt

    PlayerInteractObjects()

    if Player.y > 2000 then
        InitPlayer()
    end
end

---@param dt number
function PlayerMoveY(dt)
    Player.y = Player.y + Player.velY * dt

    if Player.velY >= 0 then
        PlayerCollideDown()
    end
    if Player.velY < 0 then
        PlayerCollideUp()
    end
end

---@param dt number
function PlayerWalk(dt)
    local walkDir = 0

    if IsControlDown("right") then
        walkDir = walkDir + 1
    end
    if IsControlDown("left") then
        walkDir = walkDir - 1
    end

    local walkSpeed = PLAYER_WALK_SPEED

    if Player.coyoteTime > 0 and IsControlDown("run") then
        walkSpeed = PLAYER_RUN_SPEED
    end
    if IsControlDown("slow_walk") then
        walkSpeed = PLAYER_SLOW_WALK_SPEED
    end

    Player.x = Player.x + walkDir * walkSpeed * dt

    if walkDir > 0 then
        PlayerCollideRight()
    end
    if walkDir < 0 then
        PlayerCollideLeft()
    end
end

---Check for collision to the right, pushing the player to the left on collision.
function PlayerCollideRight()
    local checkX = Player.x + PLAYER_WIDTH

    ---@param x integer
    ---@param y integer
    ---@return integer?
    ---@nodiscard
    local function PixelToTileIdFixBias(x,y)
        if y % TILE_SIZE == 0 then
            return nil
        end
        local tx = math.floor(x / TILE_SIZE)
        local ty = math.floor(y / TILE_SIZE)
        return TileCoordsToId(tx,ty)
    end

    local tileCollision = false
    local tile1 = PixelToTileIdFixBias(checkX, Player.y)
    local tile2 = PixelToTileIdFixBias(checkX, Player.y + PLAYER_HEIGHT)
    if tile1 then
        tileCollision = tileCollision or IsTileSolid(tile1)
    end
    if tile2 then
        tileCollision = tileCollision or IsTileSolid(tile2)
    end

    if tileCollision then
        Player.x = RoundPixelCoordsToTile(checkX) - PLAYER_WIDTH
    end

    for _, obj in ipairs(ObjectList) do
        if IsObjectSolid(obj) then
            ---@cast obj RectObject
            local collision = true
            collision = collision and checkX > obj.x
            collision = collision and checkX <= obj.x + obj.width
            collision = collision and Player.y + PLAYER_HEIGHT > obj.y
            collision = collision and Player.y < obj.y + obj.height

            if collision then
                Player.x = obj.x - PLAYER_WIDTH
            end
        end
    end
end

---Check for collision to the left, pushing the player to the right on collision.
function PlayerCollideLeft()
    ---@param x integer
    ---@param y integer
    ---@return integer?
    ---@nodiscard
    local function PixelToTileIdFixBias(x,y)
        if y % TILE_SIZE == 0 then
            return nil
        end
        local tx = math.ceil(x / TILE_SIZE - 1)
        local ty = math.floor(y / TILE_SIZE)
        return TileCoordsToId(tx,ty)
    end

    local tileCollision = false
    local tile1 = PixelToTileIdFixBias(Player.x, Player.y)
    local tile2 = PixelToTileIdFixBias(Player.x, Player.y + PLAYER_HEIGHT)
    if tile1 then
        tileCollision = tileCollision or IsTileSolid(tile1)
    end
    if tile2 then
        tileCollision = tileCollision or IsTileSolid(tile2)
    end

    if tileCollision then
        Player.x = RoundPixelCoordsToTile(Player.x) + TILE_SIZE
    end

    for _, obj in ipairs(ObjectList) do
        if IsObjectSolid(obj) then
            ---@cast obj RectObject
            local collision = true
            collision = collision and Player.x >= obj.x
            collision = collision and Player.x < obj.x + obj.width
            collision = collision and Player.y + PLAYER_HEIGHT > obj.y
            collision = collision and Player.y < obj.y + obj.height

            if collision then
                Player.x = obj.x + obj.width
            end
        end
    end
end

---Check for collision downwards, pushing the player up on collision.
function PlayerCollideDown()
    local checkY = Player.y + PLAYER_HEIGHT

    ---@param x integer
    ---@param y integer
    ---@return integer?
    ---@nodiscard
    local function PixelToTileIdFixBias(x,y)
        if x % TILE_SIZE == 0 then
            return nil
        end
        local tx = math.floor(x / TILE_SIZE)
        local ty = math.floor(y / TILE_SIZE)
        return TileCoordsToId(tx,ty)
    end

    local tileCollision = false
    local tile1 = PixelToTileIdFixBias(Player.x, checkY)
    local tile2 = PixelToTileIdFixBias(Player.x + PLAYER_WIDTH, checkY)
    if tile1 then
        tileCollision = tileCollision or IsTileSolid(tile1)
    end
    if tile2 then
        tileCollision = tileCollision or IsTileSolid(tile2)
    end

    if tileCollision then
        Player.y = RoundPixelCoordsToTile(checkY) - PLAYER_HEIGHT
        Player.velY = 0
        PlayerLand()
    end

    for _, obj in ipairs(ObjectList) do
        if IsObjectSolid(obj) then
            ---@cast obj RectObject
            local collision = true
            collision = collision and checkY > obj.y
            collision = collision and checkY <= obj.y + obj.height
            collision = collision and Player.x + PLAYER_WIDTH > obj.x
            collision = collision and Player.x < obj.x + obj.width

            if collision then
                Player.y = obj.y - PLAYER_HEIGHT
                Player.velY = 0
                PlayerLand()
            end
        end
    end
end

---Check for collision upwards, pushing the player down on collision.
function PlayerCollideUp()
    ---@param x integer
    ---@param y integer
    ---@return integer?
    ---@nodiscard
    local function PixelToTileIdFixBias(x,y)
        if x % TILE_SIZE == 0 then
            return nil
        end
        local tx = math.floor(x / TILE_SIZE)
        local ty = math.ceil(y / TILE_SIZE - 1)
        return TileCoordsToId(tx,ty)
    end

    local tileCollision = false
    local tile1 = PixelToTileIdFixBias(Player.x, Player.y)
    local tile2 = PixelToTileIdFixBias(Player.x + PLAYER_WIDTH, Player.y)
    if tile1 then
        tileCollision = tileCollision or IsTileSolid(tile1)
    end
    if tile2 then
        tileCollision = tileCollision or IsTileSolid(tile2)
    end

    if tileCollision then
        Player.y = RoundPixelCoordsToTile(Player.y) + TILE_SIZE
        Player.velY = 0
    end

    for _, obj in ipairs(ObjectList) do
        if IsObjectSolid(obj) then
            ---@cast obj RectObject
            local collision = true
            collision = collision and Player.y >= obj.y
            collision = collision and Player.y <= obj.y + obj.height
            collision = collision and Player.x + PLAYER_WIDTH > obj.x
            collision = collision and Player.x < obj.x + obj.width

            if collision then
                Player.y = obj.y + obj.height
                Player.velY = 0
            end
        end
    end
end

---Reset jumps and coyote time.
function PlayerLand()
    Player.coyoteTime = PLAYER_MAX_COYOTE_TIME
    Player.jumps = PLAYER_MIDAIR_JUMP_COUNT
end

---Collect keys and open doors that the player is touching.
function PlayerInteractObjects()
    for _, obj in ipairs(ObjectList) do
        PlayerTryInteractObject(obj)
    end
end

---Check if player is touching a key or door and do the appropriate action.
---@param obj Object
function PlayerTryInteractObject(obj)
    if obj.type == "key" then
        ---@cast obj Key

        if not obj.active then
            return
        end

        local collision = true
        collision = collision and Player.x + PLAYER_WIDTH >= obj.x
        collision = collision and Player.x <= obj.x + KEY_SIZE
        collision = collision and Player.y + PLAYER_HEIGHT >= obj.y
        collision = collision and Player.y <= obj.y + KEY_SIZE

        if not collision then
            return
        end

        CollectKey(obj)
    end

    if obj.type == "door" then
        ---@cast obj Door

        if not obj.active then
            return
        end

        local centerX, centerY = Player.x + PLAYER_WIDTH/2, Player.y + PLAYER_HEIGHT/2
        local inAura = true
        inAura = inAura and centerX + PLAYER_AURA_RADIUS >= obj.x
        inAura = inAura and centerX - PLAYER_AURA_RADIUS <= obj.x + obj.width
        inAura = inAura and centerY + PLAYER_AURA_RADIUS >= obj.y
        inAura = inAura and centerY - PLAYER_AURA_RADIUS <= obj.y + obj.height

        if inAura then
            TryAurasOnDoor(obj)
        end

        local collision = true
        collision = collision and Player.x + PLAYER_WIDTH >= obj.x
        collision = collision and Player.x <= obj.x + obj.width
        collision = collision and Player.y + PLAYER_HEIGHT >= obj.y
        collision = collision and Player.y <= obj.y + obj.height

        if collision then
            local opened = TryOpenDoor(obj, Player.useMaster, false, false)

            if opened and Player.useMaster then
                Player.useMaster = false
            end
        end
    end
end

---@param key love.KeyConstant
function love.keypressed(key)
    if DoesControlHaveKey("jump", key) then
        if Player.coyoteTime > 0 then
            Player.velY = PLAYER_JUMP_SPEED
            Player.coyoteTime = 0
            return
        end

        if Player.jumps <= 0 then
            return
        end

        Player.velY = PLAYER_AIR_JUMP_SPEED
        Player.jumps = Player.jumps - 1
        Player.coyoteTime = 0
    end

    if DoesControlHaveKey("action", key) then
        if KeyStates.master.count == CreateComplexNum() then
            Player.useMaster = false
            return
        end

        Player.useMaster = not Player.useMaster
    end
end

---@param key love.KeyConstant
function love.keyreleased(key)
    if DoesControlHaveKey("jump", key) then
        if Player.velY < PLAYER_JUMP_CANCEL_SPEED then
            Player.velY = PLAYER_JUMP_CANCEL_SPEED
        end
    end
end