local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

local mp5Pos = Vector3.new(813.479187, 100.940002, 2229.177734)  -- ORIGINAL COORDS FROM FIRST SCRIPT
local remingtonPos = Vector3.new(820.248108, 100.795319, 2229.695557)
local newPos = Vector3.new(920.982300, 99.989952, 2282.098633)
local criminalBasePos = Vector3.new(-930.57, 94.13, 2053.59)
local undergroundOffset = Vector3.new(0, -25, 0)

local teleportLocations = {
	["Cafeteria"]       = Vector3.new(919.31, 100.6, 2448.79),
	["Field"]           = Vector3.new(792.7, 97.99, 2527.9),
	["Criminal Base"]   = Vector3.new(-930.57, 94.13, 2053.59),
	["Cop Base"]        = Vector3.new(882.6, 100.7, 2263.4),
	["Prison Roof"]     = Vector3.new(918.5, 130, 2350),
	["Sewers Entrance"] = Vector3.new(927.0, 97.5, 2140.0),
	["Yard"]            = Vector3.new(792, 98, 2380),
}

player.CharacterAdded:Connect(function(newChar)
	char = newChar
	hrp = char:WaitForChild("HumanoidRootPart")
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PRISON_LIFE_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0.5, -25)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 130, 255)
toggleButton.BorderSizePixel = 2
toggleButton.BorderColor3 = Color3.new(1,1,1)
toggleButton.Text = "OPEN"
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextScaled = true
toggleButton.Active = true
toggleButton.Draggable = true
toggleButton.Parent = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.Text = "PRISON LIFE SCRIPT"
title.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextScaled = true
closeButton.Parent = mainFrame

local buttonMinimize = Instance.new("TextButton")
buttonMinimize.Size = UDim2.new(0,35,0,35)
buttonMinimize.Position = UDim2.new(1,-80,0,5)
buttonMinimize.BackgroundColor3 = Color3.fromRGB(70,70,70)
buttonMinimize.Text = "_"
buttonMinimize.TextColor3 = Color3.new(1,1,1)
buttonMinimize.Font = Enum.Font.GothamBold
buttonMinimize.TextScaled = true
buttonMinimize.Parent = mainFrame

local guiOpen = false
toggleButton.MouseButton1Click:Connect(function()
	guiOpen = not guiOpen
	mainFrame.Visible = guiOpen
	toggleButton.Text = guiOpen and "CLOSE" or "OPEN"
	toggleButton.BackgroundColor3 = guiOpen and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(30, 130, 255)
end)
closeButton.MouseButton1Click:Connect(function()
	guiOpen = false
	mainFrame.Visible = false
	toggleButton.Text = "OPEN"
	toggleButton.BackgroundColor3 = Color3.fromRGB(30, 130, 255)
end)
UserInputService.InputBegan:Connect(function(i,gp)
	if i.KeyCode == Enum.KeyCode.Insert and not gp then toggleButton.MouseButton1Click:Fire() end
end)

local tabNames = {"Home", "Teleports and Tweens", "HITBOX and ESP", "Recommended"}
local tabs = {}
local tabFrames = {}

for i, name in ipairs(tabNames) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1/#tabNames,0,0,40)
	btn.Position = UDim2.new((i-1)/#tabNames,0,0,40)
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = name
	btn.Parent = mainFrame
	tabs[name] = btn

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,-20,1,-90)
	frame.Position = UDim2.new(0,10,0,90)
	frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
	frame.Visible = (name == "Home")
	frame.Parent = mainFrame
	tabFrames[name] = frame

	btn.MouseButton1Click:Connect(function()
		for _,f in pairs(tabFrames) do f.Visible = false end
		frame.Visible = true
		for n,b in pairs(tabs) do
			b.BackgroundColor3 = (n == name) and Color3.fromRGB(100,100,255) or Color3.fromRGB(60,60,60)
		end
	end)
end

local homeLabel = Instance.new("TextLabel")
homeLabel.Size = UDim2.new(1,-20,0,100)
homeLabel.Position = UDim2.new(0,10,0,10)
homeLabel.BackgroundTransparency = 1
homeLabel.TextColor3 = Color3.new(1,1,1)
homeLabel.TextScaled = true
homeLabel.TextWrapped = true
homeLabel.Text = "Welcome to PRISON LIFE SCRIPT!\nCafeteria & Sewers fixed.\nAimbot now toggles off when reselected.\nDropdowns smoother!\nOriginal Get MP5 restored!"
homeLabel.Parent = tabFrames["Home"]

local function createButton(parent,text,posY)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,-20,0,50)
	btn.Position = UDim2.new(0,10,0,posY)
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = text
	btn.Parent = parent
	return btn
end

local function makeTween(target, time)
	return TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(target)})
end

