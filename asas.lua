local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/ItsBlawda/whoamii/refs/heads/master/MYGUI.lua'))()
Library.Theme = "Dark"
local Flags = Library.Flags

local Window = Library:Window({
    Text = "Github"
})

local Farming = Window:Tab({ 
    Text = "Farming" 
})

local Glitch = Window:Tab({
    Text = "Glitch"
})

local Rebirth = Window:Tab({ 
    Text = "Rebirth" 
})

local farming = Farming:Section({ 
    Text = "FARM"
})

local rebirth = Rebirth:Section({ 
    Text = "REBIRTH"
})

local glitch = Glitch:Section({
    Text = "GLITCH"
})

local glitch2 = Glitch:Section({
    Text = "GLITCH 2",
    Side = "Right"
})

-- Auto Punch
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local TOOL_NAME = "Punch"
local character

-- -------------------------------
-- Helper Function
-- -------------------------------
local function equipTool(tool)
	if tool and tool.Parent == backpack and character and character:FindFirstChild("Humanoid") then
		character.Humanoid:EquipTool(tool)
	end
end

local function getPunchTool()
	return backpack:FindFirstChild(TOOL_NAME) or (character and character:FindFirstChild(TOOL_NAME))
end

-- -------------------------------
-- Auto Punch Module
-- -------------------------------
local AutoPunch = {}
AutoPunch.enabled = false
AutoPunch.loop = nil

function AutoPunch:start()
	if self.loop and coroutine.status(self.loop) ~= "dead" then return end
	self.loop = task.spawn(function()
		while self.enabled do
			local tool = getPunchTool()
			if tool then
				-- Equip if needed
				if tool.Parent == backpack and character then
					equipTool(tool)
				end
				-- Activate punch asynchronously
				task.defer(function()
					tool:Activate()
				end)
			end
			task.wait(0.01) -- 10ms auto-clicker
		end
	end)
end

function AutoPunch:stop()
	self.enabled = false
	if self.loop then
		task.cancel(self.loop)
		self.loop = nil
	end
end

-- -------------------------------
-- Handle Respawn
-- -------------------------------
player.CharacterAdded:Connect(function(char)
	character = char
	if AutoPunch.enabled then
		task.wait(0.1)
		AutoPunch:start()
	end
end)

if player.Character then
	character = player.Character
end

-- -------------------------------
-- UI Toggle
-- -------------------------------
farming:Toggle({
	Text = "Auto Punch",
	Default = false,
	Callback = function(Value)
		AutoPunch.enabled = Value
		if Value then
			AutoPunch:start()
			warn("Auto Punch enabled")
		else
			AutoPunch:stop()
			warn("Auto Punch disabled")
		end
	end
})
-- Auto Punch

-- Fast Punch Toggle
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local punch = "Punch"

local defaultAttackTime = nil
local fastPunchEnabled = false
local character


local function getPunchTool()
	return backpack:FindFirstChild(punch) or (character and character:FindFirstChild(punch))
end

-- Apply fast punch
local function applyFastPunch()
	local tool = getPunchTool()
	if tool and tool:FindFirstChild("attackTime") then
		tool.attackTime.Value = 0
	end
end

local function restoreAttackTime()
	local tool = getPunchTool()
	if tool and tool:FindFirstChild("attackTime") and defaultAttackTime then
		tool.attackTime.Value = defaultAttackTime
	end
end

-- Fast Punch Toggle
farming:Toggle({
	Text = "Fast Punch",
	Default = false,
	Callback = function(Value)
		fastPunchEnabled = Value
		local tool = getPunchTool()
		if tool then
			if defaultAttackTime == nil and tool:FindFirstChild("attackTime") then
				defaultAttackTime = tool.attackTime.Value
			end
			if Value then
				applyFastPunch()
				warn("Fast Punch enabled")
			else
				restoreAttackTime()
				warn("Fast Punch disabled")
			end
		end
	end
})

player.CharacterAdded:Connect(function(char)
	character = char
	if fastPunchEnabled then
		task.wait(0.01)
		applyFastPunch()
	end
end)

if player.Character then
	character = player.Character
end
-- Fast Punch Toggle



-- AUto Punch Rock
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Remotes
local muscleEvent = player:WaitForChild("muscleEvent")
local guiDamageEvent = ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("guiDamageEvent")

-- Rock list
local rocks = {
    "Ancient Jungle Rock",
    "Muscle King Mountain",
    "Rock OF Legends",
    "Frozen Rock",
    "Inferno Rock",
    "none"
}

-- Variables
local autoPunchEnabled = false
local rockFollowEnabled = false
local selectedRock = nil
local rockModel = nil
local rockOffset = CFrame.new(0, 0, 3)
local autoPunchLoop = nil

-- -------------------------
-- Auto Punch Loop
-- -------------------------
local function startAutoPunch()
    if autoPunchLoop and coroutine.status(autoPunchLoop) ~= "dead" then return end
    autoPunchLoop = task.spawn(function()
        while autoPunchEnabled do
            muscleEvent:FireServer("punch", "rightHand")
            muscleEvent:FireServer("punch", "leftHand")
            task.wait(0.01) -- ultra-fast 10ms
        end
    end)
end

local function stopAutoPunch()
    autoPunchEnabled = false
    if autoPunchLoop then
        task.cancel(autoPunchLoop)
        autoPunchLoop = nil
    end
end

-- -------------------------
-- Rock Follow Logic
-- -------------------------
local function makeRockReachable()
    if rockModel and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local rockPart = rockModel:FindFirstChild("Rock")
        if rockPart then
            rockPart.Size = Vector3.new(2,1,1)       -- tiny
            rockPart.Transparency = 1                -- invisible
            rockPart.CanCollide = false              -- no collisions
            rockPart.Anchored = true                 -- ignore physics
            rockPart.Massless = true                 -- lighter, won’t push player
            rockPart.CFrame = hrp.CFrame * rockOffset
        end
    end
end

RunService.RenderStepped:Connect(function()
    if rockFollowEnabled and rockModel and selectedRock and selectedRock ~= "none" then
        makeRockReachable()
    end
end)

-- -------------------------
-- UI Dropdown & Toggle
-- -------------------------
glitch:Dropdown({
    Text = "Choose Rock",
    List = rocks,
    Default = "none",
    ChangeTextOnPick = true,
    Flag = "RockChoice",
    Callback = function(option)
        selectedRock = option
        rockModel = workspace.machinesFolder:FindFirstChild(selectedRock)
        warn("Selected rock:", selectedRock)
    end
})

glitch:Toggle({
    Text = "Attach Rock To Head",
    Default = false,
    Callback = function(Value)
        rockFollowEnabled = Value
        if not Value and rockModel then
            local rockPart = rockModel:FindFirstChild("Rock")
            if rockPart then
                rockPart.Size = Vector3.new(5,5,5)   -- reset size
                rockPart.Transparency = 0
                rockPart.CanCollide = true
                rockPart.Anchored = false
                rockPart.Massless = false
            end
        end
    end
})

glitch:Toggle({
    Text = "Auto Punch",
    Default = false,
    Callback = function(Value)
        autoPunchEnabled = Value
        if Value then
            startAutoPunch()
            warn("Auto Punch enabled")
        else
            stopAutoPunch()
            warn("Auto Punch disabled")
        end
    end
})

-- -------------------------
-- Handle Respawn
-- -------------------------
player.CharacterAdded:Connect(function(char)
    if autoPunchEnabled then
        task.wait(0.1)
        startAutoPunch()
    end
end)

if player.Character then
    player.Character:WaitForChild("HumanoidRootPart")
end

-- Auto Rock Punch
