local fakeItems = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
local remotes = replicatedStorage.remotes

local function invest(player, id)
	
end

function fakeItems.initialise()
	remotes.invest.OnServerEvent:Connect(invest)
end

return fakeItems
