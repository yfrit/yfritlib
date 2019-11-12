--[[
  Contains useful functions for manipulating tables.
--]]
local Table = {}

function Table.append(t1, t2)
	local newTable = {}

	for _, value in ipairs(t1) do
		newTable[#newTable + 1] = value
	end
	for _, value in ipairs(t2) do
		newTable[#newTable + 1] = value
	end

	return newTable
end

-- TODO write tests for this
function Table.shallowCopy(t)
	local tCopy = {}
	for i, v in pairs(t) do
		tCopy[i] = v
	end
	return tCopy
end

return Table
