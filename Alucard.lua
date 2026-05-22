-- ════════════════════════════════════════
--  Chargement de la librairie Obsidian
-- ════════════════════════════════════════
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/addons/SaveManager.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/addons/ThemeManager.lua"))()

-- ════════════════════════════════════════
--  Version & Jeu
-- ════════════════════════════════════════
local VersionBuild = game:HttpGet("https://raw.githubusercontent.com/Nonock542/HellsingHubAotr/refs/heads/main/Version.txt")
VersionBuild = VersionBuild:gsub("%s+", "")

local GameId = game.PlaceId
local GameList = {
	[13379208636] = "Attack on Titan Revolution",
	[137301051741540] = "Trolling experience",
}

local GameName = GameList[GameId] or "Unknown Game"

-- ════════════════════════════════════════
--  Création de la fenêtre principale
-- ════════════════════════════════════════
local Window = Library:CreateWindow({
	Title      = "Alucard",
	Footer     = "Game: " .. GameName .. " | Build: " .. VersionBuild,
	Icon       = "paint-bucket",
	NotifySide = "Right",
})

-- ════════════════════════════════════════
--  Onglets
-- ════════════════════════════════════════
local Tabs = {
	Home       = Window:AddTab({ Name = "Home",        Icon = "door-closed", Description = "Homepage" }),
	Main       = Window:AddTab({ Name = "Main",        Icon = "house" }),
	Exploits   = Window:AddTab({ Name = "Exploits",    Icon = "bug" }),
	Visuals    = Window:AddTab({ Name = "Visuals",     Icon = "scan-eye" }),
	Floor      = Window:AddTab({ Name = "Floor",       Icon = "sparkles" }),
	UISettings = Window:AddTab({ Name = "UI Settings", Icon = "settings" }),
	Info       = Window:AddTab({ Name = "Info",        Icon = "info" }),
}

-- ════════════════════════════════════════
--  Onglet HOME
-- ════════════════════════════════════════
local HomeLeft  = Tabs.Home:AddLeftGroupbox("Account")
local HomeRight = Tabs.Home:AddRightGroupbox("Script Status")

local Player = game:GetService("Players").LocalPlayer
local TimeHour = tonumber(os.date("%H"))
local Greeting = TimeHour < 12 and "Good morning" or TimeHour < 18 and "Good afternoon" or "Good evening"

HomeLeft:AddLabel({ Text = Greeting .. " <b>" .. Player.Name .. "</b>! Welcome back to Alucard!", DoesWrap = true })
HomeLeft:AddDivider()
HomeLeft:AddButton({
	Text = "Discord Server",
	Func = function()
		setclipboard("https://discord.gg/TONLIEN")
		Library:Notify("Lien Discord copié !", 3)
	end,
})

HomeRight:AddLabel({
	Text = table.concat({
		"🟢 Attack on Titan Revolution",
		-- ajoute tes jeux supportés ici
	}, "\n"),
	DoesWrap = true,
})

-- ════════════════════════════════════════
--  Onglet MAIN
-- ════════════════════════════════════════
local MainLeft = Tabs.Main:AddLeftGroupbox("Main Features")
MainLeft:AddLabel({ Text = "Fonctionnalités principales.", DoesWrap = true })

-- ════════════════════════════════════════
--  Onglet EXPLOITS
-- ════════════════════════════════════════
local ExploitsLeft = Tabs.Exploits:AddLeftGroupbox("Exploits")
ExploitsLeft:AddLabel({ Text = "Exploits.", DoesWrap = true })

-- ════════════════════════════════════════
--  Onglet VISUALS
-- ════════════════════════════════════════
local VisualsLeft = Tabs.Visuals:AddLeftGroupbox("Visuals")
VisualsLeft:AddLabel({ Text = "Options visuelles.", DoesWrap = true })

-- ════════════════════════════════════════
--  Onglet FLOOR
-- ════════════════════════════════════════
local FloorLeft = Tabs.Floor:AddLeftGroupbox("Floor")
FloorLeft:AddLabel({ Text = "Options de sol.", DoesWrap = true })

-- ════════════════════════════════════════
--  Onglet UI SETTINGS
-- ════════════════════════════════════════
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.UISettings)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("Alucard")
SaveManager:BuildConfigSection(Tabs.UISettings)

-- ════════════════════════════════════════
--  Onglet INFO
-- ════════════════════════════════════════
local InfoLeft = Tabs.Info:AddLeftGroupbox("Informations")
InfoLeft:AddLabel({ Text = "<b>Alucard</b>", DoesWrap = false })
InfoLeft:AddLabel({ Text = "Build: " .. VersionBuild, DoesWrap = false })
InfoLeft:AddDivider()
InfoLeft:AddLabel({ Text = "Développé par Nonock542.", DoesWrap = true })

