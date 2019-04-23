insulate(
    "#magicMock",
    function()
        local mock
        setup(
            function()
                require("Utils.Tests")
            end
        )
        before_each(
            function()
                mock = magicMock()
            end
        )
        it(
            "should return same thing if calling with the same parameters",
            function()
                assert.are_equal(mock.method(), mock.method())
                assert.are_equal(mock.method(1), mock.method(1))
            end
        )
        it(
            "should return different things if calling with different parameters",
            function()
                assert.are_not_equal(mock.method(1), mock.method(2))
                assert.are_not_equal(mock.method(1, 1), mock.method(1))
            end
        )
        it(
            "should return correctly when setup with __return",
            function()
                mock.method.__return("potato")

                assert.are_equal(mock.method(), "potato")
                assert.are_equal(mock.method(1, 2, 3), "potato")
            end
        )
        it(
            "should return correctly when setup with __with and __return",
            function()
                mock.method.__with(1, 2).__return("potato")

                assert.are_equal(mock.method(1, 2), "potato")
                assert.are_not_equal(mock.method(), "potato")
            end
        )
        it(
            "identical tables are considered the same parameter",
            function()
                assert.are_equal(
                    mock.method(
                        {
                            apple = true,
                            orange = 3
                        }
                    ),
                    mock.method(
                        {
                            apple = true,
                            orange = 3
                        }
                    )
                )
            end
        )
        it(
            "identical tables are considered the same parameter in __with",
            function()
                mock.method.__with(
                    {
                        apple = true,
                        orange = 3
                    }
                ).__return("potato")

                assert.are_equal(
                    mock.method(
                        {
                            apple = true,
                            orange = 3
                        }
                    ),
                    "potato"
                )
            end
        )
    end
)
