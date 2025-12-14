local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
local camera = Workspace.CurrentCamera

local teleportLocations = {
	["Cafeteria"]       = Vector3.new(919.31, 100.6, 2448.79),
	["Field"]           = Vector3.new(792.7, 97.99, 2527.9),
	["Criminal Base"]   = Vector3.new(-930.57, 94.13, 2053.59),
	["Cop Base/Armory"] = Vector3.new(882.6, 100.7, 2263.4),
	["Prison Roof"]     = Vector3.new(918.5, 130, 2350),
	["Sewers Entrance"] = Vector3.new(927.0, 97.5, 2140.0),
	["Yard"]            = Vector3.new(792, 98, 2380),
	["Guard Room (MP5)"]= Vector3.new(835, 100, 2255),
}

player.CharacterAdded:Connect(function(newChar)
	char = newChar
	hrp = char:WaitForChild("HumanoidRootPart")
	humanoid = char:WaitForChild("Humanoid")
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "starz prison life gui"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(0, 10, 0.5, -30)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 130, 255)
toggleButton.Text = "OPEN"
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Draggable = true
toggleButton.Parent = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.1
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "STARZ PRISON LIFE"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255,0,0)
closeButton.Text = "X"
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

local guiOpen = false
toggleButton.MouseButton1Click:Connect(function()
	guiOpen = not guiOpen
	mainFrame.Visible = guiOpen
	toggleButton.Text = guiOpen and "CLOSE" or "OPEN"
	toggleButton.BackgroundColor3 = guiOpen and Color3.fromRGB(255,80,80) or Color3.fromRGB(30,130,255)
end)
closeButton.MouseButton1Click:Connect(function()
	guiOpen = false
	mainFrame.Visible = false
	toggleButton.Text = "OPEN"
	toggleButton.BackgroundColor3 = Color3.fromRGB(30,130,255)
end)
UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Insert then
		toggleButton.MouseButton1Click:Fire()
	end
end)

local tabNames = {"Home", "Teleports", "Combat", "Movement", "Misc"}
local tabs = {}
local tabFrames = {}

for i, name in ipairs(tabNames) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1/#tabNames, 0, 0, 50)
	btn.Position = UDim2.new((i-1)/#tabNames, 0, 0, 50)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.Text = name
	btn.TextScaled = true
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Parent = mainFrame
	tabs[name] = btn

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -20, 1, -110)
	frame.Position = UDim2.new(0, 10, 0, 100)
	frame.BackgroundTransparency = 1
	frame.Parent = mainFrame
	frame.Visible = (name == "Home")
	tabFrames[name] = frame

	btn.MouseButton1Click:Connect(function()
		for _, f in pairs(tabFrames) do f.Visible = false end
		frame.Visible = true
		for n, b in pairs(tabs) do
			b.BackgroundColor3 = (n == name) and Color3.fromRGB(100,100,255) or Color3.fromRGB(50,50,50)
		end
	end)
end

local function createButton(parent, text, yPos, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 55)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.Text = text
	btn.TextScaled = true
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Parent = parent
	if callback then btn.MouseButton1Click:Connect(callback) end
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = btn
	
	return btn
end

local homeLabel = Instance.new("TextLabel")
homeLabel.Size = UDim2.new(1, -20, 0, 150)
homeLabel.Position = UDim2.new(0, 10, 0, 10)
homeLabel.BackgroundTransparency = 1
homeLabel.TextColor3 = Color3.new(1,1,1)
homeLabel.TextWrapped = true
homeLabel.TextScaled = true
homeLabel.Text = "STARZ PL SCRIPT\nUpdated Dec 2025\nTarget selection for ESP & Aimbot\nAnti Tase added\nNeater mobile GUI"
homeLabel.Parent = tabFrames["Home"]

local yPos = 10
for name, pos in pairs(teleportLocations) do
	createButton(tabFrames["Teleports"], "TP to " .. name, yPos, function()
		if hrp then
			hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
		end
	end)
	yPos = yPos + 65
end

-- Combat Tab - IMPROVED ESP & AIMBOT DROPDOWNS (higher ZIndex, better positioning, no overlap)
local teams = {"Guards", "Inmates", "Criminals"}
local teamColors = {Guards = Color3.fromRGB(0,0,255), Inmates = Color3.fromRGB(255,165,0), Criminals = Color3.fromRGB(255,0,0)}