local buttonMP5 = createButton(tabFrames["Teleports and Tweens"], "Get MP5", 10)
local function tweenMP5()
	if not hrp then return end
	makeTween(hrp.Position + undergroundOffset, 2):Play()
	task.wait(2)
	makeTween(mp5Pos, 3):Play()
	task.wait(3)
	makeTween(mp5Pos + undergroundOffset, 2):Play()
	task.wait(2)
	makeTween(newPos, 4):Play()
end
buttonMP5.MouseButton1Click:Connect(tweenMP5)

createButton(tabFrames["Teleports and Tweens"],"Get Remington",70).MouseButton1Click:Connect(function()
	if not hrp then return end
	makeTween(hrp.Position+undergroundOffset,1.5):Play() task.wait(1.6)
	makeTween(remingtonPos,2):Play() task.wait(2.1)
	makeTween(remingtonPos+undergroundOffset,1.5):Play() task.wait(1.6)
	makeTween(newPos,3):Play()
end)

local teleportButton = createButton(tabFrames["Teleports and Tweens"],"Teleport Locations",130)  -- Moved down to not overlap
local teleportDropdown = Instance.new("ScrollingFrame")
teleportDropdown.Size = UDim2.new(1,-20,0,0)
teleportDropdown.Position = UDim2.new(0,10,0,185)
teleportDropdown.BackgroundColor3 = Color3.fromRGB(45,45,45)
teleportDropdown.ScrollBarThickness = 8
teleportDropdown.Visible = false
teleportDropdown.Parent = tabFrames["Teleports and Tweens"]

local dropOpen = false
teleportButton.MouseButton1Click:Connect(function()
	dropOpen = not dropOpen
	teleportDropdown.Visible = dropOpen
	teleportDropdown.Size = dropOpen and UDim2.new(1,-20,0,240) or UDim2.new(1,-20,0,0)
end)

local y = 0
for name, pos in pairs(teleportLocations) do
	local b = Instance.new("TextButton",teleportDropdown)
	b.Size = UDim2.new(1,-10,0,40)
	b.Position = UDim2.new(0,5,0,y)
	b.BackgroundColor3 = Color3.fromRGB(70,70,70)
	b.Text = name
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	
	b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(90,90,90) end)
	b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(70,70,70) end)
	
	b.MouseButton1Click:Connect(function()
		if hrp then
			hrp.CFrame = CFrame.new(pos) * CFrame.new(0, 3.5, 0)
			hrp.Velocity = Vector3.new(0,0,0)
			hrp.RotVelocity = Vector3.new(0,0,0)
		end
	end)
	y = y + 45
end
teleportDropdown.CanvasSize = UDim2.new(0,0,0,y)

local hitboxButton = createButton(tabFrames["HITBOX and ESP"], "HITBOX ESP", 10)
local aimbotButton = createButton(tabFrames["HITBOX and ESP"], "Aimbot Targets", 70)

local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1,-20,0,0)
dropdownFrame.Position = UDim2.new(0,10,0,60)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
dropdownFrame.Visible = false
dropdownFrame.Parent = tabFrames["HITBOX and ESP"]

local boxes = {}
local selectedTeams = {}
local teamColors = {Criminals = Color3.fromRGB(255,0,0), Guards = Color3.fromRGB(0,0,255), Inmates = Color3.fromRGB(255,165,0)}

local function createBox(hrp,color)
	local box = Instance.new("BoxHandleAdornment")
	box.Adornee = hrp
	box.AlwaysOnTop = true
	box.Size = Vector3.new(4,5,2)
	box.Color3 = color
	box.Transparency = 0.5
	box.ZIndex = 10
	box.Parent = hrp
	return box
end

local function updateESP()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = plr.Character.HumanoidRootPart
			if plr.Team and selectedTeams[plr.Team.Name] then
				if not boxes[plr] then
					boxes[plr] = createBox(hrp, teamColors[plr.Team.Name])
				end
			else
				if boxes[plr] then
					boxes[plr]:Destroy()
					boxes[plr] = nil
				end
			end
		end
	end
end

hitboxButton.MouseButton1Click:Connect(function()
	dropdownFrame.Visible = not dropdownFrame.Visible
	if dropdownFrame.Visible then
		dropdownFrame.Size = UDim2.new(1,-20,0,135)
		aimbotButton.Position = UDim2.new(0,10,0,dropdownFrame.Position.Y.Offset + dropdownFrame.Size.Y.Offset + 10)
	else
		dropdownFrame.Size = UDim2.new(1,-20,0,0)
		aimbotButton.Position = UDim2.new(0,10,0,70)
	end
	updateESP()
end)

