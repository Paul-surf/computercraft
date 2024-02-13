local startCords = {x = 0, y = 0, z = 0}
local currentCords = {x = 0, y = 0, z = 0}
local isLooking = "north"

function isOre(block)
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

-- north frem af +z
function moveNorth()
    currentCoords.z = currentCoords.z + 1
end
-- south bagud -z
function moveSouth()
    currentCoords.z = currentCoords.z - 1
end
-- east = venstre +x
function mouseEast()
    currentCoords.x = currentCoords.x + 1

end
-- west = højre -x
function moveWest()
    currentCoords.x = currentCoords.x - 1

end

function goToOrigin()
    turtle.back()
    turtle.up()
    turtle.back()
end

function checkSurroundings()
    local success
    local blockName
    local res
    for i = 1, 5 do 
        if i == 1 then
            success, block = turtle.inspect()
            if success then
                blockName = block.name
                if isOre(blockName) then
                    res = "forward"
                end
            end
        elseif i == 2 then
            turtle.turnLeft()
            success, block = turtle.inspect()
            if success then
                blockName = block.name
                if isOre(blockName) then
                    res = "forward"
                end
            end
        elseif i == 3 then
            turtle.turnRight()
            turtle.turnRight()
            success, block = turtle.inspect()
            if success then
                blockName = block.name
                if isOre(blockName) then
                    res = "forward"
                end
            end
        elseif i == 4 then
            turtle.turnLeft()
            success, block = turtle.inspectDown()
            if success then
                blockName = block.name
                if isOre(blockName) then
                    res = "down"
                end
            end
        elseif i == 5 then
            success, block = turtle.inspectUp()
            if success then
                blockName = block.name
                if isOre(blockName) then
                    res = "up"
                end
            end
        end
    end
    return res
end

function harvestOre(direction)
    local isFound = false
    local i = 1
    local directions = {
        "forward",
        "down",
        "up"
    }
    if type(direction) == "string" then
        while i <= #directions or not isFound do
            if direction == directions[i] then
                isFound = true
                return
            end
            i = i + 1
        end
        print("Wrong Input, check grammar")
    end
    if isFound then
        if i == 1 then
            turtle.dig()
        elseif i == 2 then
            turtle.digDown()
        elseif i == 3 then
            turtle.digUp()
        end
    end
    return direction
end

function move(direction)
    local isFound = false
    local i = 1
    local directions = {
        "forward",
        "down",
        "up"
    }
    if type(direction) == "string" then
        while i <= #directions or not isFound do
            if direction == directions[i] then
                isFound = true
                if i == 1 then
                    turtle.forward()
                    currentCords.x = currentCords.x + 1
                elseif i == 2 then 
                    turtle.down()
                    currentCords.y = currentCords.y - 1
                elseif i == 3 then
                    turtle.up()
                    currentCords.y = currentCords.y + 1
                end
            end
            i = i + 1
        end
        print("Wrong Input, check grammar")
    end
end

function main()
    while true do
        local res = checkSurroundings()
        
        if res then
            local success, direction = harvestOre(res)
            move(direction)
            if not success then
                break  -- Exit the loop if harvestOre returns false
            end
        else
            break  -- Exit the loop if checkSurroundings returns false
        end
    end
end

main()