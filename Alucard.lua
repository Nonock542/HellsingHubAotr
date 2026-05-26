-- ════════════════════════════════════════
--  OBSIDIAN + HELLSING HUB (STABLE)
-- ════════════════════════════════════════

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/addons/SaveManager.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/addons/ThemeManager.lua"))()

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

-- ════════════════════════════════════════
--  HOVER SYSTEM
-- ════════════════════════════════════════

local HoverEnabled = false
local TargetHeight = nil
local HoverConnection

local function StartHover()
	if HoverConnection then HoverConnection:Disconnect() end

	HoverConnection = RunService.RenderStepped:Connect(function()
		if not HoverEnabled then return end

		local char = Player.Character
		if not char then return end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		local pos = hrp.Position

		hrp.AssemblyLinearVelocity = Vector3.zero
        local newY = hrp.Position.Y + (TargetHeight - hrp.Position.Y) * 0.2
        hrp.CFrame = CFrame.new(pos.X, newY, pos.Z)
	end)
end

local function StopHover()
	if HoverConnection then
		HoverConnection:Disconnect()
		HoverConnection = nil
	end
end

-- ════════════════════════════════════════
--  NOFOG SYSTEM
-- ════════════════════════════════════════

local Lighting = game:GetService("Lighting")

local NoFogEnabled = false
local FogConnection

local function EnableNoFog()
	NoFogEnabled = true

    Lighting.Brightness = 3
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false

	-- Keep enforcing FogEnd
	FogConnection = Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
		if NoFogEnabled then
			Lighting.FogEnd = 100000
		end
	end)

	-- Remove Atmosphere fog
	for _, v in ipairs(Lighting:GetDescendants()) do
		if v:IsA("Atmosphere") then
			v.Density = 0

			v:GetPropertyChangedSignal("Density"):Connect(function()
				if NoFogEnabled then
					v.Density = 0
				end
			end)
		end
	end
end

local function DisableNoFog()
	NoFogEnabled = false

	if FogConnection then
		FogConnection:Disconnect()
		FogConnection = nil
	end
end

-- ════════════════════════════════════════
--  LOGO (GITHUB RAW -> LOCAL CACHE)
-- ════════════════════════════════════════

local LogoURL = "https://raw.githubusercontent.com/Nonock542/HellsingHubAotr/main/logo.jpg"

local function GetLogo()
	if isfile and writefile and getcustomasset then
		if not isfile("AlucardLogo.jpg") then
			writefile("AlucardLogo.jpg", game:HttpGet(LogoURL))
		end
		return getcustomasset("AlucardLogo.jpg")
	end

	return nil
end

-- ════════════════════════════════════════
--  VERSION / GAME
-- ════════════════════════════════════════

local VersionBuild = game:HttpGet("https://raw.githubusercontent.com/Nonock542/HellsingHubAotr/refs/heads/main/Version.txt")
VersionBuild = VersionBuild:gsub("%s+", "")

local GameList = {
	[13379208636 and 14916516914] = "Attack on Titan Revolution",
	[137301051741540] = "Trolling Experience",
}

local GameName = GameList[game.PlaceId] or game.Name

-- ════════════════════════════════════════
--  THEME DEFAULT
-- ════════════════════════════════════════

local DefaultTheme = {
	FontFace = "Gotham",
	BackgroundColor = Color3.fromRGB(10, 10, 10),
	MainColor = Color3.fromRGB(20, 20, 20),
	AccentColor = Color3.fromRGB(170, 0, 0),
	OutlineColor = Color3.fromRGB(40, 0, 0),
	FontColor = Color3.fromRGB(255, 255, 255)
}

-- ════════════════════════════════════════
--  WINDOW
-- ════════════════════════════════════════

local Window = Library:CreateWindow({
	Title = "Alucard Hub",
	Footer = "Game: " .. GameName .. " | Build: " .. VersionBuild,
	Icon = GetLogo(),
	NotifySide = "Right",
})

Library:SetFont(Font.fromEnum(Enum.Font.GothamMedium))

-- ════════════════════════════════════════
--  TABS
-- ════════════════════════════════════════

local Tabs = {
	Home = Window:AddTab({ Name = "Home", Icon = "door-closed" }),
	Main = Window:AddTab({ Name = "Main", Icon = "house" }),
	Visuals = Window:AddTab({ Name = "Visuals", Icon = "scan-eye" }),
	UISettings = Window:AddTab({ Name = "UI Settings", Icon = "settings" }),
	Info = Window:AddTab({ Name = "Info", Icon = "info" }),
}

