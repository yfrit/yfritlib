package = "YfritLib"
version = "scm-1"
source = {
   url = "git+https://github.com/yfrit/yfritlib.git"
}
description = {
   homepage = "https://github.com/yfrit/yfritlib",
   license = "MIT <http://opensource.org/licenses/MIT>"
}
dependencies = {
   "lua ~> 5.1",
   "lsqlite3complete >= 0.9.5-1"
}
build = {
   type = "builtin",
   modules = {
      ["YfritLib.Class"] = "Class.lua",
      ["YfritLib.DatabaseConnection"] = "DatabaseConnection.lua",
      ["YfritLib.Tests"] = "Tests.lua",
      ["YfritLib.Utils"] = "Utils.lua",
   }
}