local selectedESPTargets = {}
local selectedAimbotTarget = nil

local espOn = false
local aimbotOn = false
local killAuraOn = false
local boxes = {}

-- ESP Toggle
createButton(tabFrames["Combat"], "Toggle ESP", 10, function()
	espOn = not espOn
end)

-- ESP Dropdown (ScrollingFrame with higher ZIndex)
local espScroll = Instance.new("ScrollingFrame")
espScroll.Size = UDim2.new(1,-20,0,0)
espScroll.Position = UDim2.new(0,10,0,75)
espScroll.BackgroundColor3 = Color3.fromRGB(35,35,35)
espScroll.BorderSizePixel = 0
espScroll.ScrollBarThickness = 6
espScroll.Visible = false
espScroll.CanvasSize = UDim2.new(0,0,0,0)
espScroll.ZIndex = 20  -- High ZIndex so it appears on top
espScroll.Parent = tabFrames["Combat"]

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0,8)
espCorner.Parent = espScroll

local espDropOpen = false
local espToggleBtn = createButton(tabFrames["Combat"], "ESP Targets ▼", 75, function()
	espDropOpen = not espDropOpen
	espScroll.Visible = espDropOpen
	if espDropOpen then
		espScroll:TweenSize(UDim2.new(1,-20,0,175), "Out", "Quad", 0.3, true)
	else
		espScroll:TweenSize(UDim2.new(1,-20,0,0), "Out", "Quad", 0.3, true)
	end
end)
espToggleBtn.ZIndex = 15

local espY = 5  -- Small padding
for _, teamName in ipairs(teams) do
	local opt = createButton(espScroll, teamName .. " ESP: OFF", espY, function()
		selectedESPTargets[teamName] = not selectedESPTargets[teamName]
		opt.Text = teamName .. " ESP: " .. (selectedESPTargets[teamName] and "ON" or "OFF")
		opt.BackgroundColor3 = selectedESPTargets[teamName] and Color3.fromRGB(0,255,0) or Color3.fromRGB(50,50,50)
	end)
	opt.ZIndex = 21
	espY = espY + 65
end
espScroll.CanvasSize = UDim2.new(0,0,0,espY + 10)

-- Aimbot Toggle
createButton(tabFrames["Combat"], "Toggle Aimbot", 160, function()
	aimbotOn = not aimbotOn
end)

-- Aimbot Dropdown (ScrollingFrame with higher ZIndex)
local aimbotScroll = Instance.new("ScrollingFrame")
aimbotScroll.Size = UDim2.new(1,-20,0,0)
aimbotScroll.Position = UDim2.new(0,10,0,225)
aimbotScroll.BackgroundColor3 = Color3.fromRGB(35,35,35)
aimbotScroll.BorderSizePixel = 0
aimbotScroll.ScrollBarThickness = 6
aimbotScroll.Visible = false
aimbotScroll.CanvasSize = UDim2.new(0,0,0,0)
aimbotScroll.ZIndex = 20
aimbotScroll.Parent = tabFrames["Combat"]

local aimCorner = Instance.new("UICorner")
aimCorner.CornerRadius = UDim.new(0,8)
aimCorner.Parent = aimbotScroll

local aimbotDropOpen = false
local aimbotTargetBtn = createButton(tabFrames["Combat"], "Aimbot Target: None ▼", 225, function()
	aimbotDropOpen = not aimbotDropOpen
	aimbotScroll.Visible = aimbotDropOpen
	if aimbotDropOpen then
		aimbotScroll:TweenSize(UDim2.new(1,-20,0,175), "Out", "Quad", 0.3, true)
	else
		aimbotScroll:TweenSize(UDim2.new(1,-20,0,0), "Out", "Quad", 0.3, true)
	end
end)
aimbotTargetBtn.ZIndex = 15

local aimY = 5
for _, teamName in ipairs(teams) do
	local opt = createButton(aimbotScroll, teamName, aimY, function()
		if selectedAimbotTarget == teamName then
			selectedAimbotTarget = nil
			aimbotTargetBtn.Text = "Aimbot Target: None ▼"
		else
			selectedAimbotTarget = teamName
			aimbotTargetBtn.Text = "Aimbot Target: " .. teamName .. " ▼"
		end
		for _, child in ipairs(aimbotScroll:GetChildren()) do
			if child:IsA("TextButton") then
				child.BackgroundColor3 = (child.Text == teamName and selectedAimbotTarget == teamName) and Color3.fromRGB(0,255,0) or Color3.fromRGB(50,50,50)
			end
		end
	end)
	opt.ZIndex = 21
	aimY = aimY + 65
