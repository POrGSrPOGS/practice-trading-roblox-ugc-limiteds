local replicatedStorage = game:GetService("ReplicatedStorage")
local client = replicatedStorage.client

local function initalise(descendant)
	if not descendant:IsA("ModuleScript") then return end
	
	local module = require(descendant)
	
	if not module.initialise then return end
	
	local success, warning = pcall(module.initialise)

	if not success then
		warn(warning)
	else
		print("Successfully initialised " .. descendant.Name .. "!")
	end
end

for _, descendant in client:GetDescendants() do
	initalise(descendant)
end