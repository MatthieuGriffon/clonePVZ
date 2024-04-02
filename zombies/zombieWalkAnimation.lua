-- Importe des utilitaires pour des fonctions aléatoires
local randomUtils = require("utils.randomUtils")

-- Définition de la classe ZombieWalk
local ZombieWalk = {}
ZombieWalk.__index = ZombieWalk


-- Constructeur: Crée une nouvelle instance de ZombieWalk
function ZombieWalk.new(spriteSheetPath, startY)
    local self = setmetatable({}, ZombieWalk)
    self.frameRate = 0.15 -- Vitesse de changement entre les frames de l'animation
    self.currentFrame = 1 -- Frame actuelle de l'animation
    self.timer = 0 -- Chronomètre pour le passage à la frame suivante
    self.x = 960 -- Position initiale en X (hors écran à droite)
    self.y = randomUtils.selectRandomY({238, 338, 438, 520, 615}) -- Position en Y choisie aléatoirement parmi les valeurs données
    self.scale = 1.8 -- Facteur d'échelle du sprite
    self.speed = -7.5 -- Vitesse de déplacement vers la gauche
    self.spriteSheet = love.graphics.newImage(spriteSheetPath) -- Charge la sprite sheet du zombie
    self.quads = {} -- Tableau de quads pour l'animation
    self.hp = 5 -- Points de vie du zombie
    self.width = 50 -- Largeur de base du sprite avant ajustement par scale
    self.height = 61 -- Hauteur de base du sprite avant ajustement par scale

-- Initialise les quads pour l'animation en fonction de la sprite sheet
    for i = 0, 6 do
        table.insert(self.quads, love.graphics.newQuad(i * self.width, startY or 0, self.width, self.height, self.spriteSheet:getDimensions()))
    end
    return self
end

-- Calcule la boîte englobante du zombie pour la détection de collision
function ZombieWalk:getBoundingBox()
    local bx = self.x + 18 * self.scale
    local by = self.y + 15 * self.scale - 10
    local bw = 35 * self.scale
    local bh = 40 * self.scale + 10
    return bx, by, bw, bh
end

-- Met à jour la position et l'animation du zombie
function ZombieWalk:update(dt)
    self.timer = self.timer + dt
    if self.timer >= self.frameRate then
        self.timer = 0
        self.currentFrame = (self.currentFrame % #self.quads) + 1
    end
    self.x = self.x + self.speed * dt -- Déplace le zombie vers la gauche
end


-- Dessine le zombie et sa boîte englobante pour le débogage
function ZombieWalk:draw()
    -- Dessine le sprite actuel du zombie
    if self.spriteSheet and self.quads[self.currentFrame] then
        love.graphics.draw(self.spriteSheet, self.quads[self.currentFrame], self.x, self.y, 0, self.scale, self.scale)
    end
    
    -- Dessine la boîte englobante autour du zombie pour le débogage
    love.graphics.setColor(0, 0, 0)
    local bx, by, bw, bh = self:getBoundingBox()
    love.graphics.rectangle("line", bx, by, bw, bh)
    love.graphics.setColor(1, 1, 1) -- Réinitialise la couleur pour les dessins suivants
end

return ZombieWalk