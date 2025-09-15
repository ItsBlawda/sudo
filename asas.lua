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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Remotes
local muscleEvent = player:WaitForChild("muscleEvent")
local guiDamageEvent = ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("guiDamageEvent")

-- Punch tool
local TOOL_NAME = "Punch"
local backpack = player:WaitForChild("Backpack")
local character = player.Character or player.CharacterAdded:Wait()

-- Rock list
local rocks = {"Ancient Jungle Rock", "Muscle King Mountain", "Rock OF Legends", "Frozen Rock", "Inferno Rock", "none"}
local selectedRock = nil
local rockPunchEnabled = false
local punchingLoop = nil

-- Equip tool helper
local function equipPunch()
    local tool = character:FindFirstChild(TOOL_NAME) or backpack:FindFirstChild(TOOL_NAME)
    if tool and tool.Parent == backpack and character:FindFirstChild("Humanoid") then
        character.Humanoid:EquipTool(tool)
    end
    return character:FindFirstChild(TOOL_NAME)
end

-- Start rock punching
local function startRockPunch()
    if punchingLoop and coroutine.status(punchingLoop) ~= "dead" then
        task.cancel(punchingLoop)
    end

    punchingLoop = task.spawn(function()
        while rockPunchEnabled and selectedRock and selectedRock ~= "none" do
            character = player.Character
            if character then
                local tool = equipPunch()
                local leftTrail = character:FindFirstChild("LeftHand") and character.LeftHand:FindFirstChild("handTrail")
                local rightTrail = character:FindFirstChild("RightHand") and character.RightHand:FindFirstChild("handTrail")
                local rockModel = workspace.machinesFolder:FindFirstChild(selectedRock)
                local rockPart = rockModel and rockModel:FindFirstChild("Rock")

                if tool and leftTrail and rightTrail and rockPart then
                    -- Activate tool (simulate punch)
                    tool:Activate()

                    -- Fire remotes
                    muscleEvent:FireServer("punch", "rightHand")
                    muscleEvent:FireServer("punch", "leftHand")
                    firesignal(guiDamageEvent.OnClientEvent, "punchTrails", leftTrail, rightTrail, "leftHand")
                    firesignal(guiDamageEvent.OnClientEvent, "punchTrails", leftTrail, rightTrail, "rightHand")
                    firesignal(guiDamageEvent.OnClientEvent, "rockPunch", rockPart, leftTrail, rightTrail, "leftHand")
                end
            end
            task.wait(0.01) -- 10ms ultra-fast loop
        end
    end)
end

-- Stop punching
local function stopRockPunch()
    if punchingLoop then
        task.cancel(punchingLoop)
        punchingLoop = nil
    end
end

-- Dropdown & Toggle
glitch:Dropdown({
    Text = "Choose Rock",
    List = rocks,
    Default = nil,
    ChangeTextOnPick = true,
    Flag = "RockChoice",
    Callback = function(option)
        selectedRock = option
        if rockPunchEnabled then
            startRockPunch()
        end
    end
})

glitch:Toggle({
    Text = "Rock Auto Punch",
    Default = false,
    Callback = function(Value)
        rockPunchEnabled = Value
        if Value then
            if selectedRock and selectedRock ~= "none" then
                startRockPunch()
            else
                warn("No rock selected!")
            end
        else
            stopRockPunch()
        end
    end
})

-- Respawn handling
player.CharacterAdded:Connect(function(char)
    character = char
    if rockPunchEnabled and selectedRock and selectedRock ~= "none" then
        task.wait(0.1)
        startRockPunch()
    end
end)

-- Auto Rock Punch
