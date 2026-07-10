local collectiblesHelpers = {}

local avatarEditorService = game:GetService("AvatarEditorService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local client = replicatedStorage.client
local itemHelpers = require(client.itemHelpers)

export type filtersType = {
    Keyword: string,
    SortType: Enum.CatalogSortType,
}

local function isUGC(collectible : itemHelpers.itemsType) : boolean
	return collectible.CreatorName ~= "Roblox"
end

function collectiblesHelpers.getUGCs(page : itemHelpers.itemsType) : itemHelpers.itemsType
	local ugcs = {}

	for _, item in page do
		if not isUGC(item) then continue end

		table.insert(ugcs, item)
	end

	return ugcs
end

function collectiblesHelpers.searchCollectibles(filters: filtersType) : Pages

	filters = filters or {}
	local keyword = filters.Keyword
	local sortType = filters.SortType
	
	local searchParams = CatalogSearchParams.new()
	
	searchParams.SalesTypeFilter = Enum.SalesTypeFilter.Collectibles
	searchParams.MinPrice = 1
	searchParams.SearchKeyword = keyword or searchParams.SearchKeyword
	searchParams.SortType = sortType or searchParams.SortType
	
	local success, pages = pcall(function()
		return avatarEditorService:SearchCatalogAsync(searchParams)
	end)
	
	if not success then 
		return {} 
	end

	return pages
end

function collectiblesHelpers.loadPage(pages : Pages) : itemHelpers.itemsType
	if pages.IsFinished then
		return nil
	end

	local page = pages:GetCurrentPage()
	pages:AdvanceToNextPageAsync()

	return page
end

function collectiblesHelpers.loadUGCs(pages : Pages) : itemHelpers.itemsType
	local page = collectiblesHelpers.loadPage(pages)
	if not page then return end

	local ugcs = collectiblesHelpers.getUGCs(page)
	return ugcs
end

return collectiblesHelpers
