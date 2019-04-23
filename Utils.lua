local Utils = {}

function Utils.isCallable(f)
	local metatable = getmetatable(f)
	return type(f) == "function" or (metatable and metatable.__call)
end

function Utils.shuffleTable(t)
	for i = 1, #t do
		local j = math.random(i, #t)
		t[i], t[j] = t[j], t[i]
	end
end

local function tostring2(elem)
	if type(elem) == "string" then
		return "'" .. elem .. "'"
	else
		return tostring(elem)
	end
end

function Utils.printTable(elem, hist, tabs)
	hist = hist or {}
	tabs = tabs or 0
	if type(elem) ~= "table" then
		print(tostring2(elem))
	else
		if not hist[elem] then
			hist[elem] = true
			print(tostring2(elem) .. " {")
			tabs = tabs + 1
			for i, e in pairs(elem) do
				io.write(string.rep("\t", tabs) .. "[" .. tostring2(i) .. "] ")
				printR(e, hist, tabs)
			end
			tabs = tabs - 1
			print(string.rep("\t", tabs) .. "}")
		else
			print(tostring2(elem) .. " {...}")
		end
	end
end
_G.printR = Utils.printTable

function Utils.areEqual(object1, object2)
	--TODO cache in a weak table to prevent cycles

	--if some of the two objects is not a table, just do a simple comparison
	if type(object1) ~= "table" or type(object2) ~= "table" then
		return object1 == object2
	end

	--otherwise, compare two tables recursively
	if object1 == object2 then
		--if they are actually the same table, don't waste time comparing and just return true
		return true
	end

	--check if all attributes of object1 are in object2
	for key, value in pairs(object1) do
		if not Utils.areEqual(object2[key], value) then
			return false
		end
	end

	--check if all attributes of object2 are in object1
	for key, value in pairs(object2) do
		if not Utils.areEqual(object1[key], value) then
			return false
		end
	end

	return true
end

return Utils
