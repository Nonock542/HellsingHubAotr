-- ════════════════════════════════════════
--  OBSIDIAN + HELLSING HUB (STABLE)
-- ════════════════════════════════════════

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/addons/SaveManager.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/addons/ThemeManager.lua"))()

local Options = Library.Options

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local char = Player.Character
local hrp = char:FindFirstChild("HumanoidRootPart")

-- ════════════════════════════════════════
--  NOFOG SYSTEM
-- ════════════════════════════════════════

local Lighting = game:GetService("Lighting")

local NoFogEnabled = false
local FogConnection

local function EnableNoFog()
	NoFogEnabled = true

    Lighting.Brightness = 4.07
    Lighting.ClockTime = 13.1
    Lighting.GlobalShadows = false

	-- Remove Atmosphere fog
	for _, v in ipairs(Lighting:GetDescendants()) do
		if v:IsA("Atmosphere") then
			v.Density = 0.2

			v:GetPropertyChangedSignal("Density"):Connect(function()
				if NoFogEnabled then
					v.Density = 0.2
				end
			end)
		end
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

-- Une seule source de vérité
local GameListInfo = {
	[13379208636] = "Attack on Titan Revolution",	
	[13379349730] = "[AOT:R] Shiganshina",
	[13904207646] = "[AOT:R] Outskirts",
	[14012874501] = "[AOT:R] Trost",
	[14638336319] = "[AOT:R] Forest",
	[14916516914] = "[AOT:R] Town Central",
	[14932214603] = "[AOT:R] Trade Central",
	[15220308770] = "[AOT:R] Utgard",
	[15824912319] = "[AOT:R] Stohess",
	[17688739434] = "[AOT:R] Docks",
	[137301051741540] = "Trolling Experience",
}

-- IDs des missions uniquement (pas de hub/lobby)
local AOT_MISSION_PLACES = {
	[13379349730] = true, [13904207646] = true, [14012874501] = true,
	[14638336319] = true, [15220308770] = true, [15824912319] = true,
	[17688739434] = true
}

local function isAOTMission()
	return AOT_MISSION_PLACES[game.PlaceId] == true
end

-- GameName dérivé depuis GameListInfo
local GameName = GameListInfo[game.PlaceId] and "AOT:R" or GameListInfo[game.PlaceId]
local GameNameInfo = GameListInfo[game.PlaceId] or "Unknown"

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
	Footer = GameName .. " | Build: " .. VersionBuild,
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
local Movement = Tabs.Main:AddRightGroupbox("Movement", "move")
local Automation = Tabs.Main:AddLeftGroupbox("Automation", "cpu")
local MainRight = Tabs.Main:AddRightGroupbox("Main Features")

-- ════════════════════════════════════════
--  Misc
-- ════════════════════════════════════════

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

Misc:AddButton({
	Text = "Join Discord",
	Func = function()
		setclipboard("https://discord.gg/")
		Library:Notify("Discord copied!", 3)
	end
})

-- ════════════════════════════════════════
--  Movement
-- ════════════════════════════════════════

Movement:AddDropdown("MovementMode", {
	Text = "Movement Mode",
	Values = {"Hover", "Teleport"},
	Default = "Hover",
	Multi = false,
})

local HoverSetting = Movement:AddDependencyBox()

HoverSetting:AddSlider("HoverSpeed", {
    Text = "Hover Speed",
    Default = 400,
    Min = 0,
    Max = 600,
    Rounding = 0,
})

HoverSetting:AddSlider("FloatHeight", {
    Text = "Float Height",
    Default = 200,
    Min = 0,
    Max = 300,
    Rounding = 0,
})

HoverSetting:SetupDependencies({
    { Options.MovementMode, "Hover" },
})

-- ════════════════════════════════════════
--  Automation
-- ════════════════════════════════════════

Automation:AddToggle("AutoFarm", {
	Text = "Auto Farm",
	Default = false,
    Callback = function(v)
        if not isAOTMission() then return end
		local Titans = Workspace:WaitForChild("Titans")
		local FloatHeight = Options.FloatHeight.Value
		local HoverSpeed = Options.HoverSpeed.Value

		local closestTitan = nil
		local closestDistance = math.huge

		for _, titan in pairs(Titans:GetChildren()) do
			local titanHRP = titan:FindFirstChild("HumanoidRootPart")

			if titanHRP then
				local distance = (hrp.Position - titanHRP.Position).Magnitude

				if distance < closestDistance then
					closestDistance = distance
            		closestTitan = titan
				end
			end
		end

		if closestTitan then
		local TargetPos = Vector3.new(
			closestTitan.HumanoidRootPart.Position.X,
			closestTitan.HumanoidRootPart.Position.Y + FloatHeight,
			closestTitan.HumanoidRootPart.Position.Z
			)
		
		
		

end})


MainRight:AddToggle("NoFog", {
	Text = "No Fog",
	Default = false,

	Callback = function(v)
		if v then
			EnableNoFog()
			print("NoFog ON")
		return
		end
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

Visuals:AddToggle("AutoExecute", {
	Text = "Auto Execute",
	Default = false,

	CallBack = function(v)
		if v then return end
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
Info:AddDivider()
Info:AddLabel({ Text = "Game: " .. GameNameInfo })

-- ════════════════════════════════════════
--  LOAD CONFIG
-- ════════════════════════════════════════

pcall(function()
	SaveManager:LoadAutoloadConfig()
end)

Library:Notify("Alucard loaded successfully!", 5)
