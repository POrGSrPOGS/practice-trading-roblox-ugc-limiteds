local assetCard = {}
assetCard.__index = assetCard

local replicatedStorage = game:GetService("ReplicatedStorage")
local remotes = replicatedStorage.remotes
local ui = replicatedStorage.ui

local client = replicatedStorage.client
local analyticsDisplay = require(client.analyticsDisplay)

local players = game:GetService("Players")
local player = players.LocalPlayer
local playerGui = player.PlayerGui

local shopGui = playerGui:WaitForChild("shopGui")
local shopFrame = shopGui:WaitForChild("frame")
local exploreFrame = shopFrame:WaitForChild("explore")
local shopScrollingFrame = exploreFrame:WaitForChild("scrollingFrame")
local analyticsFrame = shopFrame:WaitForChild("analytics")

local assetTemplate = shopScrollingFrame:WaitForChild("assetTemplate")

assetTemplate.Parent = ui
analyticsFrame.Visible = false

local currentlyAnalysedAsset = nil

local MAX_NAME_LENGTH = 15


local function createCard()
	local card = assetTemplate:Clone()
	card.Name = "asset"
	card.Parent = shopScrollingFrame

	return card
end


function assetCard.new(item)
	local self = setmetatable({}, assetCard)

	self.card = createCard()
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

		marketplaceService:PromptPurchase(
			players.LocalPlayer,
			self.itemDetails.Id
		)

		remotes.invest:FireServer(self.itemDetails.Id)
	end)
end


function assetCard:linkAnalyticsButton()
	local button = self.card.viewAnalytics

	button.MouseButton1Click:Connect(function()

		if currentlyAnalysedAsset == self.itemDetails.Id then
			analyticsDisplay.hide()

			currentlyAnalysedAsset = nil
			return
		end


		currentlyAnalysedAsset = self.itemDetails.Id

		analyticsDisplay.startLoadingScreen()

		local analytics = self:getAnalytics()

		analyticsDisplay.show(analytics)

		analyticsDisplay.stopLoadingScreen()
	end)
end


function assetCard:getPrice()
	return self.itemDetails.LowestPrice
		or self.itemDetails.Price
		or 0
end


function assetCard:getName()
	local name = self.itemDetails.Name
	local shortened = string.sub(name, 1, MAX_NAME_LENGTH)

	if shortened ~= name then
		shortened = shortened .. "..."
	end

	return shortened
end


function assetCard:getAnalytics()
	if not self.analytics then
		self.analytics = remotes.getAnalytics:InvokeServer({
			self.itemDetails.Id
		})[1]
	end

	return self.analytics
end


function assetCard:setName()
	self.card.assetName.Text = self:getName()
end


function assetCard:setImage()
	local id = self.itemDetails.Id

	self.card.assetIcon.Image =
		"rbxthumb://type=Asset&id=" .. id .. "&w=150&h=150"
end


function assetCard:setPrice()
	self.card.assetPrice.Text =
		"Price: " .. self:getPrice() .. " R$"
end


return assetCard