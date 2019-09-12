local Class = {}

function Class.new(class, constructor, parent)
    --object metatable
    class.__index = class
    class.new = function(self, ...)
        if self == class then
            --create new self
            self = {}
            setmetatable(self, class)
        end

        --call parent constructor
        if parent then
            parent.new(self, ...)
        end

        --call class constructor
        constructor(self, ...)
        return self
    end

    --set parent class
    if parent then
        setmetatable(class, parent)
    end

    --add class attribute
    class.class = class

    return class
end

function Class.isInstanceOf(object, class)
    return type(object) == "table" and object.class == class
end

return Class
