--[[
Implements a list, where callbacks can be inserted and executed.
--]]
local Class = require("YfritLib.Class")
local Utils = require("YfritLib.Utils")

local CallbackList =
	Class.new(
	{},
	function(self)
		self.callbacks = {}
	end
)

function CallbackList:insert(callback, ...)
	assert(Utils.isCallable(callback), "Callback must be a function.")
	self.callbacks[callback] = {...}
end

function CallbackList:remove(callback)
	assert(Utils.isCallable(callback), "Callback must be a function.")
	self.callbacks[callback] = nil
end

function CallbackList:execute(...)
	for callback, insertParams in pairs(self.callbacks) do
		-- concatanate paramaters received on insert with parameters received on execute
		local allParams = Utils.shallowCopy(insertParams)
		for _, executeParam in ipairs({...}) do
			table.insert(allParams, executeParam)
		end
		callback(unpack(allParams))
	end
end

return CallbackList
