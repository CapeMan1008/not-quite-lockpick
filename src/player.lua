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
    Player.y = Player.y + Player.velY * dt
    Player.velY = Player.velY + PLAYER_GRAVITY * dt
end