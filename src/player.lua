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
}

function DrawPlayer()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", Player.x, Player.y, PLAYER_WIDTH, PLAYER_HEIGHT)
end

---@param dt number
function UpdatePlayer(dt)
    Player.coyoteTime = Player.coyoteTime - dt

    PlayerWalk(dt)

    PlayerMoveY(dt)

    Player.velY = Player.velY + PLAYER_GRAVITY * dt

    PlayerInteractObjects()
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
    for _, obj in ipairs(ObjectList) do
        if IsObjectSolid(obj) then
            ---@cast obj RectObject
            local checkX = Player.x + PLAYER_WIDTH
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
    for _, obj in ipairs(ObjectList) do
        if IsObjectSolid(obj) then
            ---@cast obj RectObject
            local checkY = Player.y + PLAYER_HEIGHT
            local collision = true
            collision = collision and checkY > obj.y
            collision = collision and checkY <= obj.y + obj.height
            collision = collision and Player.x + PLAYER_WIDTH > obj.x
            collision = collision and Player.x < obj.x + obj.width

            if collision then
                Player.y = obj.y - PLAYER_HEIGHT
                Player.velY = 0
                Player.coyoteTime = PLAYER_MAX_COYOTE_TIME
                Player.jumps = PLAYER_MIDAIR_JUMP_COUNT
            end
        end
    end
end

---Check for collision upwards, pushing the player down on collision.
function PlayerCollideUp()
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
            TryOpenDoor(obj, false, false, false)
        end
    end
end

---@param key love.KeyConstant
function love.keypressed(key)
    if DoesControlHaveKey("jump", key) then
        if Player.coyoteTime > 0 then
            Player.velY = PLAYER_JUMP_SPEED
            return
        end

        if Player.jumps <= 0 then
            return
        end

        Player.velY = PLAYER_AIR_JUMP_SPEED
        Player.coyoteTime = 0
        Player.jumps = Player.jumps - 1
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