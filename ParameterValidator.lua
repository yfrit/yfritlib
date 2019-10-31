local Class = require("YfritLib.Class")

local ParameterValidator = {}

function ParameterValidator.validate(value, expectedType, name)
	local errorMessage =
		string.format(
		"Invalid type for parameter '%s'. Expected '%s' but received '%s'.",
		name,
		tostring(expectedType),
		tostring(value)
	)
	assert(Class.isInstanceOf(value, expectedType), errorMessage)
end

return ParameterValidator
