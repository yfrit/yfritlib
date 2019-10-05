--[[
Implements a list, where callbacks can be inserted and executed.
--]]
local Class = require("YfritLib.Class")

local CallbackList =
	Class.new(
	{},
	function(self)
		self.callbacks = {}
	end
)

function CallbackList:insert(callback)
	table.insert(self.callbacks, callback)
end

function CallbackList:execute(...)
	for _, callback in ipairs(self.callbacks) do
		callback(...)
	end
end

return CallbackList
