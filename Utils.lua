local Utils = {}

function Utils.shuffleTable(t)
	for i=1,#t do
		local j = math.random(i, #t)
		t[i],t[j] = t[j],t[i]
	end
end

local function tostring2(elem)
	if type(elem)=='string' then
		return "'" .. elem .. "'"
	else
		return tostring(elem)
	end
end

function Utils.printTable(elem, hist, tabs)
	hist = hist or {}
	tabs = tabs or 0
	if type(elem)~='table' then
		print(tostring2(elem))
	else
		if not hist[elem] then
			hist[elem] = true
			print(tostring2(elem) .. ' {')
			tabs = tabs + 1
			for i,e in pairs(elem) do
				io.write(string.rep('\t', tabs) .. '[' .. tostring2(i) .. '] ')
				printR(e, hist, tabs)
			end
			tabs = tabs - 1
			print(string.rep('\t', tabs) .. '}')
		else
			print(tostring2(elem) .. ' {...}')
		end
	end
end
_G.printR = Utils.printTable

return Utils