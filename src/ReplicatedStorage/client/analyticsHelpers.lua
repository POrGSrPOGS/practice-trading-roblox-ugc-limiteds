local analyticsHelpers = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
local client = replicatedStorage.client
local format = require(client.format)


export type historyPointType = {
	number
}


export type analyticsType = {
	status: string,
	source: string,

	itemId: string,
	assetId: string,

	name: string,
	itemType: string,

	creatorName: string?,
	creatorUrl: string?,

	saleStatus: string,
	saleLocation: string,
	purchaseLimit: string,

	isCollectible: boolean,

	currentRAP: number,
	bestPrice: number,

	originalPrice: number?,

	favorites: number,

	unitsAvailable: number,
	totalQuantity: number,

	createdTsMs: number,
	updatedTsMs: number,
	wentLimitedTsMs: number,

	rapHistory: {historyPointType},
	avgDailySalesPrice: {historyPointType},
	dailySalesVolume: {historyPointType},
	lowestPriceHistory: {historyPointType},
	favoritesHistory: {historyPointType},
	unitsSoldHistory: {historyPointType},
	priceHistory: {historyPointType},

	fetchedAtMs: number,
}


function analyticsHelpers.getDisplayName(analytics: analyticsType): string
	return analytics.name
end


function analyticsHelpers.getDisplayPrice(analytics: analyticsType): string
	return format.robux(analytics.bestPrice)
end


function analyticsHelpers.getDisplayRAP(analytics: analyticsType): string
	return format.robux(analytics.currentRAP)
end


function analyticsHelpers.getDisplayTexture(analytics: analyticsType): string
	return "rbxthumb://type=Asset&id=" .. analytics.assetId .. "&w=150&h=150"
end


--------------------------------------------------
-- Price / Deal
--------------------------------------------------


function analyticsHelpers.getDealPercentage(
	analytics: analyticsType
): number

	local price = analytics.bestPrice

	if price == 0 then
		return 0
	end

	return (analytics.currentRAP - price) / price
end


function analyticsHelpers.getDisplayDeal(
	analytics: analyticsType
): string

	return format.percentage(
		analyticsHelpers.getDealPercentage(analytics)
	)
end


--------------------------------------------------
-- Basic information
--------------------------------------------------


function analyticsHelpers.getDisplayStock(
	analytics: analyticsType
): string

	return string.format(
		"%s / %s",
		format.number(analytics.unitsAvailable),
		format.number(analytics.totalQuantity)
	)
end


function analyticsHelpers.getDisplayCreatedDate(
	analytics: analyticsType
): string

	return os.date(
		"%d/%m/%Y",
		analytics.createdTsMs / 1000
	)
end


--------------------------------------------------
-- History helpers
--------------------------------------------------


local function getCutoff(days: number): number
	return os.time() * 1000 - (days * 86400000)
end


local function getFirstValueAfter(
	history: {historyPointType},
	timestamp: number
): number?

	local earliestTimestamp = nil
	local value = nil

	for _, point in history do
		local pointTimestamp = point[1]
		local pointValue = point[2]

		if pointTimestamp >= timestamp then

			if not earliestTimestamp
				or pointTimestamp < earliestTimestamp then

				earliestTimestamp = pointTimestamp
				value = pointValue
			end
		end
	end

	return value
end


local function getPercentageIncrease(
	oldValue: number,
	newValue: number
): number

	if oldValue == 0 then
		return 0
	end

	return (newValue - oldValue) / oldValue
end


--------------------------------------------------
-- Original price
--------------------------------------------------


function analyticsHelpers.getOriginalPrice(
	analytics: analyticsType
): number

	-- First recorded resale price
	local firstPrice = analytics.lowestPriceHistory[1]

	if firstPrice then
		return firstPrice[2]
	end


	-- Fallback to first RAP
	local firstRAP = analytics.rapHistory[1]

	if firstRAP then
		return firstRAP[2]
	end


	return analytics.currentRAP
end


function analyticsHelpers.getDisplayOriginalPrice(
	analytics: analyticsType
): string

	return format.robux(
		analyticsHelpers.getOriginalPrice(analytics)
	)
end


--------------------------------------------------
-- RAP growth
--------------------------------------------------


function analyticsHelpers.getRAPGrowth(
	analytics: analyticsType,
	days: number?
): number

	local startingRAP


	-- Historical growth
	if days then

		startingRAP = getFirstValueAfter(
			analytics.rapHistory,
			getCutoff(days)
		)

	-- All time growth
	else

		startingRAP = analyticsHelpers.getOriginalPrice(
			analytics
		)

	end


	if not startingRAP then
		return 0
	end


	return getPercentageIncrease(
		startingRAP,
		analytics.currentRAP
	)
end


function analyticsHelpers.getDisplayRAPGrowth(
	analytics: analyticsType,
	days: number?
): string

	return format.percentage(
		analyticsHelpers.getRAPGrowth(
			analytics,
			days
		)
	)
end


function analyticsHelpers.getDisplaySevenDayRAPGrowth(
	analytics: analyticsType
): string

	return analyticsHelpers.getDisplayRAPGrowth(
		analytics,
		7
	)
end


function analyticsHelpers.getDisplayThirtyDayRAPGrowth(
	analytics: analyticsType
): string

	return analyticsHelpers.getDisplayRAPGrowth(
		analytics,
		30
	)
end


function analyticsHelpers.getDisplayAllTimeRAPGrowth(
	analytics: analyticsType
): string

	return analyticsHelpers.getDisplayRAPGrowth(
		analytics
	)
end


--------------------------------------------------
-- Demand
--------------------------------------------------


local function getSalesInWindow(history, startIndex, days)
	local total = 0

	for i = startIndex, math.min(#history, startIndex + days - 1) do
		total += history[i][2]
	end

	return total
end

function analyticsHelpers.getDemandPercentage(analytics, days)
	local history = analytics.unitsSoldHistory

	if #history < days then
		return 0
	end

	local current = getSalesInWindow(history, #history - days + 1, days)

	local best = 0

	for i = 1, #history - days + 1 do
		best = math.max(best, getSalesInWindow(history, i, days))
	end

	if best == 0 then
		return 0
	end

	return current / best
end


function analyticsHelpers.getDisplayDemand(
	analytics: analyticsType,
	days: number
): string

	return format.percentage(
		analyticsHelpers.getDemandPercentage(
			analytics,
			days
		)
	)
end


function analyticsHelpers.getDisplaySevenDayDemand(
	analytics: analyticsType
): string

	return analyticsHelpers.getDisplayDemand(
		analytics,
		7
	)
end


function analyticsHelpers.getDisplayThirtyDayDemand(
	analytics: analyticsType
): string

	return analyticsHelpers.getDisplayDemand(
		analytics,
		30
	)
end


return analyticsHelpers