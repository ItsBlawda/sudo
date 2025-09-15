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

-- Auto Rock Punch
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local TOOL_NAME = "Punch"
local character

-- Rock list (sorted)
local rocks = {
    "Ancient Jungle Rock",
    "Muscle King Mountain",
    "Rock OF Legends",
    "Frozen Rock",
    "Inferno Rock",
    "none"
}

local selectedRock = nil
local punchingLoop = nil
local rockPunchEnabled = false

-- Helper to get Punch tool
local function getPunchTool()
	return backpack:FindFirstChild(TOOL_NAME) or (character and character:FindFirstChild(TOOL_NAME))
end

-- Helper to get the MeshPart named "Rock" inside a model
local function getHitPart(modelName)
    local model = workspace.machinesFolder:FindFirstChild(modelName)
    if model then
        local rockPart = model:FindFirstChild("Rock") -- must be MeshPart
        if rockPart and rockPart:IsA("BasePart") then
            return rockPart
        end
    end
    return nil
end

local function startRockPunch()
    if punchingLoop and coroutine.status(punchingLoop) ~= "dead" then
        task.cancel(punchingLoop)
    end
    punchingLoop = task.spawn(function()
        while rockPunchEnabled and selectedRock and selectedRock ~= "none" do
            local tool = getPunchTool()
            if tool then
                -- Equip if needed
                if tool.Parent == backpack and character then
                    character.Humanoid:EquipTool(tool)
                end

                -- Apply Fast Punch
                if tool:FindFirstChild("attackTime") then
                    tool.attackTime.Value = 0
                end

                local hitPart = getHitPart(selectedRock)
                if hitPart then
                    task.defer(function()
                        tool:Activate() -- reach punch without moving
                    end)
                else
                    warn("Rock MeshPart not found:", selectedRock)
                end
            end
            task.wait(0.01)
        end
    end)
end



-- Stop punching
local function stopPunching()
	if punchingLoop then
		task.cancel(punchingLoop)
		punchingLoop = nil
	end
end

-- Dropdown for rock selection
glitch:Dropdown({
	Text = "Choose Rock",
	List = rocks,
	Default = nil,
	ChangeTextOnPick = true,
	Flag = "RockChoice",
	Callback = function(option)
		selectedRock = option
		warn("Selected rock:", option)
		if rockPunchEnabled then
			startPunching(option) -- restart loop on new rock
		end
	end
})

-- Toggle for enabling/disabling punching
glitch:Toggle({
	Text = "Rock Auto Punch",
	Default = false,
	Callback = function(Value)
		rockPunchEnabled = Value
		if Value then
			if selectedRock and selectedRock ~= "none" then
				startPunching(selectedRock)
				warn("Rock Auto Punch enabled for " .. selectedRock)
			else
				warn("No rock selected!")
			end
		else
			stopPunching()
			warn("Rock Auto Punch disabled")
		end
	end
})

-- Respawn handling
player.CharacterAdded:Connect(function(char)
	character = char
	if rockPunchEnabled and selectedRock and selectedRock ~= "none" then
		task.wait(0.1)
		startPunching(selectedRock)
	end
end)

if player.Character then
	character = player.Character
end
-- Auto Rock Punch
