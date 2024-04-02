Jardin = {}

function Jardin.init(grilleLargeur, grilleHauteur, caseLargeur, caseHauteur, imagePath, jardinX, jardinY, jardinWidth, jardinHeight, pelouseX, pelouseY, pelouseWidth, pelouseHeight)
    Jardin.grilleLargeur = grilleLargeur
    Jardin.grilleHauteur = grilleHauteur
    Jardin.caseLargeur = caseLargeur
    Jardin.caseHauteur = caseHauteur
    -- Charge la sprite sheet
    Jardin.spriteSheet = love.graphics.newImage(imagePath)
    
    -- Crée un quad pour l'image du jardin
    Jardin.jardinQuad = love.graphics.newQuad(jardinX, jardinY, jardinWidth, jardinHeight, Jardin.spriteSheet:getDimensions())
    
    -- Crée un quad pour l'image de la pelouse
    Jardin.pelouseQuad = love.graphics.newQuad(pelouseX, pelouseY, pelouseWidth, pelouseHeight, Jardin.spriteSheet:getDimensions())
    
    -- Stocke aussi les dimensions du jardin pour un usage ultérieur
    Jardin.jardinWidth = jardinWidth
    Jardin.jardinHeight = jardinHeight
end

function Jardin.dessiner()
    local fenetreLargeur = love.graphics.getWidth()
    local fenetreHauteur = love.graphics.getHeight()
    
    -- Utilise les dimensions stockées du jardin pour calculer l'échelle
    local echelleX = fenetreLargeur / Jardin.jardinWidth
    local echelleY = fenetreHauteur / Jardin.jardinHeight
    local echelle = math.min(echelleX, echelleY)
    
    -- Calcule la position pour centrer l'image dans la fenêtre
    local positionX = (fenetreLargeur - (Jardin.jardinWidth * echelle)) / 2
    local positionY = (fenetreHauteur - (Jardin.jardinHeight * echelle)) / 2
    
    -- Dessine le quad de l'image du jardin ajusté à la fenêtre
    if Jardin.spriteSheet and Jardin.jardinQuad then
        love.graphics.draw(Jardin.spriteSheet, Jardin.jardinQuad, positionX, positionY, 0, echelle, echelle)
    end

    -- Position et échelle pour la pelouse
    local pelouseX, pelouseY = 90, 150 -- Position de départ de la pelouse
    local echelleX, echelleY = 2.9, 2.9     -- Facteur d'échelle pour agrandir l'image de la pelouse
    
    -- Dessine la pelouse à l'emplacement spécifié
    local pelouseX, pelouseY = 222, 235
    if Jardin.spriteSheet and Jardin.pelouseQuad then
        love.graphics.draw(Jardin.spriteSheet, Jardin.pelouseQuad, pelouseX, pelouseY, 0, echelleX, echelleY)
    end
end

