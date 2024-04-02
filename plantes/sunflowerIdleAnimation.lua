local SunflowerIdleAnimation = {}
SunflowerIdleAnimation.__index = SunflowerIdleAnimation

function SunflowerIdleAnimation.new(spriteSheetPath)
    local self = setmetatable({}, SunflowerIdleAnimation)
    self.frameRate = 0.15 -- Ajuste selon l'animation désirée
    self.currentFrame = 1
    self.timer = 0
    -- Position fixe pour tester l'animation
    self.x = 200
    self.y = 300
    self.frameWidth = 27
    self.frameHeight = 32
    self.scale = 1.8 -- Ajuste selon la taille désirée
    self.spriteSheet = love.graphics.newImage(spriteSheetPath)
    self.quads = {}
    local frameWidth = 30
    local frameHeight = 35
    -- Assure-toi que la sprite sheet du Sunflower est correctement découpée
    
    local startX = 100 -- la position x où commence l'animation dans la sprite sheet
    local startY = 38 -- la position y où commence l'animation dans la sprite sheet
    
    for i = 0, 5 do -- Ajuste selon le nombre de frames de l'animation
        table.insert(self.quads, love.graphics.newQuad(startX + i * frameWidth, startY, frameWidth, frameHeight, self.spriteSheet:getDimensions()))

    end
    return self
end

function SunflowerIdleAnimation:update(dt)
    self.timer = self.timer + dt
    if self.timer >= self.frameRate then
        self.timer = 0
        self.currentFrame = (self.currentFrame % #self.quads) + 1
    end
end

function SunflowerIdleAnimation:draw()
    if self.spriteSheet and self.quads[self.currentFrame] then
        love.graphics.draw(self.spriteSheet, self.quads[self.currentFrame], self.x, self.y, 0, self.scale, self.scale)
    end
end

return SunflowerIdleAnimation