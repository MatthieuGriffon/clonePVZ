local GrilleUtils = {}

GrilleUtils.centresCases = {
    -- Ligne 1
    {x = 280, y = 295},  -- Colonne 1
    {x = 350, y = 295}, -- Colonne 2
    {x = 425, y = 295}, -- Colonne 3
    {x = 502, y = 295}, -- Colonne 4
    {x = 576, y = 295}, -- Colonne 5
    {x = 655, y = 295}, -- Colonne 6
    {x = 725, y = 295}, -- Colonne 7
    {x = 800, y = 295}, -- Colonne 8
    {x = 882, y = 295}, -- Colonne 9

    -- Ligne 2
    {x = 280, y = 396},  -- Colonne 1
    {x = 350, y = 396}, -- Colonne 2
    {x = 425, y = 396}, -- Colonne 3
    {x = 502, y = 396}, -- Colonne 4
    {x = 576, y = 396}, -- Colonne 5
    {x = 655, y = 396}, -- Colonne 6
    {x = 725, y = 396}, -- Colonne 7
    {x = 800, y = 396}, -- Colonne 8
    {x = 882, y = 396}, -- Colonne 9
    
    -- Ligne 3
    {x = 280, y = 490},  -- Colonne 1
    {x = 350, y = 490}, -- Colonne 2
    {x = 425, y = 490}, -- Colonne 3
    {x = 502, y = 490}, -- Colonne 4
    {x = 576, y = 490}, -- Colonne 5
    {x = 655, y = 490}, -- Colonne 6
    {x = 725, y = 490}, -- Colonne 7
    {x = 800, y = 490}, -- Colonne 8
    {x = 882, y = 490}, -- Colonne 9

    -- Ligne 4
    {x = 280, y = 575},  -- Colonne 1
    {x = 350, y = 575}, -- Colonne 2
    {x = 425, y = 575}, -- Colonne 3
    {x = 502, y = 575}, -- Colonne 4
    {x = 576, y = 575}, -- Colonne 5
    {x = 655, y = 575}, -- Colonne 6
    {x = 725, y = 575}, -- Colonne 7
    {x = 800, y = 575}, -- Colonne 8
    {x = 882, y = 575}, -- Colonne 9

    -- Ligne 5
    {x = 280, y = 666},  -- Colonne 1
    {x = 350, y = 666}, -- Colonne 2
    {x = 425, y = 666}, -- Colonne 3
    {x = 502, y = 666}, -- Colonne 4
    {x = 576, y = 666}, -- Colonne 5
    {x = 655, y = 666}, -- Colonne 6
    {x = 725, y = 666}, -- Colonne 7
    {x = 800, y = 666}, -- Colonne 8
    {x = 882, y = 666}, -- Colonne 9
}
function GrilleUtils.trouverCentreLePlusProche(xClic, yClic)
    local centreLePlusProche = nil
    local distanceMin = math.huge
    local indiceLePlusProche = nil

    for indice, centre in ipairs(GrilleUtils.centresCases) do
        local distance = math.sqrt((xClic - centre.x)^2 + (yClic - centre.y)^2)
        if distance < distanceMin then
            distanceMin = distance
            centreLePlusProche = centre
            indiceLePlusProche = indice
        end
    end

    return centreLePlusProche, indiceLePlusProche
end
return GrilleUtils