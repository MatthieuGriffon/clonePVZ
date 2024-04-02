local PeashooterIdleAnimation = {}
PeashooterIdleAnimation.__index = PeashooterIdleAnimation
local collisionUtils = require('utils.CollisionUtils')
-- Crée une nouvelle animation de Peashooter
function PeashooterIdleAnimation.new(spriteSheetPath)
    local self = setmetatable({}, PeashooterIdleAnimation)
    self.frameRate = 0.15 -- Ajuste selon l'animation désirée
    self.currentFrame = 1
    self.timer = 0
    self.x = 200
    self.y = 300
    self.frameWidth = 27
    self.frameHeight = 32
    self.scale = 1.8 -- Ajuste selon la taille désirée
    self.spriteSheet = love.graphics.newImage(spriteSheetPath)
    self.quads = {}
    for i = 0, 7 do -- Ajuste selon le nombre de frames de l'animation
        table.insert(self.quads, love.graphics.newQuad(i * self.frameWidth, 0, self.frameWidth, self.frameHeight, self.spriteSheet:getDimensions()))
    end
    self.shootTimer = 0
    self.shootInterval = 2 -- Temps en secondes entre chaque tir
    self.readyToShoot = true
    self.projectiles = {}
    return self
end
function PeashooterIdleAnimation:shouldShoot(zombies)
    local detectionDistance = 700
    local detectionZone = {
        x = 250,
        y = self.y - 50,
        width = detectionDistance,
        height = 80
    }

    for _, zombie in ipairs(zombies) do
            if zombie.x >= detectionZone.x and zombie.x <= (detectionZone.x + detectionZone.width)
            and zombie.y >= detectionZone.y and zombie.y <= (detectionZone.y + detectionZone.height) then
            return true
            end
        end
    return false
end
-- Methode pour dessiner la zone de détection pour le débogage
function PeashooterIdleAnimation:drawDetectionZone()
    local detectionDistance = 700
    local detectionZone = {
        x = 250,
        y = self.y -50,
        width = detectionDistance,
        height = 80
    }

    love.graphics.setColor(1, 0, 0, 0.5)
    love.graphics.rectangle('fill', detectionZone.x, detectionZone.y, detectionZone.width, detectionZone.height)
    love.graphics.setColor(1, 1, 1, 1)
end
-- Méthode pour gérer le tir
function PeashooterIdleAnimation:shoot()
    if self.readyToShoot then
        local pea = Pea.new(self.x, self.y)
        table.insert(self.projectiles, pea)
        self.readyToShoot = true
    end
end
-- Méthode pour mettre à jour l'animation
function PeashooterIdleAnimation:update(dt, zombies)
    self.timer = self.timer + dt
    self.shootTimer = self.shootTimer + dt
    -- Vérifie si le temps écoulé depuis le dernier tir est suffisant
    if self.shootTimer >= self.shootInterval then
        -- Vérifie si un zombie est dans la zone de détection et si la plante est prête à tirer
        if self:shouldShoot(zombies) and self.readyToShoot then
            self:shoot() -- Effectue le tir
            self.shootTimer = 0 -- Réinitialise le timer de tir
            self.readyToShoot = false -- Indique que la plante vient de tirer et doit attendre
        elseif not self.readyToShoot then
            self.readyToShoot = true -- Réinitialise readyToShoot après l'intervalle de tir
        end
    end
    -- Mise à jour de l'animation de la plante
    if self.timer >= self.frameRate then
        self.timer = 0
        self.currentFrame = (self.currentFrame % #self.quads) + 1
    end
    -- Mise à jour de chaque pois tiré
    for i, pea in ipairs(self.projectiles) do
        pea:update(dt)
    end
end
-- Méthode pour dessiner l'animation
function PeashooterIdleAnimation:draw()
    if self.spriteSheet and self.quads[self.currentFrame] then
        love.graphics.draw(self.spriteSheet, self.quads[self.currentFrame], self.x, self.y, 0, self.scale, self.scale)
    end
    for i, pea in ipairs(self.projectiles) do
        pea:draw()
    end
    -- Dessine la zone de détection pour le débogage
    self:drawDetectionZone()
end
-- Classe pour gérer les projectiles (pois)
Pea = {}
Pea.__index = Pea
-- Crée un nouveau pois
function Pea.new(x, y)
    local self = setmetatable({}, Pea)
    self.scale = 1.8
    self.x = x + 25
    self.y = y + 5
    self.width = 10
    self.height = 18
    self.speed = 250
    self.spriteSheet = love.graphics.newImage('plantes/assets/spriteSheet/Peashooter.png')
    self.quad = love.graphics.newQuad(77, 41, self.width, self.height, self.spriteSheet:getDimensions()) -- 
    return self
end
-- Retourne la boîte englobante du pois
function Pea:getBoundingBox()
    return self.x, self.y, self.width * self.scale, self.height * self.scale
end
-- Update le pois
function Pea:update(dt)
    self.x = self.x + self.speed * dt
end
-- Dessine le pois
function Pea:draw()
    love.graphics.draw(self.spriteSheet, self.quad, self.x, self.y, 0, self.scale, self.scale)
    -- Dessine la boîte englobante pour le débogage
    local bx, by, bw, bh = self:getBoundingBox()
    love.graphics.setColor(1, 0, 0) -- Couleur rouge pour la boîte englobante
    love.graphics.rectangle('line', bx, by, bw, bh)
    love.graphics.setColor(1, 1, 1) -- Réinitialise la couleur à blanc

end
-- Met à jour la position du pois et vérifie les collisions
function PeashooterIdleAnimation:updateProjectiles(dt, zombies)
    local screenRightEdge = love.graphics.getWidth()-400

    for i = #self.projectiles, 1, -1 do
        local pea = self.projectiles[i]
        pea:update(dt)

        if pea.x > screenRightEdge then
            table.remove(self.projectiles, i) -- Supprime le projectile s'il sort de l'écran
        end
        for j, zombie in ipairs(zombies) do
            local px, py, pw, ph = pea:getBoundingBox()
            local zx, zy, zw, zh = zombie:getBoundingBox()

            if collisionUtils.checkBoxCollision(px, py, pw, ph, zx, zy, zw, zh) then
                -- Collision détectée, traite ici
                zombie.hp = zombie.hp - 1
                if zombie.hp <= 0 then
                    table.remove(zombies, j) -- Supprime le zombie s'il n'a plus de vie
                end
                table.remove(self.projectiles, i) -- Supprime le projectile
                break -- Sort de la boucle car le projectile ne peut toucher qu'un zombie
            end
        end
    end
end
return PeashooterIdleAnimation