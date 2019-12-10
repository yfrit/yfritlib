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
        it(
            "reduce TableAndFunction ReducesTableToSingleValue",
            function()
                local t = {2, 3, 4}

                local multiplication =
                    Table.reduce(
                    t,
                    function(a, b)
                        return a * b
                    end
                )

                assert.are_equal(2 * 3 * 4, multiplication)
            end
        )
        it(
            "map TableAndFunction ReturnsTableWithMappedValues",
            function()
                local t = {5, 10, 15}

                local t2 =
                    Table.map(
                    t,
                    function(value, key)
                        return value + key
                    end
                )

                assert.are_same({1 + 5, 2 + 10, 3 + 15}, t2)
            end
        )
        it(
            "toSet Table ConvertToSet",
            function()
                local t = {"potato", "banana", "apple"}

                local set = Table.toSet(t)

                assert.are_same(
                    {
                        potato = true,
                        banana = true,
                        apple = true
                    },
                    set
                )
            end
        )
    end
)
