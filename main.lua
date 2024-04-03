require("jardin.Jardin")
local ZombieWalk = require('zombies.zombieWalkAnimation')
local PlanteSelector = require('utils.PlanteSelector')
local GrilleUtils = require('utils.GrilleUtils')
local plantesActives = {}
local jardin = {
    x = 249,
    y = 252,
    largeur = 660,
    hauteur = 448
}
local zombies = {}
local spawnTimer = 0
local spawnInterval = 8
local casesOccupees = {}

PlanteSelector.animationsActives = {}

function love.mousepressed(x, y, button)
    if button == 1 then
        PlanteSelector.checkClick(x, y)
        print("Clic gauche, la plante selectionne est : ", PlanteSelector.planteSelectionnee)
    end

    if button == 2 then
        local typePlante = PlanteSelector.planteSelectionnee
        if typePlante then
            -- Si la plante sélectionnée est en cooldown, empêcher le placement
            if PlanteSelector.cooldownsActifs[typePlante] and PlanteSelector.cooldownsActifs[typePlante] > 0 then
                return -- Empêche le reste du code de s'exécuter pour ce clic
            end
            local infoPlante = PlanteSelector.typesDePlantes[typePlante]
            if infoPlante and x >= jardin.x and x <= jardin.x + jardin.largeur and y >= jardin.y and y <= jardin.y +
                jardin.hauteur then
                local centreLePlusProche, indiceCase = GrilleUtils.trouverCentreLePlusProche(x, y)
                -- Vérifie que centreLePlusProche et indiceCase ne sont pas nil
                if centreLePlusProche and indiceCase and not casesOccupees[indiceCase] then
                    local nouvellePlante = infoPlante.animationClass.new(infoPlante.spritePath)
                    nouvellePlante.x = centreLePlusProche.x - (nouvellePlante.frameWidth * nouvellePlante.scale / 2)
                    nouvellePlante.y = centreLePlusProche.y - (nouvellePlante.frameHeight * nouvellePlante.scale / 2)
                    table.insert(plantesActives, nouvellePlante)
                    casesOccupees[indiceCase] = true
                    PlanteSelector.cooldownsActifs[typePlante] = PlanteSelector.typesDePlantes[typePlante].cooldown
                    print("Plante placée avec succès.", typePlante, "cooldown:",
                        PlanteSelector.cooldownsActifs[typePlante])
                elseif not indiceCase then
                    print("Aucun centre le plus proche trouvé.")
                else
                    print("Case déjà occupée.")
                end
            end
        end
    end
end

function love.load()
    math.randomseed(os.time())
    love.window.setTitle("Plants vs Zombies - Jardin")
    love.window.setMode(1300, 900)

    Jardin.init(12, 5, 60, 60, "jardin/assets/spriteSheet/jardin.png", 1, 1, 448, 193, 247, 245, 247, 170)
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
    for nom, cooldown in pairs(PlanteSelector.cooldownsActifs) do
        if cooldown > 0 then
            PlanteSelector.cooldownsActifs[nom] = math.max(0, cooldown - dt)
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
