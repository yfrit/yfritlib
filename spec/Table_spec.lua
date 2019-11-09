require("LocalRockInit")

insulate(
	"#Table",
	function()
		local Table
		setup(
			function()
				Table = require("Table")
			end
		)
		it(
			"append TwoTables ReturnsANewTable",
			function()
				local t1 = {}
				local t2 = {}

				local t3 = Table.append(t1, t2)

				assert.are_not_equal(t1, t3)
				assert.are_not_equal(t2, t3)
			end
		)
		it(
			"append TwoTables JoinsTablesContents",
			function()
				local t1 = {1, true}
				local t2 = {3, "potato"}

				local t3 = Table.append(t1, t2)

				local expectedTable = {1, true, 3, "potato"}
				assert.are_same(expectedTable, t3)
			end
		)
	end
)
