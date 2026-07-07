local rolimons = {}
rolimons.__index = rolimons

local httpService = game:GetService("HttpService")

local function getItems()
	local response = httpService:GetAsync("https://www.rolimons.com/itemapi/itemdetails")
	local data = httpService:JSONDecode(response)
	local items = data.items
	
	return items
end

function rolimons.getItemDetails(id)
	local items = getItems()
	local itemDetails = items[id]
	
	local self = setmetatable(itemDetails, rolimons)
	
	return self
end

function rolimons:getItemRAP()
	local rap = self[3]
	
	return rap
end

function rolimons:getItemDemand()
	local name = self[6]
	
	return name
end

function rolimons:getItemTrend()
	local trend = self[7]
	
	return trend
end


return rolimons
