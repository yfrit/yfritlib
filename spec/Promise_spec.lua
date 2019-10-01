require("LocalRockInit")
local Utils = require("Utils")

insulate(
	"#Promise",
	function()
		local Promise
		setup(
			function()
				Promise = require("Promise")
			end
		)
		it(
			"onComplete BeforeComplete ExecutesCallbackWhenPromiseCompletes",
			function()
				local promise = Promise:new()
				local callback = stub.new()

				promise:onComplete(callback)
				promise:complete()

				assert.stub(callback).was_called()
			end
		)
		it(
			"onComplete AfterComplete ExecutesCallbackImmediately",
			function()
				local promise = Promise:new()
				local callback = stub.new()

				promise:complete()
				promise:onComplete(callback)

				assert.stub(callback).was_called()
			end
		)
		it(
			"await BeforeComplete PausesCoroutine",
			function()
				local promise = Promise:new()

				local co =
					Utils.executeAsCoroutine(
					function()
						promise:await()
					end
				)

				local status = coroutine.status(co)
				assert.are_equal(status, "suspended")
			end
		)
		it(
			"await BeforeComplete ResumesCoroutineWhenPromiseCompletes",
			function()
				local promise = Promise:new()

				local co =
					Utils.executeAsCoroutine(
					function()
						promise:await()
					end
				)
				promise:complete()

				local status = coroutine.status(co)
				assert.are_equal(status, "dead")
			end
		)
		it(
			"await AfterComplete DoesNotPauseCoroutine",
			function()
				local promise = Promise:new()

				promise:complete()
				local co =
					Utils.executeAsCoroutine(
					function()
						promise:await()
					end
				)

				local status = coroutine.status(co)
				assert.are_equal(status, "dead")
			end
		)
		it(
			"onComplete BeforeCompleteWithParameters RepassesParametersToCallback",
			function()
				local promise = Promise:new()
				local callback = stub.new()

				promise:onComplete(callback)
				promise:complete("banana", true, 2)

				assert.stub(callback).was_called_with("banana", true, 2)
			end
		)
		it(
			"onComplete AfterCompleteWithParameters RepassesParametersToCallback",
			function()
				local promise = Promise:new()
				local callback = stub.new()

				promise:complete("banana", true, 2)
				promise:onComplete(callback)

				assert.stub(callback).was_called_with("banana", true, 2)
			end
		)
		it(
			"await BeforeCompleteWithParameters ReturnsParametersToCallback",
			function()
				local promise = Promise:new()

				local param1, param2, param3
				Utils.executeAsCoroutine(
					function()
						param1, param2, param3 = promise:await()
					end
				)
				promise:complete("banana", true, 2)

				assert.are_equal(param1, "banana")
				assert.are_equal(param2, true)
				assert.are_equal(param3, 2)
			end
		)
		it(
			"await AfterCompleteWithParameters ReturnsParametersToCallback",
			function()
				local promise = Promise:new()

				promise:complete("banana", true, 2)
				local param1, param2, param3
				Utils.executeAsCoroutine(
					function()
						param1, param2, param3 = promise:await()
					end
				)

				assert.are_equal(param1, "banana")
				assert.are_equal(param2, true)
				assert.are_equal(param3, 2)
			end
		)
	end
)
