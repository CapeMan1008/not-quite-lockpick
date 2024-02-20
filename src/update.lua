---@param dt number
function love.update(dt)
    AnimationTimer = AnimationTimer + dt
    
    Palette.wild = {HSVtoRGB(AnimationTimer,1,1)}
end