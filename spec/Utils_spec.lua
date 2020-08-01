require("LocalRockInit")

insulate(
    "#Utils",
    function()
        setup(
            function()
                require("Utils")
            end
        )

        it(
            "math.round CloserToZero RoundsDown",
            function()
                local rounded = math.round(0.4)

                assert.are_equal(0, rounded)
            end
        )
        it(
            "math.round CloserToOne RoundsUp",
            function()
                local rounded = math.round(0.6)

                assert.are_equal(1, rounded)
            end
        )

        it(
            "math.round CloserToZero RoundsUp",
            function()
                local rounded = math.round(-0.4)

                assert.are_equal(0, rounded)
            end
        )
        it(
            "math.round CloserToMinusOne RoundsDown",
            function()
                local rounded = math.round(-0.6)

                assert.are_equal(-1, rounded)
            end
        )
    end
)
