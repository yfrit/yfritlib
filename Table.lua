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

return Table
