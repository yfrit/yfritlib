--[[
Implements a list, where callbacks can be inserted and executed.
--]]
local Class = require("YfritLib.Class")
local Utils = require("YfritLib.Utils")
local Table = require("YfritLib.Table")

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
	-- copy callback list to another table, to guarentee it won't be modified during the iterations
	local callbacks = Table.shallowCopy(self.callbacks)

	for callback, insertParams in pairs(callbacks) do
		-- concatanate paramaters received on insert with parameters received on execute
		local allParams = Table.shallowCopy(insertParams)
		for _, executeParam in ipairs({...}) do
			table.insert(allParams, executeParam)
		end
		callback(unpack(allParams))
	end
end

return CallbackList
