local format = {}

function format.number(n: number): string
	local sign = ""

	if n < 0 then
		sign = "-"
		n = -n
	end

	local integer, decimal = math.modf(n)

	local formatted = tostring(integer)
	formatted = formatted:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")

	if decimal ~= 0 then
		local decimalString = tostring(decimal):sub(3) -- remove "0."
		return sign .. formatted .. "." .. decimalString
	end

	return sign .. formatted
end

function format.robux(n: number): string
	return format.number(n) .. " R$"
end

function format.tokens(n : number): string
    return format.number(n) .. " T$"
end

function format.percentage(decimal : number): string
    local percentage = math.round(decimal * 100) 
    local percentage = format.number(percentage)
	return percentage .. "%"
end

function format.percentageChange(oldDecimal : number, newDecimal : number) : string

    local decimalChange = (newDecimal - oldDecimal) / oldDecimal
    local percentageChange = format.percentage(decimalChange)

    return percentageChange
end

return format