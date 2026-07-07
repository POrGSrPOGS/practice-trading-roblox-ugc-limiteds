local serverScriptService = game:GetService("ServerScriptService")

for _, descendant in serverScriptService:GetDescendants() do
	
	if not descendant:IsA("ModuleScript") then continue end
	
	local module = require(descendant)
	
	if not module.initialise then continue end
	
	local success, warning = pcall(module.initialise)

	if not success then
		warn(warning)
	else
		print("Successfully initialised " .. descendant.Name .. "!")
	end
end