for i, teamName in ipairs({"Criminals","Guards","Inmates"}) do
	local option = Instance.new("TextButton")
	option.Size = UDim2.new(1,-10,0,40)
	option.Position = UDim2.new(0,5,0,(i-1)*45)
	option.BackgroundColor3 = Color3.fromRGB(70,70,70)
	option.TextColor3 = Color3.new(1,1,1)
	option.Font = Enum.Font.GothamBold
	option.TextScaled = true
	option.Text = teamName
	option.Parent = dropdownFrame

	option.MouseButton1Click:Connect(function()
		if selectedTeams[teamName] then
			selectedTeams[teamName] = nil
			option.BackgroundColor3 = Color3.fromRGB(70,70,70)
		else
			selectedTeams[teamName] = true
			option.BackgroundColor3 = Color3.fromRGB(0,255,0)
		end
		updateESP()
	end)
end

local aimbotDropdown = Instance.new("Frame")
aimbotDropdown.Size = UDim2.new(1,-20,0,0)
aimbotDropdown.Position = UDim2.new(0,10,0,aimbotButton.Position.Y.Offset + 55)
aimbotDropdown.BackgroundColor3 = Color3.fromRGB(50,50,50)
aimbotDropdown.Visible = false
aimbotDropdown.Parent = tabFrames["HITBOX and ESP"]

local aimbotTargetTeam = nil

for i, teamName in ipairs({"Criminals","Guards","Inmates"}) do
	local option = Instance.new("TextButton")
	option.Size = UDim2.new(1,-10,0,40)
	option.Position = UDim2.new(0,5,0,(i-1)*45)
	option.BackgroundColor3 = Color3.fromRGB(70,70,70)
	option.TextColor3 = Color3.new(1,1,1)
	option.Font = Enum.Font.GothamBold
	option.TextScaled = true
	option.Text = teamName
	option.Parent = aimbotDropdown

	option.MouseEnter:Connect(function() if aimbotTargetTeam ~= teamName then option.BackgroundColor3 = Color3.fromRGB(90,90,90) end end)
	option.MouseLeave:Connect(function() if aimbotTargetTeam ~= teamName then option.BackgroundColor3 = Color3.fromRGB(70,70,70) end end)

	option.MouseButton1Click:Connect(function()
		if aimbotTargetTeam == teamName then
			aimbotTargetTeam = nil
			option.BackgroundColor3 = Color3.fromRGB(70,70,70)
		else
			aimbotTargetTeam = teamName
			for _, child in ipairs(aimbotDropdown:GetChildren()) do
				if child:IsA("TextButton") then
					child.BackgroundColor3 = (child.Text == teamName) and Color3.fromRGB(0,255,0) or Color3.fromRGB(70,70,70)
				end
			end
		end
	end)
end

aimbotButton.MouseButton1Click:Connect(function()
	aimbotDropdown.Visible = not aimbotDropdown.Visible
	if aimbotDropdown.Visible then
		aimbotDropdown.Size = UDim2.new(1,-20,0,135)
	else
		aimbotDropdown.Size = UDim2.new(1,-20,0,0)
	end
	aimbotDropdown.Position = UDim2.new(0,10,0,aimbotButton.Position.Y.Offset + 55)
end)

local noclipOn = false
local noclipLoop

local noclipBtn = createButton(tabFrames["Recommended"], "NOCLIP: OFF", 10)
noclipBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)

noclipBtn.MouseButton1Click:Connect(function()
	noclipOn = not noclipOn
	noclipBtn.Text = "NOCLIP: " .. (noclipOn and "ON" or "OFF")
	noclipBtn.BackgroundColor3 = noclipOn and Color3.fromRGB(40, 200, 40) or Color3.fromRGB(200, 40, 40)
	
	if noclipOn then
		StarterGui:SetCore("SendNotification", {Title="Noclip", Text="Noclip Enabled!", Duration=3})
		noclipLoop = RunService.Stepped:Connect(function()
			if char then
				for _, part in pairs(char:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end)
	else
		StarterGui:SetCore("SendNotification", {Title="Noclip", Text="Noclip Disabled", Duration=3})
		if noclipLoop then noclipLoop:Disconnect() end
		if char then
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					part.CanCollide = true
				end
			end
		end
	end
end)

RunService.RenderStepped:Connect(function()
	updateESP()
	if aimbotTargetTeam then
		local nearest = nil
		local shortestDist = math.huge
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Team and plr.Team.Name == aimbotTargetTeam then
				local hrp = plr.Character.HumanoidRootPart
				local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
				if onScreen then
					local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
					local dist = (Vector2.new(screenPos.X,screenPos.Y)-center).Magnitude
					if dist < shortestDist then
						shortestDist = dist
						nearest = hrp
					end
				end
			end
		end
		if nearest then
			camera.CFrame = CFrame.new(camera.CFrame.Position, nearest.Position)
		end
	end
end)

StarterGui:SetCore("SendNotification", {Title="Prison Life Script", Text="Original Get MP5 restored!", Duration=5})