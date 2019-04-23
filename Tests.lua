local Utils = require("Utils.Utils")

function _G.magicMock()
    local __return
    local __returnWith
    local cachedTables = {}

    local function getSimilarParameter(param)
        --if it is not a table, just return
        if type(param) ~= "table" then
            return param
        end

        --otherwise, check if there is a cached table that is recursively equal to param
        for _, cachedTable in ipairs(cachedTables) do
            if Utils.areEqual(param, cachedTable) then
                return cachedTable
            end
        end

        --if there was not, add param to cachedTables, then return
        table.insert(cachedTables, param)
        return param
    end
    local function setReturns(params, returns)
        if not __returnWith then
            __returnWith = {}
        end
        local target = __returnWith
        local amount = #params
        local indexes = {amount, unpack(params)}
        for i = 1, #indexes - 1 do
            local index = getSimilarParameter(indexes[i])
            target[index] = target[index] or {}
            target = target[index]
        end
        local lastIndex = getSimilarParameter(indexes[#indexes])
        target[lastIndex] = returns
    end
    local function getReturns(params)
        local amount = #params
        local indexes = {amount, unpack(params)}
        local target = __returnWith
        for _, index in ipairs(indexes) do
            if not target then
                return
            end
            target = target[getSimilarParameter(index)]
        end
        return target
    end
    local mock =
        setmetatable(
        {
            __return = function(ret)
                __return = ret
            end,
            __with = function(...)
                local params = {...}
                return {
                    __return = function(...)
                        local returns = {...}

                        setReturns(params, returns)
                    end
                }
            end
        },
        {
            __index = function(t, k)
                local newMock = magicMock()
                rawset(t, k, newMock)
                return newMock
            end,
            __call = function(_, ...)
                --if set a __return, just return it
                if __return ~= nil then
                    return __return
                end

                local params = {...}
                local returns = getReturns(params)
                if not returns then
                    returns = {magicMock()}
                    setReturns(params, returns)
                end

                return unpack(returns)
            end
        }
    )
    return mock
end

function _G.mockRequire(path, mock)
    mock = mock or magicMock()
    package.loaded[path] = mock
    return mock
end

function _G.unrequire(path)
    package.loaded[path] = nil
end
