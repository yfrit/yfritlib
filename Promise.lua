--[[
Promises can be used to wait for a result that may or may not be ready yet (i.e. asynchronous things).
--]]
local Class = require("YfritLib.Class")
local CallbackList = require("YfritLib.CallbackList")
local Utils = require("YfritLib.Utils")

local Promise =
	Class.new(
	{},
	function(self)
		self.isCompleted = false
		self.callbackList = CallbackList:new()
	end
)

function Promise:complete(...)
	self.isCompleted = true
	self.parameters = {...}
	self.callbackList:execute(...)
end

function Promise:onComplete(callback)
	if self.isCompleted then
		--if promise already completed, executed callback immediately
		callback(unpack(self.parameters))
	else
		--otherwise, save to execute lates
		self.callbackList:insert(callback)
	end
end

function Promise:await()
	if not self.isCompleted then
		--only pause coroutine if promise didn't complete yet
		local co = coroutine.running()
		self:onComplete(
			function()
				Utils.resumeCoroutine(co)
			end
		)
		coroutine.yield()
	end
	return unpack(self.parameters)
end

return Promise
