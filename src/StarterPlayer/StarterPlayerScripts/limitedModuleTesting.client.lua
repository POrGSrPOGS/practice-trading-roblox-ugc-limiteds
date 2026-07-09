local replicatedStorage = game:GetService("ReplicatedStorage")
local client = replicatedStorage.client

local collectiblesService = require(client.collectiblesService)
local shop = require(client.shop)

local collectibles = collectiblesService.getCollectibles()

local ugcs = collectiblesService.getUGCs(collectibles)

for i = 1, 200 do
	local selectedUGC = ugcs[i]
	if not selectedUGC then break end

	shop.addAsset(selectedUGC)
end