-- ════════════════════════════════════════
--  HOME
-- ════════════════════════════════════════

local HomeLeft = Tabs.Home:AddLeftGroupbox("Account")
local HomeRight = Tabs.Home:AddRightGroupbox("Status")

HomeLeft:AddLabel({
	Text = "Welcome " .. Player.Name,
	DoesWrap = true
})

HomeLeft:AddDivider()

HomeLeft:AddButton({
	Text = "Discord",
	Func = function()
		setclipboard("https://discord.gg/TONLIEN")
		Library:Notify("Discord copied!", 3)
	end
})

HomeRight:AddLabel({
	Text = table.concat({
		"🟢 " .. GameName,
		"",
		"🟡 Attack on Titan Revolution",
		-- ajoute tes jeux supportés ici
	}, "\n"),
	DoesWrap = true
})

-- ════════════════════════════════════════
--  MAIN
-- ════════════════════════════════════════
local Misc = Tabs.Main:AddLeftGroupbox("Misc", "gamepad-directional")
local MainRight = Tabs.Main:AddRightGroupbox("Main Features")

Misc:AddButton("Return to Lobby", function()
	TeleportService:Teleport(
		14916516914
		,Player
		)
end)

Misc:AddButton({
	Text = "Check Shadow Ban (Lobby)",

	Func = function()
		if game.PlaceId ~= 14916516914 then
			Library:Notify("You're not in the lobby", 4)
			return
		end

		local Blacklisted = Player:GetAttribute("Blacklisted")
		local Exploiter = Player:GetAttribute("Exploiter")
		
		if Blacklisted == true or Exploiter == true then
			Library:Notify("You're Shadow Ban", 4)
		else
			Library:Notify("You'r not Shadow Ban", 4)
		end
	end
})

MainRight:AddToggle("NoFog", {
	Text = "No Fog",
	Default = false,

	Callback = function(v)
		if v then
			EnableNoFog()
			print("NoFog ON")
		else
			DisableNoFog()
			print("NoFog OFF")
		end
	end
})

MainRight:AddButton({
	Text = "WalkSpeed 50",
	Func = function()
		local char = Player.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.WalkSpeed = 50
			Library:Notify("WalkSpeed set to 50", 3)
		end
	end
})

-- 🔥 HOVER HEIGHT TOGGLE
MainRight:AddToggle("Hover", {
	Text = "Hover Height",
	Default = false,
	Callback = function(v)
		HoverEnabled = v

		if v then
			StartHover()
			Library:Notify("Hover ON", 2)
		else
			StopHover()
			Library:Notify("Hover OFF", 2)
		end
	end
})

MainRight:AddSlider("Hover", {
	Text = "Hover Height",
	Default = 100,
	Min = 0,
	Max = 300,
	Rounding = 0,

	Callback = function(Value)
		TargetHeight = Value
	end
})
-- ════════════════════════════════════════
--  VISUALS
-- ════════════════════════════════════════

local Visuals = Tabs.Visuals:AddLeftGroupbox("Visuals")

Visuals:AddSlider("FOV", {
	Text = "FOV",
	Default = 70,
	Min = 70,
	Max = 120,
	Callback = function(v)
		workspace.CurrentCamera.FieldOfView = v
	end
})

-- ════════════════════════════════════════
--  UI SETTINGS
-- ════════════════════════════════════════

ThemeManager:SetLibrary(Library)
ThemeManager:SetDefaultTheme(DefaultTheme)
ThemeManager:ApplyToTab(Tabs.UISettings)

SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("Alucard")
SaveManager:BuildConfigSection(Tabs.UISettings)

-- ════════════════════════════════════════
--  INFO
-- ════════════════════════════════════════

local Info = Tabs.Info:AddLeftGroupbox("Info", "info")

Info:AddLabel({ Text = "<b>Alucard Hub</b>" })
Info:AddLabel({ Text = "Version: " .. VersionBuild })
Info:AddLabel({ Text = "Made by Nonock542" })

-- ════════════════════════════════════════
--  LOAD CONFIG
-- ════════════════════════════════════════

pcall(function()
	SaveManager:LoadAutoloadConfig()
end)

Library:Notify("Alucard loaded successfully!", 5)
