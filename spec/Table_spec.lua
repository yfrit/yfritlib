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
        before_each(
            function()
                stub(math, "random")
            end
        )
        after_each(
            function()
                math.random:revert()
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
            "map TableAndString UsesStringAsMethod",
            function()
                local function createObject(value)
                    local self = {
                        value = value
                    }

                    function self:getValue()
                        return self.value
                    end

                    return self
                end
                local t = {createObject(5), createObject(10), createObject(15)}

                local t2 = Table.map(t, "getValue")

                assert.are_same({5, 10, 15}, t2)
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

        it(
            "setToArray Set ReturnsArray",
            function()
                local t = {
                    potato = true,
                    banana = true,
                    apple = true
                }

                local array = Table.setToArray(t)

                assert.are_same({"apple", "potato", "banana"}, array)
            end
        )

        it(
            "random RandomReturns1 ReturnsFirstElement",
            function()
                local t = {"first", "second"}
                math.random.returns(1)

                local element = Table.random(t)

                assert.is_equal(element, "first")
            end
        )
        it(
            "random RandomReturns2 ReturnsSecondElement",
            function()
                local t = {"first", "second"}
                math.random.returns(2)

                local element = Table.random(t)

                assert.is_equal(element, "second")
            end
        )

        it(
            "generateSets EmptyArray ReturnsArrayWithSingleEmptyTable",
            function()
                local elements = {}

                local sets = Table.generateSets(elements)

                assert.are_equal(1, #sets)
                assert.are_same({}, sets[1])
            end
        )
        it(
            "generateSets NonEmptyArray ReturnsArrayWithAllPossibleSets",
            function()
                local elements = {"a", "b", "c"}

                local sets = Table.generateSets(elements)

                assert.are_equal(2 ^ 3, #sets)
                assert.are_same({}, sets[1])
                assert.are_same({a = true}, sets[2])
                assert.are_same({b = true}, sets[3])
                assert.are_same({a = true, b = true}, sets[4])
                assert.are_same({c = true}, sets[5])
                assert.are_same({a = true, c = true}, sets[6])
                assert.are_same({b = true, c = true}, sets[7])
                assert.are_same({a = true, b = true, c = true}, sets[8])
            end
        )
        it(
            "generateSets NonEmptyArray DoesNotMofifyTheOriginalArray",
            function()
                local elements = {"a", "b", "c"}

                Table.generateSets(elements)

                assert.are_same({"a", "b", "c"}, elements)
            end
        )

        it(
            "generatePermutations EmptyArray ReturnsArrayWithSinglePermutation",
            function()
                local elements = {}

                local permutations = Table.generatePermutations(elements)

                assert.are_equal(1, #permutations)
                assert.are_same({}, permutations[1])
            end
        )
        it(
            "generatePermutations ArrayWithSingleElement ReturnsArrayWithSinglePermutation",
            function()
                local elements = {"a"}

                local permutations = Table.generatePermutations(elements)

                assert.are_equal(1, #permutations)
                assert.are_same({"a"}, permutations[1])
            end
        )
        it(
            "generatePermutations ArrayWithMultipleElements ReturnsArrayWithAllPermutations",
            function()
                local elements = {"a", "b", "c"}

                local permutations = Table.generatePermutations(elements)

                assert.are_equal(6, #permutations)
                assert.are_same({"a", "b", "c"}, permutations[1])
                assert.are_same({"b", "a", "c"}, permutations[2])
                assert.are_same({"c", "b", "a"}, permutations[3])
                assert.are_same({"a", "c", "b"}, permutations[4])
                assert.are_same({"c", "a", "b"}, permutations[5])
                assert.are_same({"b", "c", "a"}, permutations[6])
            end
        )
        it(
            "generateSets NonEmptyArray DoesNotMofifyTheOriginalArray",
            function()
                local elements = {"a", "b", "c"}

                Table.generatePermutations(elements)

                assert.are_same({"a", "b", "c"}, elements)
            end
        )

        it(
            "isSubTableOf IsSub ReturnsTrue",
            function()
                local t1 = {"a", "b"}
                local t2 = {"a", "b", "c"}

                local isSubTable = Table.isSubTableOf(t1, t2)

                assert.is_true(isSubTable)
            end
        )
        it(
            "isSubTableOf Reversed ReturnsFalse",
            function()
                local t1 = {"a", "b", "c"}
                local t2 = {"a", "b"}

                local isSubTable = Table.isSubTableOf(t1, t2)

                assert.is_false(isSubTable)
            end
        )
        it(
            "isSubTableOf TotallyDifferent ReturnsFalse",
            function()
                local t1 = {"a", "b"}
                local t2 = {"c", "d"}

                local isSubTable = Table.isSubTableOf(t1, t2)

                assert.is_false(isSubTable)
            end
        )

        local function sortFunction(x, y)
            return x < y
        end
        it(
            "sortAndFilter NormalTable SortsAndReturnsOnlyFirstValues",
            function()
                local t = {"a", "b", "c", "a", "b", "c"}

                local newTable = Table.sortAndFilter(t, sortFunction)

                assert.are_same({"a", "a"}, newTable)
            end
        )
        it(
            "sortAndFilter SingleElementTable ReturnsTableWithFirstValue",
            function()
                local t = {"a"}

                local newTable = Table.sortAndFilter(t, sortFunction)

                assert.are_same({"a"}, newTable)
            end
        )
        it(
            "sortAndFilter EmptyTable ReturnsEmptyTable",
            function()
                local t = {}

                local newTable = Table.sortAndFilter(t, sortFunction)

                assert.are_same({}, newTable)
            end
        )

        it(
            "merge TwoDifferentTables ReturnsMergedTable",
            function()
                local t1 = {
                    potato = 1
                }
                local t2 = {
                    apple = 2
                }

                local result = Table.merge(t1, t2)

                assert.is_same(
                    {
                        potato = 1,
                        apple = 2
                    },
                    result
                )
            end
        )
        it(
            "merge ThreeDifferentTables ReturnsMergedTable",
            function()
                local t1 = {
                    potato = 1
                }
                local t2 = {
                    apple = 2
                }
                local t3 = {
                    chocolate = 3
                }

                local result = Table.merge(t1, t2, t3)

                assert.is_same(
                    {
                        potato = 1,
                        apple = 2,
                        chocolate = 3
                    },
                    result
                )
            end
        )
    end
)

insulate(
    "#Table #intergration",
    function()
        local Table
        setup(
            function()
                Table = require("Table")
            end
        )

        it(
            "random TableIsEmpty ReturnsNil",
            function()
                local value = Table.random({})

                assert.is_nil(value)
            end
        )
    end
)
