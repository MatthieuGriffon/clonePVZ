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
        cooldown = 10,
    },
    Sunflower = {
        spritePath = 'plantes/assets/spriteSheet/Sunflower.png',
        animationClass = SunflowerIdleAnimation,
        cooldown = 15,
    },
}

local Plante = {}
Plante.__index = Plante

function Plante.new(nom, imageSheet, quad, cooldownquad)
    print("Création de plante:", nom, "CooldownQuad:", cooldownquad)
    local self = setmetatable({}, Plante)
    self.nom = nom
    self.imageSheet = imageSheet
    self.quad = quad
    self.cooldownQuad = cooldownquad

    function Plante:estClique(x, y)
        local imageWidth = 35 * 2 -- Assumant un scale de 2 pour l'exemple
        local imageHeight = 35 * 2
        return x >= self.x and x <= self.x + imageWidth and y >= self.y and y <= self.y + imageHeight
    end
    return self
end

function PlanteSelector.load()
    PlanteSelector.planteSelectionnee = nil -- Stocke le nom de la plante sélectionnée(nul au départ)
    PlanteSelector.cooldownsActifs = {
        Peashooter = 0,
        Sunflower = 0,
    }
    -- Charge les spritesheets et les quads pour chaque type de plante
    local sunflowerSheet = love.graphics.newImage("plantes/assets/spriteSheet/Sunflower.png")
    local peashooterSheet = love.graphics.newImage("plantes/assets/spriteSheet/Peashooter.png")
    
    local sunflowerQuad = love.graphics.newQuad(161, 0, 26, 26, sunflowerSheet:getDimensions())
    local peashooterQuad = love.graphics.newQuad(112, 33, 26, 26, peashooterSheet:getDimensions())

    local peashooterCooldownQuad = love.graphics.newQuad(138, 33, 26, 26, peashooterSheet:getDimensions())
    local sunflowerCooldownQuad = love.graphics.newQuad(187, 0, 37, 35, sunflowerSheet:getDimensions())

    PlanteSelector.typesDePlantes.Peashooter.cooldownQuad = peashooterCooldownQuad
    PlanteSelector.typesDePlantes.Sunflower.cooldownQuad = sunflowerCooldownQuad
    PlanteSelector.typesDePlantes.Peashooter.quad = peashooterQuad
    PlanteSelector.typesDePlantes.Sunflower.quad = sunflowerQuad


    
    -- Crée des instances de Plante pour chaque type de plante
    
    local sunflower = Plante.new("Sunflower", sunflowerSheet, sunflowerQuad, sunflowerCooldownQuad)
    local peashooter = Plante.new("Peashooter", peashooterSheet, peashooterQuad, peashooterCooldownQuad)

    
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

function Plante:draw(x, y, scaleX, scaleY, quadToDraw)
    love.graphics.draw(self.imageSheet, quadToDraw, x, y, 0, scaleX, scaleY)
end

function PlanteSelector.draw()
    -- Dessine le cadre
    love.graphics.setColor(1, 1, 1) -- Couleur blanche pour le cadre
    love.graphics.rectangle('line', PlanteSelector.x, PlanteSelector.y, PlanteSelector.width, PlanteSelector.height)
    
    
    local scaleX = 2 -- Facteur d'échelle sur l'axe X
    local scaleY = 2 -- Facteur d'échelle sur l'axe Y
    local padding = 10 -- Espace entre le bord du cadre et la plante
    local x = PlanteSelector.x + padding

    for _, plante in ipairs(PlanteSelector.plantes) do
        local cooldown = PlanteSelector.cooldownsActifs[plante.nom]
        
        plante.x = x
        plante.y = PlanteSelector.y + padding
        local quadToDraw = (cooldown and cooldown > 0) and plante.cooldownQuad or plante.quad
   
        plante:draw(plante.x, plante.y, scaleX, scaleY, quadToDraw)
        if not quadToDraw then
        print("Erreur: quadToDraw est nil pour", plante.nom)
        -- Vous pourriez dessiner un rectangle ou un texte alternatif ici pour visualiser le problème
        else
        
        love.graphics.draw(plante.imageSheet, quadToDraw, plante.x, plante.y, 0, scaleX, scaleY)
        end
        
        -- Ajout d'un print pour déboguer
        if cooldown and cooldown > 0 then
            print(plante.nom .. " est en cooldown, dessine cooldownQuad")
            print ("imageSheet", plante.imageSheet, plante.cooldownQuad, plante.x, plante.y)

            love.graphics.draw(plante.imageSheet,plante.cooldownQuad, plante.x, plante.y, 0, scaleX, scaleY)
        else
            print(plante.nom .. " n'est pas en cooldown, dessine quad normal")
            love.graphics.draw(plante.imageSheet, plante.quad, plante.x, plante.y, 0, scaleX, scaleY)
        end
        
        x = x + (35 * scaleX) + padding
    end
end

return PlanteSelector