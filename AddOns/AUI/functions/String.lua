AUI.String = {}

function AUI.String.FormatName(str)
	local newStr = string.char()

	if AUI.String.IsEmpty(str) then
		return newStr
	end

	for i = 1, string.len(str) do
		local char = string.char(string.byte(str, i))
		
		if char ~= "^" then
			newStr = newStr .. char
		else
			break
		end
	end
	
    return newStr
end

function AUI.String.IsEmpty(str)
	return str == nil or str == string.char()
end

function AUI.String.ToFormatedNumber(value)
	return ZO_CommaDelimitNumber(value)
end

function AUI.String.ToNumber(_s)
	local length = string.len(_s)
	local n = nil
	for i = 1, length do
		local int = string.byte(_s, i)
	
		if not n then
			n = int
		else
			n = n + int		
		end
	end

	return n
end

function AUI.String.FirstToUpper(str)
    return zo_strformat("<<C:1>>", AUI.String.FormatName(str))  
end

function AUI.String.GetPercentString(value1, value2)
	local percent = value2 / value1 * 100
	
	return AUI.String.ToFormatedNumber(AUI.Math.Round(percent, 1)) .. "%"
end