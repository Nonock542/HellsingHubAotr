-- ════════════════════════════════════════
--  OBSIDIAN + HELLSING HUB (STABLE)
-- ════════════════════════════════════════

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/addons/SaveManager.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/addons/ThemeManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Player = Players.LocalPlayer
local char = Player.Character or Player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- Toutes les connexions à couper à l'unload
local Connections = {}
local Unloaded = false

local function track(conn)
    table.insert(Connections, conn)
    return conn
end

track(Player.CharacterAdded:Connect(function(c)
    char = c
    hrp = c:WaitForChild("HumanoidRootPart")
    humanoid = c:WaitForChild("Humanoid")
end))

-- ════════════════════════════════════════
--  AUTO EXECUTE (relance après téléportation)
-- ════════════════════════════════════════

local SCRIPT_URL = "https://raw.githubusercontent.com/Nonock542/HellsingHubAotr/refs/heads/main/Alucard.lua"

local env = getgenv and getgenv() or _G

local queueTeleport = queue_on_teleport
    or (env.syn and env.syn.queue_on_teleport)
    or (env.fluxus and env.fluxus.queue_on_teleport)

local reloadQueued = false

local function QueueReload()
    if reloadQueued then return end
    if not queueTeleport then
        Library:Notify("Ton exécuteur ne supporte pas queue_on_teleport", 4)
        return
    end
    reloadQueued = true

    -- Concaténation (et non :format) pour éviter tout souci avec les "%" dans le code
    queueTeleport([[
        if not game:IsLoaded() then game.Loaded:Wait() end
        local ok, src = pcall(game.HttpGet, game, "]] .. SCRIPT_URL .. [[")
        if not ok then return warn("[Alucard] HttpGet a échoué: " .. tostring(src)) end
        local fn, err = loadstring(src)
        if not fn then
            local n = tonumber(tostring(err):match(":(%d+):"))
            if n then
                local lines = string.split(src, "\n")
                warn("[Alucard] Ligne " .. n .. ": " .. tostring(lines[n]))
            end
            return warn("[Alucard] Script invalide: " .. tostring(err))
        end
        fn()
    ]])
end

-- ════════════════════════════════════════
--  GLISSE FUNCTION
-- ════════════════════════════════════════

local isGliding = false
local glideConn = nil

local function glisseTo(targetPos, speed)
    if isGliding or Unloaded then return end
    isGliding = true
    speed = speed or 400

    local startPos = hrp.Position
    local distance = (targetPos - startPos).Magnitude
    local duration = math.max(distance / speed, 0.05)
    local elapsed = 0

    humanoid.PlatformStand = true

    glideConn = RunService.Heartbeat:Connect(function(dt)
        elapsed += dt
        local alpha = math.min(elapsed / duration, 1)

        hrp.CFrame = CFrame.new(startPos:Lerp(targetPos, alpha))

        if alpha >= 1 then
            glideConn:Disconnect()
            glideConn = nil
            humanoid.PlatformStand = false
            isGliding = false
        end
    end)
end

-- ════════════════════════════════════════
--  NOFOG SYSTEM
-- ════════════════════════════════════════

local NoFogEnabled = false
local FogBackup = nil
local AtmosphereConns = {}

local function EnableNoFog()
    NoFogEnabled = true

    if not FogBackup then
        FogBackup = {
            Brightness = Lighting.Brightness,
            ClockTime = Lighting.ClockTime,
            GlobalShadows = Lighting.GlobalShadows,
            Atmospheres = {},
        }
    end

    Lighting.Brightness = 4.07
    Lighting.ClockTime = 13.1
    Lighting.GlobalShadows = false

    for _, v in ipairs(Lighting:GetDescendants()) do
        if v:IsA("Atmosphere") then
            if FogBackup.Atmospheres[v] == nil then
                FogBackup.Atmospheres[v] = v.Density
            end
            v.Density = 0.2
            table.insert(AtmosphereConns, v:GetPropertyChangedSignal("Density"):Connect(function()
                if NoFogEnabled then v.Density = 0.2 end
            end))
        end
    end
end

