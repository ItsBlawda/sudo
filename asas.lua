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



-- Auto Punch Rock

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local TOOL_NAME = "Punch"

-- Rock list
local rocks = {
    "Muscle King Mountain",
    "Ancient Jungle Rock",
    "Rock OF Legends",
    "Frozen Rock",
    "Inferno Rock",
    "none"
}

local selectedRock = nil
local autoPunchEnabled = false
local autoPunchLoop = nil
local character = player.Character

-- -------------------------
-- Helper: Equip tool
-- -------------------------
local function equipTool(tool)
    if tool and character and character:FindFirstChild("Humanoid") then
        character.Humanoid:EquipTool(tool)
    end
end

-- -------------------------
-- Auto Punch Loop
-- -------------------------
local function startAutoPunch()
    if autoPunchLoop and coroutine.status(autoPunchLoop) ~= "dead" then return end
    autoPunchLoop = task.spawn(function()
        while autoPunchEnabled do
            if character then
                local tool = character:FindFirstChild(TOOL_NAME) or backpack:FindFirstChild(TOOL_NAME)
                if tool and tool.Parent == backpack then
                    equipTool(tool)
                end
                if tool then
                    tool:Activate()
                end
            end
            task.wait(0.01) -- 10ms fast punch
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
-- Teleport function
-- -------------------------
local function teleportToRock(rockName)
    if not rockName or rockName == "none" then return end
    local rockModel = workspace.machinesFolder:FindFirstChild(rockName)
    if not rockModel then return end

    local rockPart = rockModel:FindFirstChild("Rock")
    if not rockPart then return end

    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Calculate safe nearby position: bottom side of rock
    local offset = Vector3.new(0, -rockPart.Size.Y/2 - 3, 0)
    hrp.CFrame = CFrame.new(rockPart.Position + offset)
end

-- -------------------------
-- UI Dropdown & Toggle
-- -------------------------
glitch:Dropdown({
    Text = "Choose Rock",
    List = rocks,
    Default = "Muscle King Mountain",
    ChangeTextOnPick = true,
    Flag = "RockChoice",
    Callback = function(option)
        selectedRock = option
        warn("Selected rock:", selectedRock)
    end
})

glitch:Toggle({
    Text = "Auto Punch",
    Default = false,
    Callback = function(Value)
        autoPunchEnabled = Value
        character = player.Character
        if Value then
            teleportToRock(selectedRock)
            startAutoPunch()
            warn("Auto Punch enabled at rock:", selectedRock)
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
    character = char
    if autoPunchEnabled then
        task.wait(0.1)
        teleportToRock(selectedRock)
        startAutoPunch()
    end
end)

if player.Character then
    character = player.Character
end
-- Auto Rock Punch
