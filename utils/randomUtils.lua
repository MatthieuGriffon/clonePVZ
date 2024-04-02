local function selectRandomY(yPositions)
    local index = math.random(#yPositions) -- Sélectionne un index aléatoire
    return yPositions[index] -- Retourne la coordonnée y correspondante
end

return {
    selectRandomY = selectRandomY
}