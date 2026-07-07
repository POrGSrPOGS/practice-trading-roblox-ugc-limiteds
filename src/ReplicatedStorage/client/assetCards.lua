local assetCards = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
local remotes = replicatedStorage.remotes

local players = game:GetService("Players")
local player = players.LocalPlayer
local playerGui = player.PlayerGui
local shopGui = playerGui:WaitForChild("shopGui")
local shopFrame = shopGui:WaitForChild("frame")
local shopScrollingFrame = shopFrame:WaitForChild("scrollingFrame")
local uiGridLayout = shopScrollingFrame:WaitForChild("UIGridLayout")


local client = replicatedStorage.client
local assetCard = require(client.assetCard)

local DISPLAY_DELAY = 0.05
local RAP_BATCH_SIZE = 6

local function sizeScrollingFrame(numberOfAssets)
	local height = uiGridLayout.CellSize.Y.Scale
	local padding = uiGridLayout.CellPadding.Y.Scale
	local totalHeight = (height + padding) * numberOfAssets
	shopScrollingFrame.CanvasSize = UDim2.new(shopScrollingFrame.CanvasSize.X.Scale, 0, totalHeight, 0)
end

function assetCards.loadAssets(assets)

	sizeScrollingFrame(#assets)

	task.spawn(function()
		for assetNumber, asset in assets do
			assetCard.new(asset)
			task.wait(DISPLAY_DELAY)
		end
	end)

end

return assetCards