local function DisableNoFog()
    NoFogEnabled = false
    for _, c in ipairs(AtmosphereConns) do c:Disconnect() end
    table.clear(AtmosphereConns)

    if FogBackup then
        Lighting.Brightness = FogBackup.Brightness
        Lighting.ClockTime = FogBackup.ClockTime
        Lighting.GlobalShadows = FogBackup.GlobalShadows
        for atmo, density in pairs(FogBackup.Atmospheres) do
            if atmo.Parent then atmo.Density = density end
        end
        FogBackup = nil
    end
end

-- ════════════════════════════════════════
--  LOGO
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

local AOT_MISSION_PLACES = {
    [13379349730] = true, [13904207646] = true, [14012874501] = true,
    [14638336319] = true, [15220308770] = true, [15824912319] = true,
    [17688739434] = true
}

local function isAOTMission()
    return AOT_MISSION_PLACES[game.PlaceId] == true
end

local GameName = GameListInfo[game.PlaceId] and "AOT:R" or "Unknown"
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
    Home       = Window:AddTab({ Name = "Home",        Icon = "door-closed" }),
    Main       = Window:AddTab({ Name = "Main",        Icon = "house"       }),
    Visuals    = Window:AddTab({ Name = "Visuals",     Icon = "scan-eye"    }),
    UISettings = Window:AddTab({ Name = "UI Settings", Icon = "settings"    }),
    Info       = Window:AddTab({ Name = "Info",        Icon = "info"        }),
}

-- ════════════════════════════════════════
--  HOME
-- ════════════════════════════════════════

local HomeLeft  = Tabs.Home:AddLeftGroupbox("Account")
local HomeRight = Tabs.Home:AddRightGroupbox("Status")

HomeLeft:AddLabel({ Text = "Welcome " .. Player.Name, DoesWrap = true })
HomeLeft:AddDivider()

HomeRight:AddLabel({
    Text = table.concat({
        "🟢 " .. GameName,
        "",
        "🟡 Attack on Titan Revolution",
    }, "\n"),
    DoesWrap = true
})

-- ════════════════════════════════════════
--  MAIN
-- ════════════════════════════════════════

local Misc       = Tabs.Main:AddLeftGroupbox("Misc",       "gamepad-directional")
local Movement   = Tabs.Main:AddRightGroupbox("Movement",  "move")
local Automation = Tabs.Main:AddLeftGroupbox("Automation", "cpu")
local MainRight  = Tabs.Main:AddRightGroupbox("Main Features")

-- ════════════════════════════════════════
--  MISC
-- ════════════════════════════════════════

Misc:AddButton("Return to Lobby", function()
    TeleportService:Teleport(14916516914, Player)
end)

