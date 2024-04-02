require("jardin.Jardin")
local ZombieWalk = require('zombies.zombieWalkAnimation')
local PlanteSelector = require('utils.PlanteSelector')
local GrilleUtils = require('utils.GrilleUtils')
local collisionUtils = require('utils.CollisionUtils')
local plantesActives = {}
local jardin = {
    x=249,
    y=252,
    largeur = 660,
    hauteur = 448
}
local peashooter
local sunflower
local zombies = {}
local spawnTimer = 0
local spawnInterval = 10 -- Génère un nouveau zombie toutes les 5 secondes
local timer = 0
PlanteSelector.animationsActives = {}

function love.mousepressed(x, y, button, istouch, presses)
    -- Clic gauche : vérification pour la sélection des plantes, peut se faire n'importe où
    if button == 1 then
        PlanteSelector.checkClick(x, y)
    end

    -- Clic droit : placement des plantes, limité à la zone du jardin
    if button == 2 then
        local typePlante = PlanteSelector.planteSelectionnee
        if typePlante then
            local infoPlante = PlanteSelector.typesDePlantes[typePlante]
            if infoPlante and x >= jardin.x and x <= jardin.x + jardin.largeur and y >= jardin.y and y <= jardin.y + jardin.hauteur then
                local centreLePlusProche = GrilleUtils.trouverCentreLePlusProche(x, y)
                if centreLePlusProche then
                    local nouvellePlante = infoPlante.animationClass.new(infoPlante.spritePath)
                    -- Ajuste la position x et y de la nouvellePlante ici en fonction du centre le plus proche
                    nouvellePlante.x = centreLePlusProche.x - (nouvellePlante.frameWidth * nouvellePlante.scale / 2)
                    nouvellePlante.y = centreLePlusProche.y - (nouvellePlante.frameHeight * nouvellePlante.scale / 2)
                    table.insert(plantesActives, nouvellePlante)
                    PlanteSelector.planteSelectionnee = nil
                end
            end
        end
    end
end

function love.load()
    math.randomseed(os.time())
    love.window.setTitle("Plants vs Zombies - Jardin")
    love.window.setMode(1300, 900)
    Jardin.init(
        12, 5, 60, 60,
        "jardin/assets/spriteSheet/jardin.png",
         1, 1, 448, 193,
        247, 245, 247, 170)
    PlanteSelector.load()
end

function love.update(dt)
    spawnTimer = spawnTimer + dt
    if spawnTimer >= spawnInterval then
        spawnTimer = spawnTimer - spawnInterval
        table.insert(zombies, ZombieWalk.new("zombies/assets/spriteSheet/spriteSheetZombie.png", 61))
    end
    for _, zombie in ipairs(zombies) do
        zombie:update(dt)
    end
    for _, plante in ipairs(plantesActives) do
        if plante.update then
            plante:update(dt, zombies)
        end
        if plante.updateProjectiles then
            plante:updateProjectiles(dt, zombies)
        end
    end
end

function love.draw()
    Jardin.dessiner()

    function love.draw()
        Jardin.dessiner()
        for _, zombie in ipairs(zombies) do
            zombie:draw()
        end
        for _, plante in ipairs(plantesActives) do
            plante:draw()
        end
        PlanteSelector.draw()
    end
end
