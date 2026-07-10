local shopDisplay = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
local client = replicatedStorage.client

local collectiblesHelpers = require(client.collectiblesHelpers)
local shopHelpers = require(client.shopHelpers)

local itemHelpers = require(client.itemHelpers)

function shopDisplay.displayUGCs(ugcs : itemHelpers.itemsType)
    for _, ugc in ugcs do
        shopHelpers.addAsset(ugc)
    end
end

function shopDisplay.initialise()
    local pages = collectiblesHelpers.searchCollectibles()

    while true do
        local ugcs = collectiblesHelpers.loadUGCs(pages)
        if not ugcs then break end

        shopDisplay.displayUGCs(ugcs)
    end

end

return shopDisplay