end
aimbotScroll.CanvasSize = UDim2.new(0,0,0,aimY + 10)

-- Kill Aura (moved down a bit)
createButton(tabFrames["Combat"], "Toggle Kill Aura", 300, function()
	killAuraOn = not killAuraOn
end)

-- Movement Tab
local noclipOn = false
local flyOn = false
local infJumpOn = false

createButton(tabFrames["Movement"], "Toggle Noclip", 10, function()
	noclipOn = not noclipOn
end)

createButton(tabFrames["Movement"], "Toggle Fly (E/Q)", 75, function()
	flyOn = not flyOn
end)

createButton(tabFrames["Movement"], "Toggle Infinite Jump", 140, function()
	infJumpOn = not infJumpOn
end)

createButton(tabFrames["Movement"], "WalkSpeed +10", 205, function()
	if humanoid then humanoid.WalkSpeed = humanoid.WalkSpeed + 10 end
end)

createButton(tabFrames["Movement"], "Reset WalkSpeed", 270, function()
	if humanoid then humanoid.WalkSpeed = 16 end
end)

-- Misc Tab
local antiTaseOn = false

createButton(tabFrames["Misc"], "Toggle Anti Tase", 10, function()
	antiTaseOn = not antiTaseOn
end)

-- Loops
RunService.Stepped:Connect(function()
	if noclipOn and char then
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end

	if killAuraOn and hrp then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Team ~= player.Team and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
				local dist = (hrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
				if dist < 20 then
					plr.Character.Humanoid:TakeDamage(100)
				end
			end
		end
	end

	if flyOn and hrp then
		hrp.Velocity = Vector3.new(0,0,0)
		local moveDir = humanoid.MoveDirection * 100
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.E) then
			hrp.Velocity = Vector3.new(moveDir.X, 100, moveDir.Z)
		elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.Q) then
			hrp.Velocity = Vector3.new(moveDir.X, -100, moveDir.Z)
		else
			hrp.Velocity = Vector3.new(moveDir.X, 0, moveDir.Z)
		end
	end
end)

-- Anti Tase
if Workspace:FindFirstChild("Remote") and Workspace.Remote:FindFirstChild("PlayerTased") then
	Workspace.Remote.PlayerTased.OnClientEvent:Connect(function()
		if antiTaseOn then
			task.wait(0.1)
			if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Running) end
		end
	end)
end

RunService.RenderStepped:Connect(function()
	if espOn then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Team then
				local teamName = plr.Team.Name
				if selectedESPTargets[teamName] then
					if not boxes[plr] then
						local box = Drawing.new("Square")
						box.Thickness = 2
						box.Filled = false
						box.Color = teamColors[teamName] or Color3.fromRGB(255,0,0)
						box.Visible = false
						boxes[plr] = box
					end
					local root = plr.Character.HumanoidRootPart
					local pos, onScreen = camera:WorldToViewportPoint(root.Position)
					if onScreen then
						local size = Vector2.new(2000 / pos.Z, 3000 / pos.Z)
						boxes[plr].Size = size
						boxes[plr].Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
						boxes[plr].Visible = true
					else
						boxes[plr].Visible = false
					end
				else
					if boxes[plr] then
						boxes[plr].Visible = false
					end
				end
			else
				if boxes[plr] then
					boxes[plr]:Remove()
					boxes[plr] = nil
				end
			end
		end
	end

	if aimbotOn and selectedAimbotTarget then
		local nearest = nil
		local shortest = math.huge
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Team and plr.Team.Name == selectedAimbotTarget and plr.Character and plr.Character:FindFirstChild("Head") then
				local head = plr.Character.Head
				local pos, onScreen = camera:WorldToViewportPoint(head.Position)
				if onScreen then
					local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
					if dist < shortest then
						shortest = dist
						nearest = head
					end
				end
			end
		end
		if nearest then
			camera.CFrame = CFrame.new(camera.CFrame.Position, nearest.Position)
		end
	end
end)

UserInputService.JumpRequest:Connect(function()
	if infJumpOn and humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

StarterGui:SetCore("SendNotification", {Title = "STARZ PL Loaded", Text = "ESP dropdown fixed - now fully visible & clean on mobile!", Duration = 8})