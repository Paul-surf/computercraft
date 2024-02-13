local dir = {NORTH = 1, EAST = 2, SOUTH = 3, WEST = 4}
local currentDir = dir.NORTH
local lastDir = currentDir

local lookingDir = {STRAIGHT = 1, UP = 2, DOWN = 3}
local currentLookingDir = lookingDir.STRAIGHT

local startCoordinates = {x = 0, y = 0, z = 0}
local currentCoordinates = {x = 0, y = 0, z = 0}

local function isOre(block)
    local oreNames = {
        "minecraft:coal_ore",
        "minecraft:iron_ore",
        "minecraft:gold_ore",
        "minecraft:lapis_ore",
        "minecraft:redstone_ore",
        "minecraft:diamond_ore",
        "minecraft:emerald_ore",
        "minecraft:quartz_ore"
    }
    local anOre = false
    if type(block) == "string" then
        for _, oreName in ipairs(oreNames) do
            if block == oreName then
                anOre = true 
            end
        end
    else
        print("invalid type argument")
    end
    return anOre
end

local function mineBack(XYZ, isUp)
    print("jeg blev kaldt for at mine")
    if not XYZ == "y" then
        local isBlock, block = turtle.inspect()
        if isBlock then 
            turtle.dig()
            turtle.forward()
        else
            turtle.forward()
        end
    elseif isUp then
        local isBlock, block = turtle.inspectUp()
        if isBlock then
            turtle.digUp()
            turtle.up()
        else 
            turtle.up()
        end
    else
        local isBlock, block = turtle.inspectDown() 
        if isBlock then
            turtle.digDown()
            turtle.down()
        else
            turtle.down()
        end
    end
end

local function goOrigin() 
    print("jeg blev kaldt")
    local x = currentCoordinates.x
    local y = currentCoordinates.y
    local z = currentCoordinates.z
    if currentDir == dir.EAST then
        turtle.turnLeft()
    elseif currentDir == dir.WEST then
        turtle.turnRight()
    else
        turtle.turnLeft()
        turtle.turnLeft()
    end
    if x > 0 then
        turtle.turnRight()
        for i = 1, x do
            mineBack("x", false)
        end
    else
        turtle.turnLeft()
        for i = 0, x do
            mineBack("x", false)
        end
    end
    if z > 0 then
        turtle.turnRight()
        turtle.turnRight()
        for i = 1, z do
            mineBack("z", false)
        end
    else
        turtle.turnLeft()
        turtle.turnRight()
        for i = 0, z do
            mineBack("z", false)
        end
    end
    if y > 0 then
        for i = 1, y do
            mineBack("y", false)
        end
    else
        for i = 0, x do
            mineBack("y", true)
        end
    end
end


local function coordsUpdater(xyzDirection, lookingDirection, isMining, isNewDir)
    if isMining then
        if lookingDirection < lookingDir.UP then
            if currentDir == dir.NORTH then
                turtle.forward()
                currentCoordinates.x = currentCoordinates.x-1
            elseif currentDir == dir.WEST then
                turtle.forward()
                currentCoordinates.x = currentCoordinates.x+1
            elseif currentDir == dir.EAST then
                turtle.forward()
                currentCoordinates.x = currentCoordinates.x+1
            elseif currentDir == dir.SOUTH then
                turtle.forward()
                currentCoordinates.z = currentCoordinates.z+1
            end
        end
    -- else
    --     print("Time to head back")
    --     print("Retrieving route")
    --     sleep(1)
    --     for i = #movements, 1, -1 do
    --         print("Route fetched, heading back")
    --         sleep(1)
    --         local movement = movements[i]
    --         if movement == "forwards" then
    --             print("backing up")
    --             sleep(1)
    --             turtle.back()
    --         elseif movement == "up" then
    --             turtle.down()
    --         elseif movement == "down" then
    --             turtle.up()
    --         elseif movement == "rightTurn" then
    --             turtle.turnRight()
    --         elseif movement == "leftTurn" then
    --             turtle.turnLeft()
    --         end
    --     end
    --     print("Good to be back")
    --     sleep(1)
    --     currentCoordinates = startCoordinates
    --     currentLookingDir = lookingDir.STRAIGHT
    --     currentDir = dir.NORTH
    -- end
    end
end

local function directionToCheck(loopRotation)
    local bool = false
    local block
    if loopRotation == 1 then
        local success, block = turtle.inspect()
        if success then
            if isOre(block.name) then
                bool = true
            end
        end
    elseif loopRotation == 2 then
        turtle.turnLeft()
        local success, block = turtle.inspect()
        if success then
            if isOre(block.name) then
                currentDir = dir.WEST
                bool = true
            end
        end
        if not bool then 
            turtle.turnRight()
        end
    elseif loopRotation == 3 then
        turtle.turnRight()
        local success, block = turtle.inspect()
        if success then
            if isOre(block.name) then
                currentDir = dir.EAST
                bool = true
            end
        end
        if not bool then 
            turtle.turnLeft()
        end
    end
    return bool
end

function harvestOre()
    local i = 1
    while i <= 5 do
        local success =  directionToCheck(i)

        if success then
            if currentLookingDir < lookingDir.UP then
                turtle.dig()
                if lastDir == currentDir then
                    -- if turtle, was looking north before and is still north then don't record any turn
                    coordsUpdater(currentDir, currentLookingDir, true, false)
                    lastDir = currentDir
                else
                    -- if turtle, was looking north before and is looking example south now, then record turns
                    coordsUpdater(currentDir, currentLookingDir, true, true)
                end
                i = 0
            end
        end
        if i == 4 then
            print(movements)
        end
        i = i + 1
    end
    goOrigin()
end

harvestOre()