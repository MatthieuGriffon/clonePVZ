local PlanteSelector = {}
PlanteSelector.plantes = {} 
PlanteSelector.x = 10 -- Position X du cadre
PlanteSelector.y = 740 -- Position Y du cadre
PlanteSelector.width = love.graphics.getWidth() -- La largeur du cadre
PlanteSelector.height = 150 -- La hauteur du cadre

local PeashooterIdleAnimation = require("plantes.peashooterIdleAnimation")
local SunflowerIdleAnimation = require("plantes.sunflowerIdleAnimation")

PlanteSelector.typesDePlantes = {
    Peashooter = {
        spritePath = 'plantes/assets/spriteSheet/Peashooter.png',
        animationClass = PeashooterIdleAnimation,
    },
    Sunflower = {
        spritePath = 'plantes/assets/spriteSheet/Sunflower.png',
        animationClass = SunflowerIdleAnimation,
    },
}

local Plante = {}
Plante.__index = Plante

function Plante.new(nom, imageSheet, quad)
    local self = setmetatable({}, Plante)
    self.nom = nom
    self.imageSheet = imageSheet
    self.quad = quad
    function Plante:estClique(x, y)
        local imageWidth = 35 * 2 -- Assumant un scale de 2 pour l'exemple
        local imageHeight = 35 * 2
        return x >= self.x and x <= self.x + imageWidth and y >= self.y and y <= self.y + imageHeight
    end
    return self
end

function PlanteSelector.load()
    PlanteSelector.planteSelectionnee = nil -- Stocke le nom de la plante sélectionnée(nul au départ)
    local sunflowerSheet = love.graphics.newImage("plantes/assets/spriteSheet/Sunflower.png")
    local sunflowerQuad = love.graphics.newQuad(150, 0, 35, 35, sunflowerSheet:getDimensions())
    
    local peashooterSheet = love.graphics.newImage("plantes/assets/spriteSheet/Peashooter.png")
    local peashooterQuad = love.graphics.newQuad(112, 33, 26, 26, peashooterSheet:getDimensions())

    
    -- Crée des instances de Plante pour chaque type de plante
    local sunflower = Plante.new("Sunflower", sunflowerSheet, sunflowerQuad)
    local peashooter = Plante.new("Peashooter", peashooterSheet, peashooterQuad)
    
    -- Stocke les plantes dans PlanteSelector.plantes
    
    table.insert(PlanteSelector.plantes, peashooter)
    table.insert(PlanteSelector.plantes, sunflower)



    -- Check si une plante a été cliqué
    function PlanteSelector.checkClick(x, y)
        for _, plante in ipairs(PlanteSelector.plantes) do
            if plante:estClique(x, y) then
                PlanteSelector.planteSelectionnee = plante.nom
                return plante.nom
            end
        end
    end
end

function Plante:draw(x, y, scaleX, scaleY)
    love.graphics.draw(self.imageSheet, self.quad, x, y, 0, scaleX, scaleY)
end

function PlanteSelector.draw()
    -- Dessine le cadre
    love.graphics.setColor(1, 1, 1) -- Couleur blanche pour le cadre
    love.graphics.rectangle('line', PlanteSelector.x, PlanteSelector.y, PlanteSelector.width, PlanteSelector.height)
    -- Paramètres de scaling
    local scaleX = 2 -- Facteur d'échelle sur l'axe X
    local scaleY = 2 -- Facteur d'échelle sur l'axe Y
    local padding = 10 -- Espace entre le bord du cadre et la plante
    local x = PlanteSelector.x + padding


    -- Dessine chaque plante dans le cadre
    for _, plante in ipairs(PlanteSelector.plantes) do
        plante.x = x -- Met à jour la position x de la plante
        plante.y = PlanteSelector.y + padding -- Met à jour la position y
        plante:draw(x, PlanteSelector.y + padding, scaleX, scaleY)
        x = x + (35 * scaleX) + padding -- Calcule la nouvelle position x pour la prochaine plante
    end
end

return PlanteSelector