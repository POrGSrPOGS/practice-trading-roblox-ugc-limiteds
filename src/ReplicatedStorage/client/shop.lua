local shop = {}
local assetCards = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
local client = replicatedStorage.client
local assetCard = require(client.assetCard)
local itemHelpers = require(client.itemHelpers)



function shop.addAsset(item : itemHelpers.itemType)
	local card = assetCard.new(item)
	local id = itemHelpers.getID(item)

	assetCards[id] = card
end

function shop.removeAsset(id : number)
	local card = assetCards[id]
	if not card then return end

	card:remove()
	assetCards[id] = nil
end

return shop
