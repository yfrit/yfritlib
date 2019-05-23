local Class = require("Class")
local sqlite3 = require("lsqlite3complete")

local DatabaseConnection =
    Class.new(
    {},
    function(self, path)
        self.database = sqlite3.open(path)
    end
)

function DatabaseConnection:query(command, ...)
    command = string.format(command, ...)

    local rows = {}
    for row in self.database:nrows(command) do
        rows[#rows + 1] = row
    end

    return rows
end

return DatabaseConnection
