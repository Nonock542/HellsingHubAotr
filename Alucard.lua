-- mspaint v4 - Script Lua utilisant Obsidian UI Library
-- Documentation : https://docs.mspaint.cc/obsidian

-- ════════════════════════════════════════
--  Chargement de la librairie Obsidian
-- ════════════════════════════════════════
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local SaveManager  = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/addons/SaveManager.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/addons/ThemeManager.lua"))()

-- ════════════════════════════════════════
--  Création de la fenêtre principale
-- ════════════════════════════════════════
local Window = Library:CreateWindow({
    Title      = "mspaint v4",
    Footer     = "Game: DOORS | Build: 0.2.9.9",
    Icon       = "paint-bucket", -- icône lucide.dev
    NotifySide = "Right",
})

-- ════════════════════════════════════════
--  Onglets (sidebar)
-- ════════════════════════════════════════
local Tabs = {
    Home         = Window:AddTab({ Name = "Home",        Icon = "door-closed",  Description = "Homepage for mspaint" }),
    Main         = Window:AddTab({ Name = "Main",        Icon = "house" }),
    Exploits     = Window:AddTab({ Name = "Exploits",    Icon = "bug" }),
    Visuals      = Window:AddTab({ Name = "Visuals",     Icon = "scan-eye" }),
    Floor        = Window:AddTab({ Name = "Floor",       Icon = "sparkles" }),
    UISettings   = Window:AddTab({ Name = "UI Settings", Icon = "settings" }),
    Info         = Window:AddTab({ Name = "Info",        Icon = "info" }),
    Addons       = Window:AddTab({ Name = "Addons",      Icon = "boxes" }),
}

-- ════════════════════════════════════════
--  Onglet HOME
-- ════════════════════════════════════════
local HomeLeft  = Tabs.Home:AddLeftGroupbox("Account")
local HomeRight = Tabs.Home:AddRightGroupbox("Script Status")

-- --- Colonne gauche : Account ---

-- Image/Viewport du joueur (indisponible → label placeholder)
HomeLeft:AddLabel({ Text = "<font color='rgb(150,150,150)'>[Unavailable]</font>", DoesWrap = false })

HomeLeft:AddLabel({ Text = "Good afternoon <b>Player</b>! Welcome back to mspaint!", DoesWrap = true })

HomeLeft:AddDivider()

HomeLeft:AddButton({
    Text = "Script Dashboard",
    Func = function()
        -- Ouvrir le dashboard du script
        Library:Notify("Ouverture du Script Dashboard...", 3)
    end,
})

HomeLeft:AddButton({
    Text = "Main Server",
    Func = function()
        Library:Notify("Lien : discord.gg/mspaint", 4)
    end,
})

HomeLeft:AddButton({
    Text = "Support Server",
    Func = function()
        Library:Notify("Lien : discord.gg/mspaint-support", 4)
    end,
})

-- --- Colonne droite : Script Status ---

HomeRight:AddLabel({
    Text = table.concat({
        "🟢 <font color='rgb(66,149,245)'>DOORS</font>",
        "🟢 Fisch",
        "🟢 The Forge",
        "🟢 99 Nights In The Forest",
        "🟢 Pressure",
        "🟢 3008",
        "🟢 Rooms & Doors",
        "🟢 Build A Boat For Treasure",
        "🟢 Grace",
        "🔴 Dead Rails",
        "🟢 Murder Mystery 2",
        "🟢 Word Bomb",
        "🟢 Notoriety",
    }, "\n"),
    DoesWrap = true,
})

HomeRight:AddDivider()

HomeRight:AddLabel({
    Text = "Vous pouvez signaler des bugs ou suggérer des fonctionnalités dans le dashboard en ligne :",
    DoesWrap = true,
})

HomeRight:AddButton({
    Text = "Copier le lien",
    Func = function()
        -- setclipboard si disponible
        if setclipboard then
            setclipboard("https://www.mspaint.cc/dashboard")
            Library:Notify("Lien copié dans le presse-papiers !", 3)
        else
            Library:Notify("setclipboard non disponible sur cet executor.", 3)
        end
    end,
})

-- ════════════════════════════════════════
--  Onglet MAIN  (à compléter selon vos besoins)
-- ════════════════════════════════════════
local MainLeft = Tabs.Main:AddLeftGroupbox("Main Features")
MainLeft:AddLabel({ Text = "Ajoutez vos fonctionnalités principales ici.", DoesWrap = true })

-- ════════════════════════════════════════
--  Onglet EXPLOITS
-- ════════════════════════════════════════
local ExploitsLeft = Tabs.Exploits:AddLeftGroupbox("Exploits")
ExploitsLeft:AddLabel({ Text = "Ajoutez vos exploits ici.", DoesWrap = true })

-- ════════════════════════════════════════
--  Onglet VISUALS
-- ════════════════════════════════════════
local VisualsLeft = Tabs.Visuals:AddLeftGroupbox("Visuals")
VisualsLeft:AddLabel({ Text = "Ajoutez vos options visuelles ici.", DoesWrap = true })

-- ════════════════════════════════════════
--  Onglet FLOOR
-- ════════════════════════════════════════
local FloorLeft = Tabs.Floor:AddLeftGroupbox("Floor")
FloorLeft:AddLabel({ Text = "Ajoutez vos options de sol ici.", DoesWrap = true })

-- ════════════════════════════════════════
--  Onglet UI SETTINGS  → ThemeManager
-- ════════════════════════════════════════
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.UISettings)

-- ════════════════════════════════════════
--  Onglet ADDONS  → SaveManager
-- ════════════════════════════════════════
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("mspaint")
SaveManager:BuildConfigSection(Tabs.Addons)

-- ════════════════════════════════════════
--  Onglet INFO
-- ════════════════════════════════════════
local InfoLeft = Tabs.Info:AddLeftGroupbox("Informations")

InfoLeft:AddLabel({ Text = "<b>mspaint v4</b>", DoesWrap = false })
InfoLeft:AddLabel({ Text = "Build: 0.2.9.9", DoesWrap = false })
InfoLeft:AddDivider()
InfoLeft:AddLabel({ Text = "Développé par mstudio45.", DoesWrap = true })
InfoLeft:AddButton({
    Text = "Site officiel",
    Func = function()
        Library:Notify("https://www.mspaint.cc", 5)
    end,
})

-- ════════════════════════════════════════
--  Chargement du profil de sauvegarde
-- ════════════════════════════════════════
SaveManager:LoadAutoloadConfig()
