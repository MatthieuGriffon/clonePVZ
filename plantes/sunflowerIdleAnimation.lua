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
    self.suns = {}             -- Stocke les soleils lancés
    self.sunLaunchTimer = 0
    self.sunLaunchInterval = 5 -- Lance un soleil toutes les 5 secondes
    local frameWidth = 30
    local frameHeight = 35
    -- Assure-toi que la sprite sheet du Sunflower est correctement découpée

    local startX = 100 -- la position x où commence l'animation dans la sprite sheet
    local startY = 38  -- la position y où commence l'animation dans la sprite sheet

    for i = 0, 5 do    -- Ajuste selon le nombre de frames de l'animation
        table.insert(self.quads,
            love.graphics.newQuad(startX + i * frameWidth, startY, frameWidth, frameHeight,
                self.spriteSheet:getDimensions()))
    end


    return self
end

function SunflowerIdleAnimation:update(dt)
    self.timer = self.timer + dt
    if self.timer >= self.frameRate then
        self.timer = 0
        self.currentFrame = (self.currentFrame % #self.quads) + 1
    end
    -- Mise à jour de l'animation
    self.sunLaunchTimer = self.sunLaunchTimer + dt
    if self.sunLaunchTimer >= self.sunLaunchInterval then
        -- Reset le timer et lance un soleil
        self.sunLaunchTimer = 0
        table.insert(self.suns, Sun.new(self.x + self.frameWidth / 2, self.y))
    end

    -- Met à jour et dessine chaque soleil
    for i, sun in ipairs(self.suns) do
        sun:update(dt)
        if sun.y < 0 then              -- Si le soleil dépasse le haut de l'écran
            table.remove(self.suns, i) -- Le supprime de la liste
        end
    end
end

function SunflowerIdleAnimation:draw()
    if self.spriteSheet and self.quads[self.currentFrame] then
        love.graphics.draw(self.spriteSheet, self.quads[self.currentFrame], self.x, self.y, 0, self.scale, self.scale)
    end
    for i, sun in ipairs(self.suns) do
        sun:draw()
    end
end

-- Classe Sun
Sun = {}
Sun.__index = Sun

-- Crée un nouvel objet Sun
function Sun.new(x, y)
    local self = setmetatable({}, Sun)
    self.x = x
    self.y = y
    self.speed = 50 -- Vitesse de déplacement vers le haut
    self.sprite = love.graphics.newImage('plantes/assets/spriteSheet/Sunflower.png')
    return self
end

-- Met à jour la position du soleil
function Sun:update(dt)
    self.y = self.y - self.speed * dt
end

-- Dessine le soleil
function Sun:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

return SunflowerIdleAnimation
