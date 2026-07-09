local api = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
local serverScriptService = game:GetService("ServerScriptService")
local httpService = game:GetService("HttpService")

local remotes = replicatedStorage.remotes
local rolimons = require(serverScriptService.rolimons)

local WORKER_TOKEN = httpService:GetSecret("WORKER_TOKEN")
local WORKER_URL = "https://roblox-ugc-analytics.finnbrierley.workers.dev"

local MAX_IDS = 6
local MAX_RETRIES = 4
local RETRY_WAIT = 65 -- seconds; give the worker's queue time to backfill

local function getAnalyticsData(ids)
	local response = httpService:RequestAsync({
		Url = WORKER_URL .. "/?itemIds=" .. table.concat(ids, ","),
		Method = "GET",
		Headers = {
			["Authorization"] = WORKER_TOKEN:AddPrefix("Bearer ")
		}
	})

	if not response.Success then
		warn("Worker request failed:", response.StatusCode, response.Body)
		return nil
	end
	return response.Success, response.Body
end


local function getAnalytics(player, ids)
	print(ids)
	
	local totalRAPDetails = {}
	local remainingIds = ids -- ids still needing a successful fetch
	local attempt = 0

	while #remainingIds > 0 and attempt <= MAX_RETRIES do
		attempt += 1
		local pendingIds = {} -- ids to retry after this pass
		local index = 1
		local total = #remainingIds

		while index <= total do
			local set = {}
			for _ = 1, MAX_IDS do
				if index > total then
					break
				end
				table.insert(set, remainingIds[index])
				index += 1
			end

			local success, response = getAnalyticsData(set)

			if success and response then
				local decodedSuccess, rapDetails = pcall(function()
					return httpService:JSONDecode(response)
				end)

				if decodedSuccess and rapDetails then
					local items = rapDetails.itemId and { rapDetails } or rapDetails

					for _, rapDetail in items do
						if rapDetail.status == "ok" then
							table.insert(totalRAPDetails, rapDetail)
						elseif rapDetail.status == "queued" or rapDetail.status == "rate_limited" then
							
							if rapDetail.status == "rate_limited"  then
								warn("rate limited")
							end
							
							table.insert(pendingIds, rapDetail.itemId)
						else
							warn("Item " .. tostring(rapDetail.itemId) .. " failed: " .. tostring(rapDetail.error))
						end
					end
				else
					warn("JSON decode failed")
					-- couldn't tell what succeeded in this chunk so retries the whole chunk
					for _, id in ipairs(set) do
						table.insert(pendingIds, id)
					end
				end
			else
				warn("HTTP request failed", response)
				for _, id in ipairs(set) do
					table.insert(pendingIds, id)
				end
			end

			task.wait(0.5)
		end

		remainingIds = pendingIds
		if #remainingIds > 0 and attempt <= MAX_RETRIES then
			task.wait(RETRY_WAIT)
		end
	end

	if #remainingIds > 0 then
		warn(("getRAP: %d item(s) never resolved after %d attempts"):format(#remainingIds, MAX_RETRIES))
	end

	print(totalRAPDetails)
	return totalRAPDetails
end

function api.initialise()
	remotes.getAnalytics.OnServerInvoke = getAnalytics
end

return api
