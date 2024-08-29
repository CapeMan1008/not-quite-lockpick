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
    PlayerWalk(dt)

    Player.y = Player.y + Player.velY * dt
    Player.velY = Player.velY + PLAYER_GRAVITY * dt
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

    if IsControlDown("run") then
        walkSpeed = PLAYER_RUN_SPEED
    end
    if IsControlDown("slow_walk") then
        walkSpeed = PLAYER_SLOW_WALK_SPEED
    end

    Player.x = Player.x + walkDir * walkSpeed * dt
end

---@param key love.KeyConstant
function love.keypressed(key)
    if DoesControlHaveKey("jump", key) then
        Player.velY = PLAYER_JUMP_SPEED
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