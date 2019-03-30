function _G.magicMock()
    local __return
    local mock =
        setmetatable(
        {},
        {
            __index = function(t, k)
                local newMock = magicMock()
                rawset(t, k, newMock)
                return newMock
            end,
            __call = function()
                if __return ~= nil then
                    return __return
                end
                return magicMock()
            end
        }
    )
    function mock.__return(ret)
        __return = ret
    end
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
