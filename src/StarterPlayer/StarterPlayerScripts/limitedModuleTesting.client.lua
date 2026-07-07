local replicatedStorage = game:GetService("ReplicatedStorage")
local client = replicatedStorage.client

local collectiblesService = require(client.collectiblesService)
local assetCards = require(client.assetCards)

local collectibles = collectiblesService.getCollectibles()

local ugcs = collectiblesService.getUGCs(collectibles)

local selectedUGCs = {}

for i = 1, 200 do
	local selectedUGC = ugcs[i]
	
	if not selectedUGC then break end
	table.insert(selectedUGCs, selectedUGC)
end

assetCards.loadAssets(selectedUGCs)