Misc:AddButton({
    Text = "Check Shadow Ban (Lobby)",
    Func = function()
        if game.PlaceId ~= 14916516914 then
            Library:Notify("You're not in the lobby", 4)
            return
        end
        local Blacklisted = Player:GetAttribute("Blacklisted")
        local Exploiter   = Player:GetAttribute("Exploiter")
        if Blacklisted == true or Exploiter == true then
            Library:Notify("You're Shadow Ban", 4)
        else
            Library:Notify("You're not Shadow Ban", 4)
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
--  UNLOAD
-- ════════════════════════════════════════

Misc:AddDivider()

Misc:AddButton({
    Text = "Unload",
    DoubleClick = true, -- évite un clic accidentel (supprime cette ligne si tu n'en veux pas)
    Func = function()
        Library:Unload()
    end
})

-- Nettoyage : appelé automatiquement par Library:Unload()
Library:OnUnload(function()
    Unloaded = true

    -- Coupe l'auto farm
    if Toggles.AutoFarm then Toggles.AutoFarm:SetValue(false) end

    -- Coupe toutes les connexions
    for _, c in ipairs(Connections) do
        if c.Connected then c:Disconnect() end
    end
    table.clear(Connections)

    -- Arrête le glissement en cours et rend le contrôle du perso
    if glideConn then
        glideConn:Disconnect()
        glideConn = nil
    end
    isGliding = false
    if humanoid then humanoid.PlatformStand = false end

    -- Restaure l'éclairage
    DisableNoFog()

    -- Restaure le FOV
    local cam = workspace.CurrentCamera
    if cam then cam.FieldOfView = 70 end
end)

-- ════════════════════════════════════════
--  MOVEMENT
-- ════════════════════════════════════════

Movement:AddDropdown("MovementMode", {
    Text    = "Movement Mode",
    Values  = {"Hover", "Teleport"},
    Default = "Hover",
    Multi   = false,
})

local HoverSetting = Movement:AddDependencyBox()

HoverSetting:AddSlider("HoverSpeed", {
    Text     = "Hover Speed",
    Default  = 400,
    Min      = 0,
    Max      = 600,
    Rounding = 0,
})

HoverSetting:AddSlider("FloatHeight", {
    Text     = "Float Height",
    Default  = 200,
    Min      = 0,
    Max      = 300,
    Rounding = 0,
})

HoverSetting:SetupDependencies({
    { Options.MovementMode, "Hover" },
})

-- ════════════════════════════════════════
--  AUTOMATION
-- ════════════════════════════════════════

Automation:AddToggle("AutoFarm", {
    Text    = "Auto Farm",
    Default = false,
})

local NAPE_SIZE = Vector3.new(200, 200, 200)

local function prepareNape(titan)
    local hitboxes = titan:FindFirstChild("Hitboxes")
    local hit  = hitboxes and hitboxes:FindFirstChild("Hit")
    local nape = hit and hit:FindFirstChild("Nape")
    if not (nape and nape:IsA("BasePart")) then return end

    if nape.Transparency ~= 0 then nape.Transparency = 0 end
    if nape.Size ~= NAPE_SIZE then nape.Size = NAPE_SIZE end

    -- Désactive les autres Parts de Hit
    for _, part in ipairs(hit:GetChildren()) do
        if part:IsA("BasePart") and part ~= nape then
            part.CanTouch = false
            part.CanQuery = false
        end
    end
end

-- Loop principal AutoFarm
track(RunService.Heartbeat:Connect(function()
    if Unloaded then return end
    if not Toggles.AutoFarm.Value then return end
    if not isAOTMission() then return end
    if isGliding then return end

    local Titans = workspace:FindFirstChild("Titans")
    if not Titans then return end

    local FloatHeight = Options.FloatHeight.Value
    local HoverSpeed  = Options.HoverSpeed.Value

    local closestTitan    = nil
    local closestDistance = math.huge

    for _, titan in pairs(Titans:GetChildren()) do
        local titanHRP = titan:FindFirstChild("HumanoidRootPart")
        if titanHRP then
            local distance = (hrp.Position - titanHRP.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestTitan    = titan
            end
        end
    end

    if closestTitan then
        local titanHRP = closestTitan:FindFirstChild("HumanoidRootPart")
        if titanHRP then
            prepareNape(closestTitan)

            local targetPos = Vector3.new(
                titanHRP.Position.X,
                titanHRP.Position.Y + FloatHeight,
                titanHRP.Position.Z
            )
            glisseTo(targetPos, HoverSpeed)
        end
    end
end))

-- ════════════════════════════════════════
--  MAIN FEATURES
-- ════════════════════════════════════════

MainRight:AddToggle("NoFog", {
    Text     = "No Fog",
    Default  = false,
    Callback = function(v)
        if v then EnableNoFog() else DisableNoFog() end
    end
})

-- ════════════════════════════════════════
--  VISUALS
-- ════════════════════════════════════════

local Visuals = Tabs.Visuals:AddLeftGroupbox("Visuals")

Visuals:AddSlider("FOV", {
    Text     = "FOV",
    Default  = 70,
    Min      = 70,
    Max      = 120,
    Rounding = 0,
    Callback = function(v)
        workspace.CurrentCamera.FieldOfView = v
    end
})

Visuals:AddToggle("AutoExecute", {
    Text     = "Auto Execute",
    Default  = false,
    Callback = function(v)
        if v then
            QueueReload()
        else
            reloadQueued = false
        end
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
Info:AddDivider()
Info:AddLabel({ Text = "Game: " .. GameNameInfo })

-- ════════════════════════════════════════
--  LOAD CONFIG
-- ════════════════════════════════════════

pcall(function()
    SaveManager:LoadAutoloadConfig()
end)

if Toggles.AutoExecute.Value then QueueReload() end

Library:Notify("Alucard loaded successfully!", 5)