-- ════════════════════════════════════════
--  Sauvegarde
-- ════════════════════════════════════════
SaveManager:LoadAutoloadConfig()
-- ════════════════════════════════════════
--  Chargement de la librairie Obsidian
-- ════════════════════════════════════════
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/addons/SaveManager.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/addons/ThemeManager.lua"))()

-- ════════════════════════════════════════
--  Version & Jeu
-- ════════════════════════════════════════
local VersionBuild = game:HttpGet("https://raw.githubusercontent.com/Nonock542/HellsingHubAotr/refs/heads/main/Version.txt")
VersionBuild = VersionBuild:gsub("%s+", "")

local GameId = game.PlaceId
local GameList = {
	[13379208636] = "Attack on Titan Revolution",
	[137301051741540] = "Trolling experience",
}

local GameName = GameList[GameId] or "Unknown Game"

-- ════════════════════════════════════════
--  Création de la fenêtre principale
-- ════════════════════════════════════════
local Window = Library:CreateWindow({
	Title      = "Alucard",
	Footer     = "Game: " .. GameName .. " | Build: " .. VersionBuild,
	Icon       = "paint-bucket",
	NotifySide = "Right",
})

-- ════════════════════════════════════════
--  Onglets
-- ════════════════════════════════════════
local Tabs = {
	Home       = Window:AddTab({ Name = "Home",        Icon = "door-closed", Description = "Homepage" }),
	Main       = Window:AddTab({ Name = "Main",        Icon = "house" }),
	Exploits   = Window:AddTab({ Name = "Exploits",    Icon = "bug" }),
	Visuals    = Window:AddTab({ Name = "Visuals",     Icon = "scan-eye" }),
	Floor      = Window:AddTab({ Name = "Floor",       Icon = "sparkles" }),
	UISettings = Window:AddTab({ Name = "UI Settings", Icon = "settings" }),
	Info       = Window:AddTab({ Name = "Info",        Icon = "info" }),
}

-- ════════════════════════════════════════
--  Onglet HOME
-- ════════════════════════════════════════
local HomeLeft  = Tabs.Home:AddLeftGroupbox("Account")
local HomeRight = Tabs.Home:AddRightGroupbox("Script Status")

local Player = game:GetService("Players").LocalPlayer
local TimeHour = tonumber(os.date("%H"))
local Greeting = TimeHour < 12 and "Good morning" or TimeHour < 18 and "Good afternoon" or "Good evening"

HomeLeft:AddLabel({ Text = Greeting .. " <b>" .. Player.Name .. "</b>! Welcome back to Alucard!", DoesWrap = true })
HomeLeft:AddDivider()
HomeLeft:AddButton({
	Text = "Discord Server",
	Func = function()
		setclipboard("https://discord.gg/TONLIEN")
		Library:Notify("Lien Discord copié !", 3)
	end,
})

HomeRight:AddLabel({
	Text = table.concat({
		"🟢 Attack on Titan Revolution",
		-- ajoute tes jeux supportés ici
	}, "\n"),
	DoesWrap = true,
})

-- ════════════════════════════════════════
--  Onglet MAIN
-- ════════════════════════════════════════
local MainLeft = Tabs.Main:AddLeftGroupbox("Main Features")
MainLeft:AddLabel({ Text = "Fonctionnalités principales.", DoesWrap = true })

-- ════════════════════════════════════════
--  Onglet EXPLOITS
-- ════════════════════════════════════════
local ExploitsLeft = Tabs.Exploits:AddLeftGroupbox("Exploits")
ExploitsLeft:AddLabel({ Text = "Exploits.", DoesWrap = true })

-- ════════════════════════════════════════
--  Onglet VISUALS
-- ════════════════════════════════════════
local VisualsLeft = Tabs.Visuals:AddLeftGroupbox("Visuals")
VisualsLeft:AddLabel({ Text = "Options visuelles.", DoesWrap = true })

-- ════════════════════════════════════════
--  Onglet FLOOR
-- ════════════════════════════════════════
local FloorLeft = Tabs.Floor:AddLeftGroupbox("Floor")
FloorLeft:AddLabel({ Text = "Options de sol.", DoesWrap = true })

-- ════════════════════════════════════════
--  Onglet UI SETTINGS
-- ════════════════════════════════════════
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.UISettings)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("Alucard")
SaveManager:BuildConfigSection(Tabs.UISettings)

-- ════════════════════════════════════════
--  Onglet INFO
-- ════════════════════════════════════════
local InfoLeft = Tabs.Info:AddLeftGroupbox("Informations")
InfoLeft:AddLabel({ Text = "<b>Alucard</b>", DoesWrap = false })
InfoLeft:AddLabel({ Text = "Build: " .. VersionBuild, DoesWrap = false })
InfoLeft:AddDivider()
InfoLeft:AddLabel({ Text = "Développé par Nonock542.", DoesWrap = true })

-- ════════════════════════════════════════
--  Sauvegarde
-- ════════════════════════════════════════
SaveManager:LoadAutoloadConfig()
