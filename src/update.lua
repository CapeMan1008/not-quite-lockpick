---@param dt number
function love.update(dt)
    UpdatePlayer(dt)

    AnimationTimer = AnimationTimer + dt

    Palette.wild = {HSVtoRGB(AnimationTimer*12,1,1)}
end