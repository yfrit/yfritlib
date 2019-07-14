--get rockspecs file
local file = io.open("yfritlib-scm-1.rockspec")
local code = file:read("*a")
file:close()

--turn its globals into a table, to prevent side-effects
code = code:gsub('"\n', '",\n')
code = code:gsub('}\n', '},\n')
code = string.format([[
    return {
        %s
    }
]], code)

--get the builds.modules table
local modules = loadstring(code)().build.modules

--iterate it to get full and local paths
local overrides = {}
for fullPath, localPath in pairs(modules) do
    overrides[fullPath] = localPath:gsub(".lua", "")
end

--override require to return local files
local oldRequire = _G.require
function _G.require(path, ...)
    path = overrides[path] or path
    return oldRequire(path, ...)
end