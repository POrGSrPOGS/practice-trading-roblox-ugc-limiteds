local assetCard = {}
assetCard.__index = assetCard

local replicatedStorage = game:GetService("ReplicatedStorage")
local remotes = replicatedStorage.remotes
local ui = replicatedStorage.ui

local players = game:GetService("Players")
local player = players.LocalPlayer
local playerGui = player.PlayerGui
local shopGui = playerGui:WaitForChild("shopGui")
local shopFrame = shopGui:WaitForChild("frame")
local shopScrollingFrame = shopFrame:WaitForChild("scrollingFrame")
local assetTemplate = shopScrollingFrame:WaitForChild("assetTemplate")
local analyticsFrame = shopFrame:WaitForChild("analytics")

assetTemplate.Parent = ui
analyticsFrame.Visible = false

local MAX_NAME_LENGTH = 24

local rapFailed = false
local RAP_FAIL_COOLDOWN = 60 -- Seconds

local currentlyAnalysedAsset = nil -- The id of the asset which is having it's analytics viewed

--[[
	Analytics:
	
	{
  "status": "ok",
  "source": "fresh",
  "itemId": "12803855954",
  "assetId": "12803855954",
  "name": "Glossy Red Baseball Cap",
  "itemType": "Hat",
  "creatorName": null,
  "creatorUrl": null,
  "saleStatus": "For Sale",
  "saleLocation": "Everywhere",
  "purchaseLimit": "None",
  "isCollectible": true,
  "currentRAP": 105,
  "bestPrice": 105,
  "originalPrice": null,
  "favorites": 69220,
  "unitsAvailable": 9544128,
  "totalQuantity": 10000000,
  "createdTsMs": 1678992368000,
  "updatedTsMs": 1679006106000,
  "wentLimitedTsMs": 1679006100000,
  "rapHistory": [[1686614400000, 73], [1686643200000, 75], ...],
  "avgDailySalesPrice": [[ts, price], ...],
  "dailySalesVolume": [[ts, count], ...],
  "lowestPriceHistory": [[ts, price], ...],
  "favoritesHistory": [[ts, count], ...],
  "unitsSoldHistory": [[ts, count], ...],
  "priceHistory": [],
  "fetchedAtMs": 1783363461313
}

]]

function assetCard.new(item)
	local self = setmetatable({}, assetCard)

	self.card = assetTemplate:Clone()
	self.card.Parent = shopScrollingFrame
	self.itemDetails = item
	

	self:setName()
	self:setImage()
	self:setPrice()
	self:linkInvestButton()
	self:linkAnalyticsButton()
	
	return self
end

function assetCard:remove()
	self.card:Destroy()
	self.card = nil
	self.itemDetails = nil
	self.analytics = nil
end

function assetCard:linkInvestButton()
	local button = self.card.invest
	button.MouseButton1Click:Connect(function()
		local marketplaceService = game:GetService("MarketplaceService")
		marketplaceService:PromptPurchase(game.Players.LocalPlayer, self.itemDetails.Id)
		remotes.invest:FireServer(self.itemDetails.Id)
	end)
end

function assetCard:linkAnalyticsButton()
	local button = self.card.viewAnalytics
	button.MouseButton1Click:Connect(function()
		
		if currentlyAnalysedAsset == self.itemDetails.Id then -- Clicked view analytics on the same asset again
			analyticsFrame.Visible = false
			currentlyAnalysedAsset = nil
			return
		end
		
		currentlyAnalysedAsset = self.itemDetails.Id
		analyticsFrame.Visible = true
		self:getAnalytics()
		self:displayAnalytics()
		
	end)
end

function assetCard:getPrice()
	local price = self.itemDetails.LowestPrice or self.itemDetails.Price or 0
	return price
end

function assetCard:getName()
	local name = self.itemDetails.Name or "Unknown"
	return name
end

function assetCard:getRAP()
	local rap = self.analytics.currentRAP or 0
	return rap
end

function assetCard:displayAnalytics()
	local analytics = self.analytics
end

local function setAnalyticsValue(frameName, value)
	local frame = analyticsFrame:FindFirstChild(frameName)
	if not frame then return end
	
	frame.value.Text = value
end

function assetCard:setAnalyticsName()
	local name = self:getName()
	setAnalyticsValue("assetName", name)
end

function assetCard:setAnalyticsPrice()
	local price = self:getPrice()
	
	setAnalyticsValue("assetPrice", price)
end

function assetCard:setAnalyticsDeal()
	local price = self:getPrice()
	local rap = self:getRAP()
	
end

function assetCard:getAnalytics()
	local analytics = self.analytics or remotes.getAnalytics:InvokeServer({self.itemDetails.Id})
	self.analytics = analytics
end

function assetCard:setName()
	local name = self:getName()
	
	self.card.assetName.Text = name
end

function assetCard:setImage()
	local id = self.itemDetails.Id
	local image = "rbxthumb://type=Asset&id="..id.."&w=150&h=150"

	self.card.assetIcon.Image = image
end

function assetCard:setPrice()
	local price = self:getPrice()
	
	self.card.assetPrice.Text = "Price: " .. price .. " R$"
end

return assetCard