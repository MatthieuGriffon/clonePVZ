local CollisionUtils = {}

function CollisionUtils.checkBoxCollision(x1, y1, width1, height1, x2, y2, width2, height2)
    local isLeft = x1 + width1 < x2
    local isRight = x1 > x2 + width2
    local isAbove = y1 + height1 < y2
    local isBelow = y1 > y2 + height2

    return not (isLeft or isRight or isAbove or isBelow)
end

return CollisionUtils