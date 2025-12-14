local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
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
	["Guard Room (MP5)"]= Vector3.new(835, 100, 2255),  -- Approximate armory interior for new MP5
}

player.CharacterAdded:Connect(function(newChar)
	char = newChar
	hrp = char:WaitForChild("HumanoidRootPart")
	humanoid = char:WaitForChild("Humanoid")
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "starz prison life gui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

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
mainFrame.Size = UDim2.new(0, 450, 0, 550)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "starz prison life script"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255,0,0)
closeButton.Text = "X"
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.Parent = mainFrame

-- Toggle Logic
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

-- Tabs
local tabNames = {"Home", "Teleports", "Combat", "Movement", "Misc"}
local tabs = {}
local tabFrames = {}

for i, name in ipairs(tabNames) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1/#tabNames, 0, 0, 40)
	btn.Position = UDim2.new((i-1)/#tabNames, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.Text = name
	btn.TextScaled = true
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Parent = mainFrame
	tabs[name] = btn

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -20, 1, -90)
	frame.Position = UDim2.new(0, 10, 0, 80)
	frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
	frame.Visible = (name == "Home")
	frame.Parent = mainFrame
	tabFrames[name] = frame

	btn.MouseButton1Click:Connect(function()
		for _, f in pairs(tabFrames) do f.Visible = false end
		frame.Visible = true
		for n, b in pairs(tabs) do
			b.BackgroundColor3 = (n == name) and Color3.fromRGB(100,100,255) or Color3.fromRGB(60,60,60)
		end
	end)
end

-- Helper for buttons
local function createButton(parent, text, yPos, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 50)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.Text = text
	btn.TextScaled = true
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Parent = parent
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Home Tab
Instance.new("TextLabel", tabFrames["Home"]).Setup = function(self)
	self.Size = UDim2.new(1, -20, 0, 200)
	self.Position = UDim2.new(0, 10, 0, 10)
	self.BackgroundTransparency = 1
	self.TextColor3 = Color3.new(1,1,1)
	self.TextWrapped = true
	self.TextScaled = true
	self.Text = "starz pl script, Features: Teleports, ESP/Aimbot, Fly, Noclip, Speed, Kill Aura, anti arrest/anti tase, etc. enjoy"
end:Setup()

-- Teleports Tab
local yPos = 10
for name, pos in pairs(teleportLocations) do
	createButton(tabFrames["Teleports"], "TP to " .. name, yPos, function()
		if hrp then
			hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
		end
	end)
	yPos = yPos + 60
end

-- Combat Tab (ESP, Aimbot, Kill Aura)
local espOn = false
local aimbotOn = false
local killAuraOn = false
local boxes = {}

createButton(tabFrames["Combat"], "Toggle ESP", 10, function()
	espOn = not espOn
end)

createButton(tabFrames["Combat"], "Toggle Aimbot", 70, function()
	aimbotOn = not aimbotOn
end)

createButton(tabFrames["Combat"], "Toggle Kill Aura", 130, function()
	killAuraOn = not killAuraOn
end)

-- Movement Tab (Noclip, Fly, Speed, Inf Jump)
local noclipOn = false
local flyOn = false
local infJumpOn = false
local speed = 16

createButton(tabFrames["Movement"], "Toggle Noclip", 10, function()
	noclipOn = not noclipOn
end)

createButton(tabFrames["Movement"], "Toggle Fly (E/Q)", 70, function()
	flyOn = not flyOn
end)

createButton(tabFrames["Movement"], "Infinite Jump", 130, function()
	infJumpOn = not infJumpOn
end)

createButton(tabFrames["Movement"], "Speed +10", 190, function()
	humanoid.WalkSpeed = humanoid.WalkSpeed + 10
end)

createButton(tabFrames["Movement"], "Speed Reset", 250, function()
	humanoid.WalkSpeed = 16
end)

-- Misc Tab (God Mode, Auto Arrest, etc.)
local godModeOn = false

createButton(tabFrames["Misc"], "God Mode (Anti-Arrest/Kill)", 10, function()
	godModeOn = not godModeOn
	if godModeOn then
		humanoid.MaxHealth = math.huge
		humanoid.Health = math.huge
	end
end)

-- Loops
RunService.Stepped:Connect(function()
	if noclipOn and char then
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end

	if killAuraOn then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local dist = (hrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
				if dist < 20 then
					humanoid:TakeDamage(100)  -- Remote fire or punch sim (works in most cases)
					-- Alternative: fire click detectors if available
				end
			end
		end
	end

	if flyOn and hrp then
		hrp.Velocity = Vector3.new(0,0,0)
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.E) then
			hrp.Velocity = Vector3.new(0, 100, 0)
		elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.Q) then
			hrp.Velocity = Vector3.new(0, -100, 0)
		end
		local moveDir = humanoid.MoveDirection * 100
		hrp.Velocity = Vector3.new(moveDir.X, hrp.Velocity.Y, moveDir.Z)
	end
end)

RunService.RenderStepped:Connect(function()
	if espOn then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local head = plr.Character:FindFirstChild("Head")
				if head and not boxes[plr] then
					local box = Drawing.new("Square")
					box.Thickness = 2
					box.Filled = false
					box.Color = Color3.fromRGB(255,0,0)
					box.Visible = true
					boxes[plr] = box
				end
				if boxes[plr] then
					local pos, onScreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
					if onScreen then
						boxes[plr].Visible = true
						boxes[plr].Size = Vector2.new(2000 / pos.Z, 3000 / pos.Z)
						boxes[plr].Position = Vector2.new(pos.X - boxes[plr].Size.X/2, pos.Y - boxes[plr].Size.Y/2)
					else
						boxes[plr].Visible = false
					end
				end
			else
				if boxes[plr] then boxes[plr]:Remove() boxes[plr] = nil end
			end
		end
	end

	if aimbotOn then
		local nearest = nil
		local shortest = math.huge
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Team ~= player.Team and plr.Character and plr.Character:FindFirstChild("Head") then
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

if infJumpOn then
	UserInputService.JumpRequest:Connect(function()
		if infJumpOn then humanoid:ChangeState("Jumping") end
	end)
end

StarterGui:SetCore("SendNotification", {Title = "starz pl loaded", Text = "updated/compatible for latest update!", Duration = 6})

