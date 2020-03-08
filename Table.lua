--[[
  Contains useful functions for manipulating tables.
--]]
local Table = {}

function Table.append(t1, t2)
    local newTable = {}

    for _, value in ipairs(t1) do
        newTable[#newTable + 1] = value
    end
    for _, value in ipairs(t2) do
        newTable[#newTable + 1] = value
    end

    return newTable
end

-- TODO write tests for this
function Table.shallowCopy(t)
    local tCopy = {}
    for i, v in pairs(t) do
        tCopy[i] = v
    end
    return tCopy
end

function Table.reduce(t, callback)
    local total = t[1]

    for i = 2, #t do
        total = callback(total, t[i])
    end

    return total
end

function Table.map(t, callback)
    local newTable = {}

    for key, value in pairs(t) do
        newTable[key] = callback(value, key)
    end

    return newTable
end

function Table.toSet(t)
    local set = {}

    for _, value in pairs(t) do
        set[value] = true
    end

    return set
end

function Table.random(t)
    local randomIndex = math.random(1, #t)
    return t[randomIndex]
end

return Table
