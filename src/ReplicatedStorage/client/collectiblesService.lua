local collectiblesService = {}

local avatarEditorService = game:GetService("AvatarEditorService")

local function isUGC(collectible)
	return collectible.CreatorName ~= "Roblox"
end

function collectiblesService.getUGCs(collectibles)
	local ugcs = {}

	for _, collectible in collectibles do
		if not isUGC(collectible) then continue end

		table.insert(ugcs, collectible)
	end

	return ugcs
end

function collectiblesService.getCollectibles(filters)

	filters = filters or {}
	local keyword = filters.Keyword
	local sortType = filters.SortType
	

	local searchParams = CatalogSearchParams.new()
	
	searchParams.SalesTypeFilter = Enum.SalesTypeFilter.Collectibles
	searchParams.MinPrice = 1

	searchParams.SearchKeyword = keyword or searchParams.SearchKeyword
	searchParams.SortType = sortType or searchParams.SortType


	local collectibles = {}
	
	local success, pages = pcall(function()
		return avatarEditorService:SearchCatalogAsync(searchParams)
	end)
	
	if not success then 
		return {} 
	end

	while true do
		local pageCollectibles = pages:GetCurrentPage()

		for _, pageCollectible in pageCollectibles do
			table.insert(collectibles, pageCollectible)
		end

		if pages.IsFinished then break end

		local success, warning = pcall(function()
			pages:AdvanceToNextPageAsync()
		end)
	
		if not success then
			print(warning)
			return collectibles
		end
		
	end

	return collectibles
end

return collectiblesService
