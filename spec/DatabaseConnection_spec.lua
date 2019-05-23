require("Tests")

insulate(
    "#DatabaseConnection",
    function()
        local DatabaseConnection
        setup(
            function()
                DatabaseConnection = require("DatabaseConnection")
            end
        )
        it(
            "query returns a table with resulting rows",
            function()
                local connection = DatabaseConnection:new()

                local rows = connection:query("select * from NATION where nation_name='%s'", "Brasil")

                assert.is_equal(rows[1].nation_name, "Brasil")
            end
        )
    end
)
