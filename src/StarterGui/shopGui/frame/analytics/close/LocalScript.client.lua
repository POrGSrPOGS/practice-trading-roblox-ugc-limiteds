local button = script.Parent
local frame = button.Parent

button.MouseButton1Click:Connect(function()
	frame.Visible = false
end)