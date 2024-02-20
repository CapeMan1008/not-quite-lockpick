---@param dt number
function love.update(dt)
    AnimationTimer = AnimationTimer + dt

    Palette.wild = {HSVtoRGB(AnimationTimer*12,1,1)}
end