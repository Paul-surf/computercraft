local turtleMovements = {}

function checkAbove()
    local success, block = turtle.inspectUp()
    local blockName
    local isOre = false
    if success then
        blockName = block.name
        if isOre(blockName) then
            return isOre
        end
    end
    return isOre
end
function checkBelow()
    local success, block = turtle.inspectDown()
    local blockName
    local isOre = false
    if success then
        blockName = block.name
        if isOre(blockName) then
            return isOre
        end
    end
    return isOre
end
function checkRight()
    turtle.turnRight()
    local success, block = turtle.inspect()
    local blockName
    local isOre = false
    if success then
        blockName = block.name
        if isOre(blockName) then
            table.insert(turtleMovements, "rightTurn")
            return isOre
        end
    end
    return isOre
end
function checkLeft()
    turtle.turnLeft()
    local success, block = turtle.inspect()
    local blockName
    local isOre = false
    if success then
        blockName = block.name
        if isOre(blockName) then
            table.insert(turtleMovements, "leftTurn")
            return isOre
        end
    end
    return isOre
end
function returnToStart() 
    for i = #turtleMovements, 1, -1 do
        local movement = turtleMovements[i]
        if movement == "forward" then
            turtle.back()
        elseif movement == "up" then
            turtle.down()
        elseif movement == "down" then
            turtle.up()
        elseif movement == "rightTurn" then
            turtle.turnLeft()
        elseif movement == "leftTurn" then
            turtle.turnRight()
        end
    end
end

function verifyOre()
    local success, block = turtle.inspect()
    local blockName
    if not success then
        if checkAbove() then
            turtle.digUp()
            turtle.up()
            table.insert(turtleMovements, "up")
            verifyOre()
        end
        if checkBelow() then
            turtle.digDown()
            turtle.down()
            table.insert(turtleMovements, "down")
            verifyOre()
        end
        if checkRight() then
            turtle.dig()
            turtle.forward()
            table.insert(turtleMovements, "forward")
            verifyOre()
        end
        if checkLeft() then
            turtle.dig()
            turtle.forward()
            table.insert(turtleMovements, "forward")
            verifyOre()
        end
    end

    if success then
        blockName = block.name
        if isOre(blockName) then
            turtle.dig()
            table.insert(turtleMovements, "forward")
            verifyOre()
        end
    end
    if checkAbove() then
        turtle.digUp()
        turtle.up()
        table.insert(turtleMovements, "up")
        verifyOre()
    end
    if checkBelow() then
        turtle.digDown()
        turtle.down()
        table.insert(turtleMovements, "down")
        verifyOre()
    end
    if checkRight() then
        turtle.dig()
        turtle.forward()
        table.insert(turtleMovements, "forward")
        verifyOre()
    end
    if checkLeft() then
        turtle.dig()
        turtle.forward()
        table.insert(turtleMovements, "forward")
        verifyOre()
    end
    returnToStart()
end