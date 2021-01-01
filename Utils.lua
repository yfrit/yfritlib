local Table = require("YfritLib.Table")

local Utils = {}

function Utils.isCallable(f)
    local metatable = getmetatable(f)
    return type(f) == "function" or (metatable and metatable.__call)
end

-- TODO remove usages of deprecated Utils.shallowCopy
Utils.shallowCopy = Table.shallowCopy
Utils.shuffleTable = Table.shuffle

local function tostring2(elem)
    if type(elem) == "string" then
        return "'" .. elem .. "'"
    else
        return tostring(elem)
    end
end

function Utils.printTable(elem, hist, tabs)
    hist = hist or {}
    tabs = tabs or 0
    if type(elem) ~= "table" then
        print(tostring2(elem))
    else
        if not hist[elem] then
            hist[elem] = true
            print(tostring2(elem) .. " {")
            tabs = tabs + 1
            for i, e in pairs(elem) do
                io.write(string.rep("\t", tabs) .. "[" .. tostring2(i) .. "] ")
                printR(e, hist, tabs)
            end
            tabs = tabs - 1
            print(string.rep("\t", tabs) .. "}")
        else
            print(tostring2(elem) .. " {...}")
        end
    end
end
_G.printR = Utils.printTable

function Utils.areEqual(object1, object2)
    --TODO cache in a weak table to prevent cycles

    --if some of the two objects is not a table, just do a simple comparison
    if type(object1) ~= "table" or type(object2) ~= "table" then
        return object1 == object2
    end

    --otherwise, compare two tables recursively
    if object1 == object2 then
        --if they are actually the same table, don't waste time comparing and just return true
        return true
    end

    --check if all attributes of object1 are in object2
    for key, value in pairs(object1) do
        if not Utils.areEqual(object2[key], value) then
            return false
        end
    end

    --check if all attributes of object2 are in object1
    for key, value in pairs(object2) do
        if not Utils.areEqual(object1[key], value) then
            return false
        end
    end

    return true
end

function permutations(t, min, max)
    min = math.min(min or #t, #t)
    max = math.min(max or min, #t)
    local k = min

    local result = {0}
    for i = 2, #t do
        result[i] = 1
    end
    return function()
        repeat
            local index = 1
            repeat
                --increment index
                result[index] = result[index] + 1

                --if reached ceil, reset and increment next
                local reachedCeil = false
                if result[index] > #t then
                    reachedCeil = true
                    result[index] = 1
                    index = index + 1

                    --if reached last index, go to next k and reset
                    if index > k then
                        k = k + 1
                        local result = {0}
                        for i = 2, #t do
                            result[i] = 1
                        end
                        index = 1

                        --if reached last k, finish permutations
                        if k > max then
                            return
                        end
                    end
                end
            until not reachedCeil

            --check if doesn't repeat values
            local usedValues = {}
            local hasRepeats = false
            for i = 1, k do
                local v = result[i]
                if usedValues[v] then
                    hasRepeats = true
                    break
                end
                usedValues[v] = true
            end
        until not hasRepeats

        --form result with actual values
        local realResult = {}
        for i = 1, k do
            realResult[i] = t[result[i]]
        end
        return realResult
    end
end

local originalResume = coroutine.resume
local wrappedCoroutines = {}

function coroutine.resume(co, ...)
    if wrappedCoroutines[co] then
        co = wrappedCoroutines[co]
    end
    return originalResume(co, ...)
end

function _G.pcall(f, ...)
    local co = coroutine.create(f)
    local runningCoroutine = coroutine.running()
    wrappedCoroutines[co] = runningCoroutine

    while true do
        local result = {originalResume(co, ...)}
        local status = result[1]
        table.remove(result, 1)

        if coroutine.status(co) ~= "suspended" then
            -- error or normal return
            if runningCoroutine then
                wrappedCoroutines[runningCoroutine] = nil
            end
            return status, unpack(result)
        else
            -- suspend across `mypcall'
            coroutine.yield(unpack(result))
        end
    end
end

function Utils.executeAsCoroutine(f)
    local cor = coroutine.create(f)
    Utils.resumeCoroutine(cor)
    return cor
end
_G.async = Utils.executeAsCoroutine

function Utils.resumeCoroutine(cor)
    local ok, errorMessage = coroutine.resume(cor)
    if not ok then
        error(debug.traceback(cor, errorMessage), 2)
    end
end

function Utils.getRandomFromDistribution(distribution)
    local count = 0
    for _, value in pairs(distribution) do
        count = count + value
    end

    local randomNumber = math.random() * count
    for item, value in pairs(distribution) do
        count = count - value
        if count <= randomNumber then
            return item
        end
    end
end

function _G.math.round(x)
    return math.floor(x + 0.5)
end

function _G.math.lerp(a, b, t)
    return a * (1 - t) + b * t
end

return Utils
