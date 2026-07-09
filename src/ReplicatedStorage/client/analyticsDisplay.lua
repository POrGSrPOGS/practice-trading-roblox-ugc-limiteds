local analyticsDisplay = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
local client = replicatedStorage.client

local analyticsHelpers = require(client.analyticsHelpers)

local players = game:GetService("Players")
local player = players.LocalPlayer

local playerGui = player.PlayerGui
local shopGui = playerGui:WaitForChild("shopGui")

local analyticsFrame = shopGui.frame.analytics


local function setValue(name: string, value: string)

    value = value or ""

	local frame = analyticsFrame:FindFirstChild(name)

	if not frame then
		warn(name .. " not found in analytics frame")
		return
	end
    

	frame.value.Text = value
end

local function clearAnalyticsFields()
    setValue(
		"assetName"
	)

	setValue(
		"price"
	)

	setValue(
		"deal"
	)

	setValue(
		"stock"
	)

	setValue(
		"created"
	)

	setValue(
		"rap"
	)

	setValue(
		"sevenDayRAP"
	)

	setValue(
		"thirtyDayRAP"
	)

	setValue(
		"allTimeRAP"
	)

	setValue(
		"sevenDayDemand"
	)

	setValue(
        "thirtyDayDemand"
    )

    setValue(
        "originalPrice"
    )
    
end

function analyticsDisplay.showLoadingScreen()
    clearAnalyticsFields()
    analyticsFrame.Visible = true

	local loadingFrame = analyticsFrame.loading
	loadingFrame.Visible = true
end

function analyticsDisplay.hideLoadingScreen()
	local loadingFrame = analyticsFrame.loading
	loadingFrame.Visible = false
end

function analyticsDisplay.show(analytics : analyticsHelpers.analyticsType)
	setValue(
		"assetName",
		analyticsHelpers.getDisplayName(analytics)
	)

	setValue(
		"price",
		analyticsHelpers.getDisplayPrice(analytics)
	)

	setValue(
		"deal",
		analyticsHelpers.getDisplayDeal(analytics)
	)

	setValue(
		"stock",
		analyticsHelpers.getDisplayStock(analytics)
	)

	setValue(
		"created",
		analyticsHelpers.getDisplayCreatedDate(analytics)
	)

	setValue(
		"rap",
		analyticsHelpers.getDisplayRAP(analytics)
	)

	setValue(
		"sevenDayRAP",
		analyticsHelpers.getDisplaySevenDayRAPGrowth(analytics)
	)

	setValue(
		"thirtyDayRAP",
		analyticsHelpers.getDisplayThirtyDayRAPGrowth(analytics)
	)

	setValue(
		"allTimeRAP",
		analyticsHelpers.getDisplayAllTimeRAPGrowth(analytics)
	)

	setValue(
		"sevenDayDemand",
		analyticsHelpers.getDisplaySevenDayDemand(analytics)
	)

	setValue(
		"thirtyDayDemand",
		analyticsHelpers.getDisplayThirtyDayDemand(analytics)
	)

    setValue(
        "originalPrice",
        analyticsHelpers.getDisplayOriginalPrice(analytics)
    )
end


function analyticsDisplay.hide()
	analyticsFrame.Visible = false
end


return analyticsDisplay