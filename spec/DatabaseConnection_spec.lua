require("Tests")

insulate(
    "#DatabaseConnection",
    function()
        local DatabaseConnection
        setup(
            function()
                local function brasilIterator()
                    local i = 0
                    return function()
                        i = i + 1
                        if i == 1 then
                            return {
                                nation_name = "Brasil"
                            }
                        end
                        return nil
                    end
                end

                local database = {}
                stub(database, "nrows")
                database.nrows.on_call_with(database, "select * from NATION where nation_name='Brasil'").returns(
                    brasilIterator()
                )

                local sqlite3 = {}
                mockRequire("lsqlite3complete", sqlite3)
                stub(sqlite3, "open")
                sqlite3.open.on_call_with("database.db").returns(database)

                DatabaseConnection = require("DatabaseConnection")
            end
        )
        it(
            "query returns a table with resulting rows",
            function()
                local connection = DatabaseConnection:new("database.db")

                local rows = connection:query("select * from NATION where nation_name='%s'", "Brasil")

                assert.is_equal(rows[1].nation_name, "Brasil")
            end
        )
    end
)
