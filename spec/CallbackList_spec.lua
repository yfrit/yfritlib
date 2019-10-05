require("LocalRockInit")

insulate(
	"CallbackList",
	function()
		local CallbackList
		setup(
			function()
				CallbackList = require("CallbackList")
			end
		)
		it(
			"execute AfterInsert ExecutesInsertedCallback",
			function()
				local list = CallbackList:new()
				local callback = stub.new()
				list:insert(callback)

				list:execute()

				assert.stub(callback).was_called()
			end
		)
	end
)
