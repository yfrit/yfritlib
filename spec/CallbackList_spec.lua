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
		it(
			"execute AfterInsert RepassesParameterToCallback",
			function()
				local list = CallbackList:new()
				local callback = stub.new()
				list:insert(callback)

				list:execute("banana", true, 2)

				assert.stub(callback).was_called_with("banana", true, 2)
			end
		)
		it(
			"execute AfterInsertWithParameters PassesInsertParametersFirst",
			function()
				local list = CallbackList:new()
				local callback = stub.new()
				list:insert(callback, 1, 2)

				list:execute(3, 4)

				assert.stub(callback).was_called_with(1, 2, 3, 4)
			end
		)
		it(
			"remove ThenExecute RemovedCallbackIsNotExecuted",
			function()
				local list = CallbackList:new()
				local callback = stub.new()
				list:insert(callback)

				list:remove(callback)
				list:execute()

				assert.stub(callback).was_not_called()
			end
		)
	end
)
