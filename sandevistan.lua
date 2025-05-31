-- Constants
local ABILITY_COOLDOWN = 5 -- (s)
local ABILITY_DURATION = 3 -- (s)
local SPEED_MULTIPLIER = 2 -- (*)
local ABILITY_COLOR = Color3.fromRGB(100, 150, 255) -- RGB
local ABIILITY_KEYBIND = Enum.KeyCode.V -- Enum.KeyCode
-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local isMobile = UserInputService.TouchEnabled
-- Variables
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local isAbilityActive = false
local onCooldown = false
local cloneThread = nil
local movementThread = nil
local trailPartsFolders = {}
local colorCorrection = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
if not colorCorrection then
	colorCorrection = Instance.new("ColorCorrectionEffect", Lighting)
	colorCorrection.Enabled = false
end
Player.CharacterAdded:Connect(function(new)
	Character = new
	Humanoid = new:WaitForChild("Humanoid")
end)
-- Functions
local function tween(instance, tweenInfo, properties)
	local tween = TweenService:Create(instance, tweenInfo, properties)
	tween:Play()
	return tween
end
local function playSound(soundId, timePosition)
	local sound = Instance.new("Sound", workspace)
	sound.SoundId = soundId
	sound.TimePosition = timePosition or 0
	sound:Play()
	sound.Ended:Connect(function()
		sound:Destroy()
	end)

	return sound
end
local function cloneCharacter()
	local folder = Instance.new("Folder", workspace)
	for _, descendant in Character:GetDescendants() do
		if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" and descendant.Name ~= "Handle" then
			local clone = descendant:Clone()

			clone:ClearAllChildren()
			clone.Color = ABILITY_COLOR
			clone.Material = "Neon"
			clone.CanCollide = false
			clone.Anchored = true
			clone.Transparency = 0.5

			clone.Parent = folder
		end
	end
	return folder
end

local function activateAbility()
	if onCooldown then return end
	onCooldown = true
	isAbilityActive = true

	playSound("rbxassetid://118534165523355", 0.2)

	colorCorrection.Enabled = true
	local flashTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)
	tween(colorCorrection, flashTweenInfo, { TintColor = Color3.new(1, 1, 1), Saturation = 1 })
	tween(Camera, flashTweenInfo, {FieldOfView = 60})
	task.wait(0.2)
	local blueTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
	tween(colorCorrection, blueTweenInfo, { TintColor = ABILITY_COLOR, Saturation = 0.5 })
	tween(Camera, flashTweenInfo, {FieldOfView = 90})

	cloneThread = coroutine.create(function()
		while isAbilityActive do
			local folder = cloneCharacter()
			table.insert(trailPartsFolders, folder)
			for _, part in folder:GetChildren() do
				local fadeTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
				local fadeTween = tween(part, fadeTweenInfo, { Transparency = 1 })
				fadeTween.Completed:Connect(function()
					if part then part:Destroy() end
				end)
			end
			task.delay(0.5, function()
				if folder then folder:Destroy() end
			end)
			task.wait(0.1)
		end
	end)
	coroutine.resume(cloneThread)

	movementThread = coroutine.create(function()
		local lastTick = tick()
		while isAbilityActive do
			local currentTick = tick()
			local deltaTime = currentTick - lastTick
			lastTick = currentTick

			if Humanoid.MoveDirection.Magnitude > 0 and Character.PrimaryPart then
				local moveVector = Humanoid.MoveDirection * Humanoid.WalkSpeed * SPEED_MULTIPLIER * deltaTime
				Character:TranslateBy(moveVector)
			end
			RunService.Stepped:Wait()
		end
	end)
	coroutine.resume(movementThread)

	task.wait(ABILITY_DURATION)
	isAbilityActive = false

	playSound("rbxassetid://123844681344865")

	tween(Camera, flashTweenInfo, {FieldOfView = 70})

	colorCorrection.Enabled = false

	
	if cloneThread then
		coroutine.close(cloneThread)
		cloneThread = nil
	end
	if movementThread then
		coroutine.close(movementThread)
		movementThread = nil
	end

	for _, folder in trailPartsFolders do
		if folder then
			for _, part in folder:GetChildren() do
				task.delay(.6, function()
					if part then part:Destroy() end
				end)
			end
			task.delay(.6, function()
				if folder then folder:Destroy() end
			end)
		end
	end
	table.clear(trailPartsFolders)

	task.wait(ABILITY_COOLDOWN)
	onCooldown = false
end

if isMobile then
	local tool = Instance.new("Tool", Player.Backpack)
	tool.Name = "Sandevistan"
	tool.RequiresHandle = false
	tool.Activated:Connect(activateAbility)
else
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == ABIILITY_KEYBIND then
			activateAbility()
		end
	end)
end
