--[[
  Hacks a class (a.k.a. class) to debug all of its function calls.
--]]
local Class = require("YfritLib.Class")
local Table = require("YfritLib.Table")

local Spy =
    Class.new(
    {},
    function(self, target)
        self.tabs = 0
        self.currentLine = 0
        self.lastPrintedLine = 0
        self.buffer = {}
        self:_replaceMethods(target)
    end
)

function Spy:_replaceMethods(target)
    for fieldName, fieldValue in pairs(target) do
        -- check if is a method
        if type(fieldValue) == "function" then
            self:_replaceMethod(target, fieldName, fieldValue)
        end
    end
end

function Spy:_replaceMethod(target, methodName, methodFunction)
    -- wrap original function with one of our own
    target[methodName] = function(targetSelf, ...)
        self.currentLine = self.currentLine + 1
        local currentLine = self.currentLine

        self.tabs = self.tabs + 1
        local results = {methodFunction(targetSelf, ...)}
        self.tabs = self.tabs - 1

        self.buffer[currentLine] =
            string.rep("\t", self.tabs) .. methodName .. self:_formatParameters({...}) .. self:_formatResults(results)
        if currentLine == self.lastPrintedLine + 1 then
            self:_printLines()
        end

        return unpack(results)
    end
end

function Spy:_formatParameters(parameters)
    local strings = Table.map(parameters, tostring)
    return "(" .. table.concat(strings, ", ") .. ")"
end

function Spy:_formatResults(results)
    if #results > 0 then
        local strings = Table.map(results, tostring)
        return " => " .. table.concat(strings, ", ")
    else
        return ""
    end
end

function Spy:_printLines()
    local line = self.lastPrintedLine + 1

    while self.buffer[line] do
        print(self.buffer[line])
        line = line + 1
    end

    self.lastPrintedLine = line - 1
end

return function(target)
    return Spy:new(target)
end
