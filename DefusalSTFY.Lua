--[[
    Defusal Cheat - FULL IMPLEMENTATION
    Red Black Gradient Theme
    All features wired from original document
]]

-- ============ SERVICES ============
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CS = game:GetService("CollectionService")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = workspace.CurrentCamera

cloneref = cloneref or function(o) return o end
local RS = cloneref(RS)

-- ============ CLIENT CHECKS ============
local C = {
    Require = pcall(function() return require end),
    Getsenv = pcall(function() return getsenv end),
    Mousemoverel = pcall(function() return mousemoverel end),
    Hookmm = pcall(function() return hookmetamethod end),
    Hookf = pcall(function() return hookfunction end),
    Sethidden = pcall(function() return sethiddenproperty end),
}
C.FullRequire = C.Require
C.FullGetsenv = C.Getsenv

-- ============ ANTI-AFK / NETWORK ============
pcall(function()
    local f = game:GetService("NetworkClient")
    if f.SetOutgoingKBPSLimit then f:SetOutgoingKBPSLimit(0) end
end)
pcall(function()
    if LP.PlayerScripts:FindFirstChild("ImAFKBruh") then
        LP.PlayerScripts.ImAFKBruh.Disabled = true
        LP.PlayerScripts.ImAFKBruh:GetPropertyChangedSignal("Disabled"):Connect(function()
            LP.PlayerScripts.ImAFKBruh.Disabled = true
        end)
    end
end)

-- ============ CONFIG ============
local F = {
    -- Legit
    SilentAim=false, SilentHitChance=100,
    Aimbot=false, AimbotSpeed=10, AimbotType="Mouse Movement", AimbotActivate="Mouse 1",
    Triggerbot=false, TriggerbotDelay=0,
    LegitFov=false, LegitFovVisible=false, LegitFovValue=25, LegitFovColor=Color3.new(1,1,1), LegitFovSides=100,
    LegitHitscan="Head",
    -- Rage
    Ragebot=false, RageSilentAim=false, SimulateShoot=false, AutoWall=false, ForceDamage=false,
    MinDamage=80, RageHitscan={"Head"}, RageDebug=false,
    RageFov=false, RageFovVisible=false, RageFovValue=25, RageFovColor=Color3.new(1,1,1), RageFovSides=100,
    RapidFire=false, ForceHeadshot=false, DoubleTap=false, AllowThrowables=false,
    NoscopeIcon=false, BackstabIcon=false,
    Knifebot=false, KnifebotSimulateStab=false, KnifebotWallCheck=false, KnifebotRadius=7,
    AntiAim=false, AntiAimYaw="Camera", AntiAimPitch="Custom", AntiAimSpinSpeed=3,
    AntiAimCustomYaw=0, AntiAimCustomPitch=0, FakeDuck=false,
    -- Visuals
    Esp=false, EspBox=false, EspBoxType="Default", EspBoxColor=Color3.new(1,1,1),
    EspName=false, EspNameColor=Color3.new(1,1,1),
    EspWeapon=false, EspWeaponColor=Color3.new(1,1,1),
    EspDistance=false, EspDistanceColor=Color3.new(1,1,1),
    EspHealthBar=false, EspHealthFull=Color3.fromRGB(255,0,0), EspHealthDying=Color3.fromRGB(0,255,0),
    EspHealthNumber=false, EspHealthNumberColor=Color3.new(1,1,1),
    EspChams=false, EspChamsVis=Color3.new(1,1,1), EspChamsInvis=Color3.fromRGB(149,255,139),
    EspTextFont="Plex", EspTextSize=13, EspShowPriorities=false, EspPrioritiesColor=Color3.fromRGB(245,239,120),
    ThrowableEsp=false, ThrowableName=false, ThrowableNameColor=Color3.new(1,1,1),
    ThrowableChams=false, ThrowableChamsOutline=Color3.new(1,1,1), ThrowableChamsFill=Color3.fromRGB(149,255,139),
    Ambient=false, AmbientColor=Color3.fromRGB(149,255,139), OutdoorAmbientColor=Color3.fromRGB(129,255,129),
    NoBlur=false, NoFlash=false, NoSmoke=false,
    BombStatus=false, BombStatusColor=Color3.fromRGB(149,255,139),
    BombChams=false, BombChamsOutline=Color3.new(1,1,1), BombChamsFill=Color3.fromRGB(149,255,139),
    BulletTracers=false, BulletTracersStart=Color3.new(1,1,1), BulletTracersEnd=Color3.fromRGB(149,255,139),
    BulletTracersTexture="Line", BulletTracersLifetime=3,
    HitImpacts=false, HitImpactsColor=Color3.new(1,1,1), HitImpactsLifetime=6,
    TimeChanger=false, TimeValue=12,
    SkyboxChanger=false, SkyboxType="--",
    ViewmodelOffset=false, ViewmodelX=0, ViewmodelY=0, ViewmodelZ=0,
    WeaponChams=false, WeaponChamsColor=Color3.fromRGB(149,255,139),
    TextureChanger=false, WeaponTexture="Red + White",
    NoJumpBob=false, NoArmsBob=false, NoArmsSway=false,
    CustomHitSound=false, HitSoundName="Default Hit Sound", HitSoundVolume=2,
    CustomKillSound=false, KillSoundName="Default Kill Sound", KillSoundVolume=2,
    ThirdPerson=false, ThirdPersonDistance=9,
    -- Misc
    BypassSpeed=false, AutoJump=false, Noclip=false,
    SpeedHack=false, SpeedHackSpeed=40,
    Airstuck=false, Pixelsurf=false, Edgebug=false, EdgebugNotification=false, EdgebugDebounce=0.2,
    KillAll=false, KillAllHPS=1, AntiSpectate=false, AntiSpectateType="Low Fov",
    AutoJoinTeam=false, JoinTeam="Operators",
    ChatSpam=false, ChatSpamType="Neyrone", ChatSpamCustom="Neyrone on top!!",
    NoRecoil=false, NoSpread=false, FullAuto=false, RapidFireGun=false, ConvertAmmo=false, InfiniteAmmo=false,
    LaserMineType="Touch", AutoActivateLaserMines=false, AllowYoursLaserMines=false, RemoveLaser=false,
    TeleportThrowables=false,
    -- Priority
    PriorityKill=false, PriorityHPS=1, PriorityFlashIntensity=1,
    -- Flashbang
    FlashIntensity=1,
    -- Plant C4
    PlantSite="A",
    -- Skins
    KnifeEnabled=false, KnifeType=nil, GlovesEnabled=false, GloveType=nil,
}

-- ============ GAME REFS ============
local G = {
    Network=nil, Ambassador=nil, Variables=nil, Shucky=nil, Appearance=nil, BaseWeapon=nil,
    FireEvent=nil, EquippedWeapon=nil, EquippedWeaponFolder=nil,
    IsAlive = function(p)
        return p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart")
            and p.Character:FindFirstChild("Torso") and p.Character:FindFirstChild("Humanoid")
            and (p:GetAttribute("Health") or 0) > 0 and p:GetAttribute("Team") ~= "Spectator" and p:GetAttribute("Alive")
    end,
    IsC4 = function() return workspace.Debris:FindFirstChild("PlantedC4") end,
    IsDM = function() return RS:GetAttribute("NoTKPenalty") end,
}

local OrigLight = {Ambient=Lighting.Ambient, Outdoor=Lighting.OutdoorAmbient, Clock=Lighting.ClockTime}

-- ============ REQUIRE MODULES ============
if C.Require then
    pcall(function() G.Network = require(game:GetService("ReplicatedFirst").Network) end)
    pcall(function() G.Ambassador = require(game:GetService("ReplicatedFirst").Ambassador) end)
    pcall(function() G.Variables = require(game:GetService("ReplicatedFirst").Variables) end)
    pcall(function() G.Shucky = require(RS.Modules.Shucky) end)
    pcall(function() G.Appearance = require(RS.Modules.Appearance) end)
    if not (G.Network and G.Ambassador and G.Variables) then C.FullRequire = false end
end
if C.Getsenv then
    pcall(function() G.BaseWeapon = getsenv(LP.PlayerScripts.PlayerBase.BaseWeapon) end)
    if not (G.BaseWeapon and G.BaseWeapon.firebullet) then C.FullGetsenv = false end
end

-- ============ FIRE EVENT ============
local function fireRemoteName(seed)
    local t = math.max(1, math.floor(seed) % 2147483647)
    local r = {}
    for i=1,24 do
        t = t * 48271 % 2147483647
        local idx = t % 62 + 1
        r[i] = string.sub("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", idx, idx)
    end
    return "sus_" .. table.concat(r)
end
local function getFireEvent()
    if C.Require and G.Shucky and G.Shucky.activateresult and debug and debug.getupvalue and setthreadidentity then
        local id = getthreadidentity(); setthreadidentity(2)
        local fn = debug.getupvalue(G.Shucky.activateresult, 5)
        local res = fn(); setthreadidentity(id); return res
    else
        local s = RS:GetAttribute("AmongUsSauce")
        while typeof(s) ~= "number" do RS:GetAttributeChangedSignal("AmongUsSauce"):Wait(); s = RS:GetAttribute("AmongUsSauce") end
        return RS:WaitForChild("Events"):WaitForChild(fireRemoteName(s))
    end
end
G.FireEvent = getFireEvent()
RS:GetAttributeChangedSignal("AmongUsSauce"):Connect(function() G.FireEvent = getFireEvent() end)

-- ============ EQUIP TRACKER ============
local function updEquip()
    if G.IsAlive(LP) then
        G.EquippedWeapon = LP.Character:GetAttribute("WhatGun")
        G.EquippedWeaponFolder = RS.Weapons:FindFirstChild(G.EquippedWeapon)
    end
end
if LP.Character then
    updEquip()
    LP.Character:GetAttributeChangedSignal("WhatGun"):Connect(updEquip)
end
LP.CharacterAdded:Connect(function(ch)
    ch:GetAttributeChangedSignal("WhatGun"):Connect(updEquip)
    updEquip()
end)

-- ============ DATA TABLES ============
local WeaponTextures = {
    ["Red + White"]="rbxassetid://73492024663403", ["Black + Grey"]="rbxassetid://99819667028441",
    Web="rbxassetid://81960247728644", Pink="rbxassetid://14003986744", Violet="rbxassetid://18876565862",
    Lego="rbxassetid://13654261927", ["Red + Black"]="rbxassetid://18993843644", ["Dark Blue + Black"]="rbxassetid://12703804272",
    Shark="rbxassetid://12859888187", Camo="rbxassetid://1848173837", Lava="rbxassetid://5013453655",
    ["Black + White Leaves"]="rbxassetid://1982429041", Red="rbxassetid://4786129416",
}
local Sounds = {
    ["Default Hit Sound"]=tostring(RS.Sounds.HitSound.Value),
    ["Default Kill Sound"]=tostring(RS.Sounds.KillSound.Value),
    Bameware="rbxassetid://3124331820", Bell="rbxassetid://6534947240", Bubble="rbxassetid://6534947588",
    Pick="rbxassetid://1347140027", Pop="rbxassetid://198598793", Rust="rbxassetid://1255040462",
    Skeet="rbxassetid://5447626464", ["Mario Coin"]="rbxassetid://5709456554", ["COD Hitmarker"]="rbxassetid://160432334",
    ["Minecraft XP"]="rbxassetid://1053296915", Neverlose="rbxassetid://6607204501", Fatality="rbxassetid://6534947869",
}
local TracerTex = {Line="rbxassetid://9150663556", Neyrone="rbxassetid://1825953680", Lighting="rbxassetid://446111271", Tracer="ForceField"}
local Skyboxes = {
    ["--"]={},
    Galaxy={SkyboxBk="rbxassetid://159454299",SkyboxDn="rbxassetid://159454296",SkyboxFt="rbxassetid://159454293",SkyboxLf="rbxassetid://159454286",SkyboxRt="rbxassetid://159454300",SkyboxUp="rbxassetid://159454288"},
    Purple={SkyboxBk="rbxassetid://570557514",SkyboxDn="rbxassetid://570557775",SkyboxFt="rbxassetid://570557559",SkyboxLf="rbxassetid://570557620",SkyboxRt="rbxassetid://570557672",SkyboxUp="rbxassetid://570557727"},
    ["Purple Night"]={SkyboxBk="rbxassetid://296908715",SkyboxDn="rbxassetid://296908724",SkyboxFt="rbxassetid://296908740",SkyboxLf="rbxassetid://296908755",SkyboxRt="rbxassetid://296908764",SkyboxUp="rbxassetid://296908769"},
    ["Night Sky"]={SkyboxBk="rbxassetid://12064107",SkyboxDn="rbxassetid://12064152",SkyboxFt="rbxassetid://12064121",SkyboxLf="rbxassetid://12063984",SkyboxRt="rbxassetid://12064115",SkyboxUp="rbxassetid://12064131"},
    ["Pink Daylight"]={SkyboxBk="rbxassetid://271042516",SkyboxDn="rbxassetid://271077243",SkyboxFt="rbxassetid://271042556",SkyboxLf="rbxassetid://271042310",SkyboxRt="rbxassetid://271042467",SkyboxUp="rbxassetid://271077958"},
    ["Morning Glow"]={SkyboxBk="rbxassetid://1417494030",SkyboxDn="rbxassetid://1417494146",SkyboxFt="rbxassetid://1417494253",SkyboxLf="rbxassetid://1417494402",SkyboxRt="rbxassetid://1417494499",SkyboxUp="rbxassetid://1417494643"},
    ["Setting Sun"]={SkyboxBk="rbxassetid://626460377",SkyboxDn="rbxassetid://626460216",SkyboxFt="rbxassetid://626460513",SkyboxLf="rbxassetid://626473032",SkyboxRt="rbxassetid://626458639",SkyboxUp="rbxassetid://626460625"},
    ["Fade Blue"]={SkyboxBk="rbxassetid://153695414",SkyboxDn="rbxassetid://153695352",SkyboxFt="rbxassetid://153695452",SkyboxLf="rbxassetid://153695320",SkyboxRt="rbxassetid://153695383",SkyboxUp="rbxassetid://153695471"},
    ["Elegant Morning"]={SkyboxBk="rbxassetid://153767241",SkyboxDn="rbxassetid://153767216",SkyboxFt="rbxassetid://153767266",SkyboxLf="rbxassetid://153767200",SkyboxRt="rbxassetid://153767231",SkyboxUp="rbxassetid://153767288"},
    Neptune={SkyboxBk="rbxassetid://218955819",SkyboxDn="rbxassetid://218953419",SkyboxFt="rbxassetid://218954524",SkyboxLf="rbxassetid://218958493",SkyboxRt="rbxassetid://218957134",SkyboxUp="rbxassetid://218950090"},
    Redshift={SkyboxBk="rbxassetid://401664839",SkyboxDn="rbxassetid://401664862",SkyboxFt="rbxassetid://401664960",SkyboxLf="rbxassetid://401664881",SkyboxRt="rbxassetid://401664901",SkyboxUp="rbxassetid://401664936"},
    ["Aesthetic Night"]={SkyboxBk="rbxassetid://1045964490",SkyboxDn="rbxassetid://1045964368",SkyboxFt="rbxassetid://1045964655",SkyboxLf="rbxassetid://1045964655",SkyboxRt="rbxassetid://1045964655",SkyboxUp="rbxassetid://1045962969"},
}

-- ============ SKIN DATA ============
local SkinsData = {
    Weapons={Settings={}, Replacements={}},
    Knives={List={}, Settings={}, Replacements={}, CurrentType=nil},
    Gloves={List={}, Settings={}, CurrentType=nil},
}
for _, w in ipairs(RS.Weapons:GetChildren()) do
    if w:GetAttribute("WeaponType") == "Melee" then table.insert(SkinsData.Knives.List, w.Name) end
end
for _, g in ipairs(RS.Gloves:GetChildren()) do table.insert(SkinsData.Gloves.List, g.Name) end
if #SkinsData.Knives.List > 0 then SkinsData.Knives.CurrentType = SkinsData.Knives.List[1] end
if #SkinsData.Gloves.List > 0 then SkinsData.Gloves.CurrentType = SkinsData.Gloves.List[1] end

-- ============ UI LIBRARY ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DefusalRedBlack"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LP:WaitForChild("PlayerGui")

local function animGrad(parent, colors, speed)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(colors)
    g.Rotation = 0
    g.Parent = parent
    task.spawn(function()
        local t = 0
        while parent.Parent do
            t = t + (speed or 2)
            g.Rotation = t % 360
            task.wait(0.03)
        end
    end)
    return g
end

-- OPEN BUTTON
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 120, 0, 42)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -21)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30,0,0)
OpenBtn.Text = "MENU"
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 16
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)
animGrad(OpenBtn, {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180,20,20)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80,0,0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180,20,20)),
}, 3)

-- MAIN FRAME
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 620, 0, 460)
Main.Position = UDim2.new(0.5, -310, 0.5, -230)
Main.BackgroundColor3 = Color3.fromRGB(10,0,0)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = Color3.fromRGB(180,20,20); mainStroke.Thickness = 1.5
animGrad(Main, {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40,0,0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18,0,0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40,0,0)),
}, 1)

-- TITLE
local Title = Instance.new("Frame")
Title.Size = UDim2.new(1,0,0,42)
Title.BackgroundColor3 = Color3.fromRGB(25,0,0)
Title.BorderSizePixel = 0
Title.Parent = Main
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)
animGrad(Title, {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200,20,20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60,0,0)),
}, 4)
local TitleLbl = Instance.new("TextLabel", Title)
TitleLbl.Size = UDim2.new(1,-100,1,0); TitleLbl.Position = UDim2.new(0,15,0,0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = "DEFUSAL | RED BLACK"
TitleLbl.TextColor3 = Color3.new(1,1,1)
TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 18
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Title)
CloseBtn.Size = UDim2.new(0,30,0,30); CloseBtn.Position = UDim2.new(1,-38,0,6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150,20,20)
CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,6)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

-- Drag
local drag, ds, sp
Title.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true; ds=i.Position; sp=Main.Position end end)
Title.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
UIS.InputChanged:Connect(function(i)
    if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
        local d = i.Position - ds
        Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
    end
end)

-- TABS
local TabBar = Instance.new("Frame", Main)
TabBar.Size = UDim2.new(1,-10,0,40); TabBar.Position = UDim2.new(0,5,0,47)
TabBar.BackgroundTransparency = 1
local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0,4)

local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(1,-20,1,-95); Content.Position = UDim2.new(0,10,0,92)
Content.BackgroundTransparency = 1; Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4; Content.ScrollBarImageColor3 = Color3.fromRGB(180,20,20)
Content.CanvasSize = UDim2.new(0,0,0,0)
local CLayout = Instance.new("UIListLayout", Content); CLayout.Padding = UDim.new(0,6)
local CPad = Instance.new("UIPadding", Content); CPad.PaddingTop = UDim.new(0,5); CPad.PaddingLeft = UDim.new(0,5); CPad.PaddingRight = UDim.new(0,5)

local Tabs, CurrentTab = {}, nil

local function Section(parent, txt)
    local s = Instance.new("Frame", parent)
    s.Size = UDim2.new(1,-10,0,30); s.BackgroundColor3 = Color3.fromRGB(40,5,5); s.BorderSizePixel = 0
    Instance.new("UICorner", s).CornerRadius = UDim.new(0,6)
    animGrad(s, {ColorSequenceKeypoint.new(0,Color3.fromRGB(90,10,10)),ColorSequenceKeypoint.new(1,Color3.fromRGB(30,0,0))}, 1.5)
    local l = Instance.new("TextLabel", s)
    l.Size = UDim2.new(1,-20,1,0); l.Position = UDim2.new(0,10,0,0)
    l.BackgroundTransparency = 1; l.Text = txt; l.TextColor3 = Color3.fromRGB(255,100,100)
    l.Font = Enum.Font.GothamBold; l.TextSize = 13; l.TextXAlignment = Enum.TextXAlignment.Left
    return s
end

local function Toggle(parent, name, def, cb)
    local fr = Instance.new("Frame", parent)
    fr.Size = UDim2.new(1,-20,0,28); fr.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", fr)
    l.Size = UDim2.new(1,-60,1,0); l.BackgroundTransparency = 1; l.Text = name
    l.TextColor3 = Color3.fromRGB(220,200,200); l.Font = Enum.Font.Gotham; l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    local b = Instance.new("TextButton", fr)
    b.Size = UDim2.new(0,40,0,20); b.Position = UDim2.new(1,-45,0.5,-10)
    b.BackgroundColor3 = Color3.fromRGB(50,0,0); b.Text = ""
    Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
    local k = Instance.new("Frame", b)
    k.Size = UDim2.new(0,16,0,16); k.Position = UDim2.new(0,2,0.5,-8)
    k.BackgroundColor3 = Color3.fromRGB(150,150,150)
    Instance.new("UICorner", k).CornerRadius = UDim.new(1,0)
    local st = def or false
    local function u()
        if st then
            Tween:Create(b, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(180,20,20)}):Play()
            Tween:Create(k, TweenInfo.new(0.2), {Position=UDim2.new(1,-18,0.5,-8), BackgroundColor3=Color3.new(1,1,1)}):Play()
        else
            Tween:Create(b, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(50,0,0)}):Play()
            Tween:Create(k, TweenInfo.new(0.2), {Position=UDim2.new(0,2,0.5,-8), BackgroundColor3=Color3.fromRGB(150,150,150)}):Play()
                end
        if cb then cb(st) end
    end
    b.MouseButton1Click:Connect(function() st = not st; u() end)
    u()
    return {Set=function(v) st=v; u() end}
end

local function Slider(parent, name, mn, mx, def, cb, suf)
    local fr = Instance.new("Frame", parent)
    fr.Size = UDim2.new(1,-20,0,42); fr.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", fr)
    l.Size = UDim2.new(1,-60,0,18); l.BackgroundTransparency = 1; l.Text = name
    l.TextColor3 = Color3.fromRGB(220,200,200); l.Font = Enum.Font.Gotham; l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    local vl = Instance.new("TextLabel", fr)
    vl.Size = UDim2.new(0,50,0,18); vl.Position = UDim2.new(1,-50,0,0)
    vl.BackgroundTransparency = 1; vl.Text = tostring(def)..(suf or "")
    vl.TextColor3 = Color3.fromRGB(255,100,100); vl.Font = Enum.Font.GothamBold; vl.TextSize = 12
    vl.TextXAlignment = Enum.TextXAlignment.Right
    local bar = Instance.new("Frame", fr)
    bar.Size = UDim2.new(1,0,0,6); bar.Position = UDim2.new(0,0,0,24)
    bar.BackgroundColor3 = Color3.fromRGB(50,0,0)
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((def-mn)/(mx-mn),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(180,20,20)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)
    local val = def; local drg = false
    local function setV(v)
        val = math.clamp(v, mn, mx)
        fill.Size = UDim2.new((val-mn)/(mx-mn),0,1,0)
        vl.Text = tostring(math.floor(val*100)/100)..(suf or "")
        if cb then cb(val) end
    end
    bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drg=true; setV(mn+((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X)*(mx-mn)) end end)
    UIS.InputChanged:Connect(function(i) if drg and i.UserInputType==Enum.UserInputType.MouseMovement then setV(mn+((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X)*(mx-mn)) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drg=false end end)
    setV(def)
    return {Set=setV}
end

local function Dropdown(parent, name, items, def, cb)
    local fr = Instance.new("Frame", parent)
    fr.Size = UDim2.new(1,-20,0,28); fr.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", fr)
    l.Size = UDim2.new(1,-100,1,0); l.BackgroundTransparency = 1; l.Text = name
    l.TextColor3 = Color3.fromRGB(220,200,200); l.Font = Enum.Font.Gotham; l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    local b = Instance.new("TextButton", fr)
    b.Size = UDim2.new(0,100,0,20); b.Position = UDim2.new(1,-105,0.5,-10)
    b.BackgroundColor3 = Color3.fromRGB(50,0,0); b.Text = def or (items[1] or "")
    b.TextColor3 = Color3.fromRGB(255,100,100); b.Font = Enum.Font.Gotham; b.TextSize = 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
    local lst = Instance.new("Frame", fr)
    lst.Size = UDim2.new(0,100,0,#items*20); lst.Position = UDim2.new(1,-105,1,0)
    lst.BackgroundColor3 = Color3.fromRGB(25,0,0); lst.BorderSizePixel = 0; lst.Visible = false; lst.ZIndex = 10
    Instance.new("UICorner", lst).CornerRadius = UDim.new(0,4)
    Instance.new("UIListLayout", lst)
    local sel = def or items[1]
    for _, it in ipairs(items) do
        local ib = Instance.new("TextButton", lst)
        ib.Size = UDim2.new(1,0,0,20); ib.BackgroundTransparency = 1; ib.Text = it
        ib.TextColor3 = Color3.fromRGB(220,200,200); ib.Font = Enum.Font.Gotham; ib.TextSize = 11; ib.ZIndex = 10
        ib.MouseButton1Click:Connect(function() sel=it; b.Text=it; lst.Visible=false; if cb then cb(it) end end)
    end
    b.MouseButton1Click:Connect(function() lst.Visible = not lst.Visible end)
    return {Get=function() return sel end}
end

local function Button(parent, name, cb)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1,-20,0,28); b.BackgroundColor3 = Color3.fromRGB(80,5,5)
    b.Text = name; b.TextColor3 = Color3.fromRGB(255,150,150)
    b.Font = Enum.Font.GothamBold; b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,5)
    animGrad(b, {ColorSequenceKeypoint.new(0,Color3.fromRGB(120,10,10)),ColorSequenceKeypoint.new(1,Color3.fromRGB(60,0,0))}, 1)
    b.MouseButton1Click:Connect(function() if cb then cb() end end)
    return b
end

local function Colorpicker(parent, name, def, cb)
    local fr = Instance.new("Frame", parent)
    fr.Size = UDim2.new(1,-20,0,28); fr.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", fr)
    l.Size = UDim2.new(1,-40,1,0); l.BackgroundTransparency = 1; l.Text = name
    l.TextColor3 = Color3.fromRGB(220,200,200); l.Font = Enum.Font.Gotham; l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    local b = Instance.new("TextButton", fr)
    b.Size = UDim2.new(0,30,0,20); b.Position = UDim2.new(1,-35,0.5,-10)
    b.BackgroundColor3 = def or Color3.new(1,1,1); b.Text = ""
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
    b.MouseButton1Click:Connect(function()
        local h,s,v = b.BackgroundColor3:ToHSV()
        local nc = Color3.fromHSV((h+0.1)%1, 1, 1)
        b.BackgroundColor3 = nc
        if cb then cb(nc) end
    end)
    return {Get=function() return b.BackgroundColor3 end}
end

local function Tab(name)
    local tb = Instance.new("TextButton", TabBar)
    tb.Size = UDim2.new(0,85,1,0); tb.BackgroundColor3 = Color3.fromRGB(30,0,0)
    tb.Text = name; tb.TextColor3 = Color3.fromRGB(180,100,100)
    tb.Font = Enum.Font.GothamBold; tb.TextSize = 12
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0,6)
    animGrad(tb, {ColorSequenceKeypoint.new(0,Color3.fromRGB(80,5,5)),ColorSequenceKeypoint.new(1,Color3.fromRGB(30,0,0))}, 1)
    local tc = Instance.new("Frame", Content)
    tc.Size = UDim2.new(1,0,1,0); tc.BackgroundTransparency = 1; tc.Visible = false
    local tl = Instance.new("UIListLayout", tc); tl.Padding = UDim.new(0,6)
    local td = {Btn=tb, Content=tc, Name=name}
    table.insert(Tabs, td)
    tb.MouseButton1Click:Connect(function()
        for _, t in ipairs(Tabs) do
            t.Content.Visible = false
            Tween:Create(t.Btn, TweenInfo.new(0.2), {TextColor3=Color3.fromRGB(180,100,100)}):Play()
        end
        tc.Visible = true
        Tween:Create(tb, TweenInfo.new(0.2), {TextColor3=Color3.new(1,1,1)}):Play()
        CurrentTab = td
    end)
    if not CurrentTab then CurrentTab=td; tc.Visible=true; tb.TextColor3=Color3.new(1,1,1) end
    return tc
end

-- ============ BUILD TABS ============
do local t = Tab("Legit")
    Section(t, "Bullet Redirection")
    Toggle(t, "Silent Aim", false, function(v) F.SilentAim=v end)
    Slider(t, "Hit Chance", 0, 100, 100, function(v) F.SilentHitChance=v end, "%")
    Section(t, "Aim Assist")
    Toggle(t, "Aimbot", false, function(v) F.Aimbot=v end)
    Slider(t, "Speed", 0, 100, 10, function(v) F.AimbotSpeed=v end, "%")
    Dropdown(t, "Aim Type", {"Mouse Movement","Lerp","Stick"}, "Mouse Movement", function(v) F.AimbotType=v end)
    Dropdown(t, "Speed Type", {"Linear","Exponential"}, "Linear", function() end)
    Dropdown(t, "Activation", {"Mouse 1","Mouse 2"}, "Mouse 1", function(v) F.AimbotActivate=v end)
    Section(t, "Trigger Bot")
    Toggle(t, "Triggerbot", false, function(v) F.Triggerbot=v end)
    Slider(t, "Delay", 0, 200, 0, function(v) F.TriggerbotDelay=v end, "ms")
    Section(t, "Settings")
    Toggle(t, "Use FOV", false, function(v) F.LegitFov=v end)
    Toggle(t, "Visible FOV", false, function(v) F.LegitFovVisible=v end)
    Colorpicker(t, "FOV Color", Color3.new(1,1,1), function(c) F.LegitFovColor=c end)
    Slider(t, "FOV", 0, 80, 25, function(v) F.LegitFovValue=v end, "°")
    Slider(t, "FOV Sides", 0, 100, 100, function(v) F.LegitFovSides=v end)
    Dropdown(t, "Hitscan", {"Head","Torso"}, "Head", function(v) F.LegitHitscan=v end)
end

do local t = Tab("Rage")
    Section(t, "Rage Bot")
    Toggle(t, "Enabled", false, function(v) F.Ragebot=v end)
    Toggle(t, "Silent Aim", false, function(v) F.RageSilentAim=v end)
    Toggle(t, "Simulate Shoot", false, function(v) F.SimulateShoot=v end)
    Toggle(t, "Auto Wall", false, function(v) F.AutoWall=v end)
    Toggle(t, "Force Full Damage", false, function(v) F.ForceDamage=v end)
    Slider(t, "Minimum Damage", 1, 115, 80, function(v) F.MinDamage=v end)
    Dropdown(t, "Hitscan", {"Head","Torso","Arms","Legs"}, "Head", function(v) F.RageHitscan={v} end)
    Section(t, "Miscellaneous")
    Toggle(t, "Debug", false, function(v) F.RageDebug=v end)
    Toggle(t, "Use FOV", false, function(v) F.RageFov=v end)
    Toggle(t, "Visible FOV", false, function(v) F.RageFovVisible=v end)
    Colorpicker(t, "FOV Color", Color3.new(1,1,1), function(c) F.RageFovColor=c end)
    Slider(t, "FOV", 0, 80, 25, function(v) F.RageFovValue=v end, "°")
    Slider(t, "FOV Sides", 0, 100, 100, function(v) F.RageFovSides=v end)
    Toggle(t, "Rapid Fire", false, function(v) F.RapidFire=v end)
    Toggle(t, "Force Headshot", false, function(v) F.ForceHeadshot=v end)
    Toggle(t, "Double Tap", false, function(v) F.DoubleTap=v end)
    Toggle(t, "Allow Throwables", false, function(v) F.AllowThrowables=v end)
    Toggle(t, "Noscope Icon", false, function(v) F.NoscopeIcon=v end)
    Toggle(t, "Backstab Icon", false, function(v) F.BackstabIcon=v end)
    Section(t, "Knife Bot")
    Toggle(t, "Enabled", false, function(v) F.Knifebot=v end)
    Toggle(t, "Simulate Stab", false, function(v) F.KnifebotSimulateStab=v end)
    Toggle(t, "Wall Check", false, function(v) F.KnifebotWallCheck=v end)
    Slider(t, "Radius", 0, 7, 7, function(v) F.KnifebotRadius=v end)
    Section(t, "Anti Aim")
    Toggle(t, "Enabled", false, function(v) F.AntiAim=v end)
    Toggle(t, "Fake Duck", false, function(v) F.FakeDuck=v end)
    Dropdown(t, "Yaw Base", {"Camera","Spin","Random"}, "Camera", function(v) F.AntiAimYaw=v end)
    Dropdown(t, "Pitch Base", {"Custom","Random"}, "Custom", function(v) F.AntiAimPitch=v end)
    Slider(t, "Spin Speed", 0, 48, 3, function(v) F.AntiAimSpinSpeed=v end)
    Slider(t, "Custom Yaw", -180, 180, 0, function(v) F.AntiAimCustomYaw=v end, "°")
    Slider(t, "Custom Pitch", -100, 100, 0, function(v) F.AntiAimCustomPitch=v end, "°")
end

do local t = Tab("Visuals")
    Section(t, "Enemy ESP")
    Toggle(t, "Enabled", false, function(v) F.Esp=v end)
    Toggle(t, "Bounding Box", false, function(v) F.EspBox=v end)
    Dropdown(t, "Box Type", {"Default","3D"}, "Default", function(v) F.EspBoxType=v end)
    Colorpicker(t, "Box Color", Color3.new(1,1,1), function(c) F.EspBoxColor=c end)
    Toggle(t, "Name", false, function(v) F.EspName=v end)
    Colorpicker(t, "Name Color", Color3.new(1,1,1), function(c) F.EspNameColor=c end)
    Toggle(t, "Weapon", false, function(v) F.EspWeapon=v end)
    Colorpicker(t, "Weapon Color", Color3.new(1,1,1), function(c) F.EspWeaponColor=c end)
    Toggle(t, "Distance", false, function(v) F.EspDistance=v end)
    Colorpicker(t, "Distance Color", Color3.new(1,1,1), function(c) F.EspDistanceColor=c end)
    Toggle(t, "Health Bar", false, function(v) F.EspHealthBar=v end)
    Colorpicker(t, "Full Health Color", Color3.fromRGB(255,0,0), function(c) F.EspHealthFull=c end)
    Colorpicker(t, "Dying Health Color", Color3.fromRGB(0,255,0), function(c) F.EspHealthDying=c end)
    Toggle(t, "Health Number", false, function(v) F.EspHealthNumber=v end)
    Colorpicker(t, "Health Number Color", Color3.new(1,1,1), function(c) F.EspHealthNumberColor=c end)
    Toggle(t, "Chams", false, function(v) F.EspChams=v end)
    Colorpicker(t, "Chams Visible", Color3.new(1,1,1), function(c) F.EspChamsVis=c end)
    Colorpicker(t, "Chams Invisible", Color3.fromRGB(149,255,139), function(c) F.EspChamsInvis=c end)
    Section(t, "Esp Settings")
    Dropdown(t, "Text Font", {"Plex","System","Monospace","UI"}, "Plex", function(v) F.EspTextFont=v end)
    Slider(t, "Text Size", 0, 50, 13, function(v) F.EspTextSize=v end)
    Section(t, "Throwable ESP")
    Toggle(t, "Enabled", false, function(v) F.ThrowableEsp=v end)
    Toggle(t, "Name", false, function(v) F.ThrowableName=v end)
    Colorpicker(t, "Name Color", Color3.new(1,1,1), function(c) F.ThrowableNameColor=c end)
    Toggle(t, "Chams", false, function(v) F.ThrowableChams=v end)
    Colorpicker(t, "Chams Outline", Color3.new(1,1,1), function(c) F.ThrowableChamsOutline=c end)
    Colorpicker(t, "Chams Fill", Color3.fromRGB(149,255,139), function(c) F.ThrowableChamsFill=c end)
    Section(t, "World")
    Toggle(t, "Ambient", false, function(v)
        F.Ambient = v
        if not v then Lighting.Ambient = OrigLight.Ambient; Lighting.OutdoorAmbient = OrigLight.Outdoor end
    end)
    Colorpicker(t, "Ambient Color", Color3.fromRGB(149,255,139), function(c) F.AmbientColor=c end)
    Colorpicker(t, "Outdoor Color", Color3.fromRGB(129,255,129), function(c) F.OutdoorAmbientColor=c end)
    Toggle(t, "No Blur", false, function(v)
        F.NoBlur = v
        local blur = Lighting:FindFirstChildOfClass("BlurEffect")
        if blur then blur.Enabled = not v end
    end)
    Toggle(t, "No Flash", false, function(v)
        F.NoFlash = v
        local fe = LP.PlayerScripts.PlayerBase:FindFirstChild("FlashbangEffect")
        if fe then fe.Disabled = v end
    end)
    Toggle(t, "No Smoke", false, function(v) F.NoSmoke=v end)
    Toggle(t, "Bomb Status", false, function(v) F.BombStatus=v end)
    Colorpicker(t, "Bomb Status Color", Color3.fromRGB(149,255,139), function(c) F.BombStatusColor=c end)
    Toggle(t, "Bomb Chams", false, function(v) F.BombChams=v end)
    Colorpicker(t, "Bomb Outline", Color3.new(1,1,1), function(c) F.BombChamsOutline=c end)
    Colorpicker(t, "Bomb Fill", Color3.fromRGB(149,255,139), function(c) F.BombChamsFill=c end)
    Toggle(t, "Bullet Tracers", false, function(v) F.BulletTracers=v end)
    Colorpicker(t, "Tracer Start", Color3.new(1,1,1), function(c) F.BulletTracersStart=c end)
    Colorpicker(t, "Tracer End", Color3.fromRGB(149,255,139), function(c) F.BulletTracersEnd=c end)
    local tnames = {}
    for k in pairs(TracerTex) do table.insert(tnames, k) end
    Dropdown(t, "Tracer Texture", tnames, "Line", function(v) F.BulletTracersTexture=v end)
    Slider(t, "Tracer Lifetime", 0, 10, 3, function(v) F.BulletTracersLifetime=v end, "s")
    Toggle(t, "Hit Impacts", false, function(v) F.HitImpacts=v end)
    Colorpicker(t, "Impact Color", Color3.new(1,1,1), function(c) F.HitImpactsColor=c end)
    Slider(t, "Impact Lifetime", 0, 10, 6, function(v) F.HitImpactsLifetime=v end, "s")
    Toggle(t, "Time Changer", false, function(v)
        F.TimeChanger = v
        if not v then Lighting.ClockTime = OrigLight.Clock end
    end)
    Slider(t, "Time", 0, 24, 12, function(v) F.TimeValue=v end)
    Toggle(t, "Skybox Changer", false, function(v)
        F.SkyboxChanger=v
        if not v then pcall(function() if Lighting:FindFirstChild("Skyboxzz") then Lighting.Skyboxzz:Destroy() end end) end
    end)
    Dropdown(t, "Skybox Type", {"--","Galaxy","Purple","Purple Night","Pink Daylight","Night Sky","Morning Glow","Setting Sun","Fade Blue","Elegant Morning","Neptune","Redshift","Aesthetic Night"}, "--", function(v) F.SkyboxType=v end)
    Section(t, "Viewmodel")
    Toggle(t, "Viewmodel Offset", false, function(v) F.ViewmodelOffset=v end)
    Slider(t, "Offset X", -180, 180, 0, function(v) F.ViewmodelX=v end)
    Slider(t, "Offset Y", -180, 180, 0, function(v) F.ViewmodelY=v end)
    Slider(t, "Offset Z", -180, 180, 0, function(v) F.ViewmodelZ=v end)
    Section(t, "Weapon")
    Toggle(t, "Chams", false, function(v) F.WeaponChams=v end)
    Colorpicker(t, "Chams Color", Color3.fromRGB(149,255,139), function(c) F.WeaponChamsColor=c end)
    Toggle(t, "Texture Changer", false, function(v) F.TextureChanger=v end)
    local tex = {}
    for k in pairs(WeaponTextures) do table.insert(tex, k) end
    Dropdown(t, "Texture", tex, tex[1], function(v) F.WeaponTexture=v end)
    Section(t, "Arms")
    Toggle(t, "Remove Jump Bob", false, function(v) F.NoJumpBob=v end)
    Toggle(t, "Remove Arms Bob", false, function(v) F.NoArmsBob=v end)
    Toggle(t, "Remove Arms Sway", false, function(v) F.NoArmsSway=v end)
    Section(t, "Sound Effects")
    local snds = {}
    for k in pairs(Sounds) do table.insert(snds, k) end
    Toggle(t, "Custom Hit Sound", false, function(v) F.CustomHitSound=v end)
    Dropdown(t, "Hit Sound", snds, "Default Hit Sound", function(v) F.HitSoundName=v end)
    Slider(t, "Hit Volume", 0, 5, 2, function(v) F.HitSoundVolume=v end)
    Toggle(t, "Custom Kill Sound", false, function(v) F.CustomKillSound=v end)
    Dropdown(t, "Kill Sound", snds, "Default Kill Sound", function(v) F.KillSoundName=v end)
    Slider(t, "Kill Volume", 0, 5, 2, function(v) F.KillSoundVolume=v end)
    Section(t, "Self")
    Toggle(t, "Third Person", false, function(v) F.ThirdPerson=v end)
    Slider(t, "Third Person Distance", 1, 20, 9, function(v) F.ThirdPersonDistance=v end)
end

do local t = Tab("Misc")
    Section(t, "Movement")
    Toggle(t, "Bypass Speed Limit", false, function(v) F.BypassSpeed=v end)
    Toggle(t, "Automatic Jump", false, function(v) F.AutoJump=v end)
    Toggle(t, "Noclip", false, function(v) F.Noclip=v end)
    Toggle(t, "Speed Hack", false, function(v) F.SpeedHack=v end)
    Slider(t, "Speed Hack Speed", 16, 250, 40, function(v) F.SpeedHackSpeed=v end)
    Toggle(t, "Airstuck", false, function(v) F.Airstuck=v end)
    Toggle(t, "Pixelsurf", false, function(v) F.Pixelsurf=v end)
    Toggle(t, "Edgebug", false, function(v) F.Edgebug=v end)
    Toggle(t, "Edgebug Notification", false, function(v) F.EdgebugNotification=v end)
    Slider(t, "Edgebug Debounce", 0, 0.8, 0.2, function(v) F.EdgebugDebounce=v end, "s")
    Section(t, "Exploits")
    Toggle(t, "Kill All (RISKY)", false, function(v) F.KillAll=v end)
    Slider(t, "Hit Per Second", 1, 10, 1, function(v) F.KillAllHPS=v end, "hps")
    Toggle(t, "Anti Spectate", false, function(v) F.AntiSpectate=v end)
    Dropdown(t, "Type", {"Low Fov","Freeze"}, "Low Fov", function(v) F.AntiSpectateType=v end)
    Button(t, "Flashbang Enemies", function()
        if not G.IsAlive(LP) then return end
        if RS:GetAttribute("Preparation") then return end
        if G.EquippedWeapon ~= "Flashbang" then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p==LP or not G.IsAlive(p) then continue end
            if p.Character:FindFirstChildWhichIsA("ForceField") then continue end
            for _=1, math.max(1, math.floor(F.FlashIntensity)) do
                G.FireEvent:FireServer({
                    Normal=Vector3.zero, Position=p.Character.Torso.Position+Vector3.one,
                    Hit=p.Character, cCF=Camera.CFrame,
                    hS=p.Character.Torso.Size.Magnitude, hP=p.Character.Torso.Position,
                    PartName="Torso", BlindLevel=1,
                }, G.EquippedWeaponFolder, nil, true, Camera.CFrame, p.Character.Torso.Position, nil, nil)
            end
        end
    end)
    Slider(t, "Flash Intensity", 1, 10, 1, function(v) F.FlashIntensity=v end)
    Button(t, "Lag Server (RISKY)", function()
        if not G.IsAlive(LP) then return end
        if (LP:GetAttribute("Money") or 0) < 300 then return end
        for i=1,10 do
            if not G.IsAlive(LP) or (LP:GetAttribute("Money") or 0) < 300 then return end
            RS.Events.BuyWeapon:FireServer("Smoke Grenade")
            RS.Events.Throwable:FireServer("4_1", LP.Character:GetPivot(), -100)
            task.wait(0.2)
        end
    end)
    Section(t, "Client")
    Toggle(t, "Auto Join Team", false, function(v) F.AutoJoinTeam=v end)
    Dropdown(t, "Team", {"Operators","Militia"}, "Operators", function(v) F.JoinTeam=v end)
    Section(t, "Chat")
    Toggle(t, "Chat Spammer", false, function(v) F.ChatSpam=v end)
    Dropdown(t, "Message Type", {"Neyrone","Advertise","Japanese","Custom"}, "Neyrone, function(v) F.ChatSpamType=v end)
    Section(t, "C4")
    Dropdown(t, "Site", {"A","B"}, "A", function(v) F.PlantSite=v end)
    Button(t, "Plant", function()
        if not G.IsAlive(LP) then return end
        if LP:GetAttribute("Team") ~= "T" then return end
        if RS:GetAttribute("HasBomb") ~= LP.Name then return end
        if RS:GetAttribute("Preparation") then return end
        local origCF = LP.Character.HumanoidRootPart.CFrame
        local site = F.PlantSite == "A" and "BombA" or "BombB"
        LP.Character.HumanoidRootPart.CFrame = workspace.Map.Markers[site].CFrame - Vector3.new(0,-1,0)
        task.wait(0.3)
        RS.Events.PlantC4:FireServer()
        LP.Character.HumanoidRootPart.CFrame = origCF
    end)
    Button(t, "Defuse", function()
        if not G.IsAlive(LP) then return end
        if LP:GetAttribute("Team") ~= "CT" then return end
        if not G.IsC4() then return end
        RS.Events.StartDefuse:FireServer()
        if G.Ambassador then G.Ambassador.Fire("UpdateDefuse") end
        RS.Events.StartDefuse:FireServer()
        if G.Ambassador then G.Ambassador.Fire("StopDefuse") end
    end)
    Section(t, "Gun Mods")
    Toggle(t, "No Recoil", false, function(v) F.NoRecoil=v end)
    Toggle(t, "No Spread", false, function(v) F.NoSpread=v end)
    Toggle(t, "Full Auto", false, function(v) F.FullAuto=v end)
    Toggle(t, "Rapid Fire", false, function(v) F.RapidFireGun=v end)
    Toggle(t, "Stored -> Ammo", false, function(v) F.ConvertAmmo=v end)
    Toggle(t, "Infinite Ammo", false, function(v) F.InfiniteAmmo=v end)
    Section(t, "Throwables")
    Dropdown(t, "Activation Type", {"Touch","Shoot"}, "Touch", function(v) F.LaserMineType=v end)
    Toggle(t, "Auto Activate Laser Mines", false, function(v) F.AutoActivateLaserMines=v end)
    Toggle(t, "Allow Yours Laser Mines", false, function(v) F.AllowYoursLaserMines=v end)
    Toggle(t, "Remove Laser", false, function(v) F.RemoveLaser=v end)
    Toggle(t, "Teleport Throwables", false, function(v) F.TeleportThrowables=v end)
end

do local t = Tab("Skins")
    Section(t, "Knife Changer")
    if C.Require and G.Appearance and G.Appearance.MapGunSkin then
        Toggle(t, "Enabled", false, function(v) F.KnifeEnabled=v end)
        Dropdown(t, "Knife", SkinsData.Knives.List, SkinsData.Knives.List[1], function(v) SkinsData.Knives.CurrentType=v end)
    else
        local l = Instance.new("TextLabel", t); l.Size = UDim2.new(1,-20,0,30); l.BackgroundTransparency = 1
        l.Text = "Skin Changer - Unsupported"; l.TextColor3 = Color3.fromRGB(255,100,100); l.Font = Enum.Font.Gotham; l.TextSize = 12
    end
    Section(t, "Gloves Changer")
    if C.Require then
        Toggle(t, "Enabled", false, function(v) F.GlovesEnabled=v end)
        Dropdown(t, "Gloves", SkinsData.Gloves.List, SkinsData.Gloves.List[1], function(v) SkinsData.Gloves.CurrentType=v end)
    else
        local l = Instance.new("TextLabel", t); l.Size = UDim2.new(1,-20,0,30); l.BackgroundTransparency = 1
        l.Text = "Gloves Changer - Unsupported"; l.TextColor3 = Color3.fromRGB(255,100,100); l.Font = Enum.Font.Gotham; l.TextSize = 12
    end
end

do local t = Tab("Players")
    Section(t, "Priority")
    Toggle(t, "Kill Priority", false, function(v) F.PriorityKill=v end)
    Slider(t, "Hit Per Second", 1, 10, 1, function(v) F.PriorityHPS=v end, "hps")
    Button(t, "Flashbang Priority", function()
        if not G.IsAlive(LP) then return end
        if G.EquippedWeapon ~= "Flashbang" then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p==LP or not G.IsAlive(p) then continue end
            if p.Character:FindFirstChildWhichIsA("ForceField") then continue end
            G.FireEvent:FireServer({
                Normal=Vector3.zero, Position=p.Character.Torso.Position+Vector3.one, Hit=p.Character,
                cCF=Camera.CFrame, hS=p.Character.Torso.Size.Magnitude, hP=p.Character.Torso.Position,
                PartName="Torso", BlindLevel=1,
            }, G.EquippedWeaponFolder, nil, true, Camera.CFrame, p.Character.Torso.Position, nil, nil)
        end
    end)
    Slider(t, "Flash Intensity", 1, 10, 1, function(v) F.PriorityFlashIntensity=v end)
end

do local t = Tab("Settings")
    Section(t, "Config")
    Button(t, "Rejoin", function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LP) end)
    Button(t, "Unload", function() ScreenGui:Destroy() end)
end

-- ============ OPEN/CLOSE ============
local function toggleMenu()
    Main.Visible = not Main.Visible
    if Main.Visible then
        Main.Size = UDim2.new(0,0,0,0)
        Tween:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size=UDim2.new(0,620,0,460)}):Play()
    end
end
OpenBtn.MouseButton1Click:Connect(toggleMenu)
UIS.InputBegan:Connect(function(i, p)
    if p then return end
    if i.KeyCode == Enum.KeyCode.RightShift then toggleMenu() end
end)

-- ============ FOV CIRCLES ============
local LegitFovCircle = Drawing.new("Circle")
LegitFovCircle.Thickness = 1; LegitFovCircle.Filled = false; LegitFovCircle.Visible = false; LegitFovCircle.ZIndex = 2
local RageFovCircle = Drawing.new("Circle")
RageFovCircle.Thickness = 1; RageFovCircle.Filled = false; RageFovCircle.Visible = false; RageFovCircle.ZIndex = 2

-- ============ TARGET ============
local LegitTarget, LegitHitbox = nil, nil
local Hitboxes = {Head="Head", Torso="HumanoidRootPart"}
local function getLegitTarget(fovOn, radius)
    local mp = UIS:GetMouseLocation()
    local closest, cdist = nil, fovOn and radius or math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p==LP or not G.IsAlive(p) then continue end
        if not G.IsDM() and p:GetAttribute("Team") == LP:GetAttribute("Team") then continue end
        if p.Character:FindFirstChildWhichIsA("ForceField") then continue end
        local hb = p.Character:FindFirstChild(Hitboxes[F.LegitHitscan])
        if not hb then continue end
        local sp, on = Camera:WorldToViewportPoint(hb.Position)
        if not on then continue end
        local d = (Vector2.new(sp.X, sp.Y) - mp).Magnitude
        if d <= cdist then cdist = d; closest = p end
    end
    return closest
end

-- ============ RAGE ENGINE ============
local R = {LastShot=0, LastReload=0}
R.HitboxMul = {Head=1.75, Torso=1.25, ["Left Arm"]=1, ["Right Arm"]=1, ["Left Leg"]=0.75, ["Right Leg"]=0.75}
R.Default = {Range=8192, Penetration=300, ArmorPen=80, Damage=50, Bullets=1}

function R.GetHitboxes(plr, list)
    local out = {}
    if not G.IsAlive(plr) then return out end
    if type(list) == "string" then list = {list} end
    for _, s in ipairs(list) do
        if s == "Head" and plr.Character:FindFirstChild("Head") then table.insert(out, plr.Character.Head) end
        if s == "Torso" and plr.Character:FindFirstChild("Torso") then table.insert(out, plr.Character.Torso) end
        if s == "Arms" then
            if plr.Character:FindFirstChild("Left Arm") then table.insert(out, plr.Character["Left Arm"]) end
            if plr.Character:FindFirstChild("Right Arm") then table.insert(out, plr.Character["Right Arm"]) end
        end
        if s == "Legs" then
            if plr.Character:FindFirstChild("Left Leg") then table.insert(out, plr.Character["Left Leg"]) end
            if plr.Character:FindFirstChild("Right Leg") then table.insert(out, plr.Character["Right Leg"]) end
        end
    end
    return out
end

function R.IncAmmo(isKnife)
    if not C.FullGetsenv or not G.BaseWeapon then return end
    local up = debug.getupvalue(G.BaseWeapon.firebullet, 3)
    if not up then return end
    local eq = G.Variables.equipped
    local w = up[eq]
    if not (w and w.Ammo) then return end
    local amt = F.InfiniteAmmo and 0 or (F.DoubleTap and 2 or 1)
    if not isKnife then
        w.Ammo -= amt
        if w.Ammo <= 0 then w.Ammo = 0; R.LastReload = tick(); if G.Ambassador then G.Ambassador.Fire("ReloadWeapon") end end
    end
    if G.Ambassador then G.Ambassador.Fire("UpdateAmmo", w) end
end

function R.FakeShoot(wp, isKnife)
    if not C.Require or not G.Shucky or not G.Ambassador then return end
    if not isKnife and not F.SimulateShoot then return end
    if isKnife and not F.KnifebotSimulateStab then return end
    if wp:GetAttribute("WeaponType") == "Throwable" or not wp:FindFirstChild("Model") then return end
    pcall(function() G.Shucky.shootsound(wp.Model, Camera) end)
    pcall(function() RS.URE_ViewmodelAnimStream:FireServer(true, "fire", "fire", nil, nil, nil) end)
    local n = math.random(1,2)
    G.Ambassador.Fire("VPlay", "2fire", "fire")
    G.Ambassador.Fire("WPlay", n==1 and "" or tostring(n), "Fire")
    task.spawn(R.IncAmmo, isKnife)
end

function R.Fire(wp, part, ratio, wallbang, bullets, noscope, backstab)
    local times = F.DoubleTap and 2 or 1
    for _=1,times do
        for _=1,bullets do
            G.FireEvent:FireServer({
                Normal=Vector3.zero, Position=part.Position+Vector3.one, Hit=part.Parent,
                cCF=Camera.CFrame, hS=part.Size and part.Size.Magnitude, hP=part.Position,
                PartName=(F.ForceHeadshot or part.Name:find("Head")) and "Head" or part.Name,
                Wallbang=wallbang, Noscope=noscope or false, Backstab=backstab or false, Ratio=ratio,
            }, wp, nil, true, Camera.CFrame, part.Position, nil, nil)
        end
    end
end

function R.ArmorLoss(armorPen, hasArmor)
    if not hasArmor then return 1 end
    return 0.01 * armorPen
end
function R.DistanceLoss(mod, dist)
    return math.clamp((dist/100)^(mod/34.7), 0.45, 1)
end

function R.ShootTarget(wp, isKnife, aimPos, plr, part, visible, ratio, wallbang)
    local armor = plr:GetAttribute("Armor") or 0
    local armorPen = wp:GetAttribute("ArmorPenetration") or R.Default.ArmorPen
    local rangeMod = wp:GetAttribute("RangeModifier")
    local dmg = wp:GetAttribute("DMG") or R.Default.Damage
    local bullets = wp:GetAttribute("Bullets") or R.Default.Bullets
    local hsBonus = wp:GetAttribute("HighHS") and 15 or 0
    local mul = R.HitboxMul[part.Name] or 1
    local dist = (aimPos - plr.Character.HumanoidRootPart.Position).Magnitude
    local distLoss = rangeMod and R.DistanceLoss(dist, rangeMod) or 1
    local armorLoss = R.ArmorLoss(armorPen, armor > 0)
    local approx = dmg * mul * ratio * armorLoss * distLoss + ((part.Name:find("Head") and hsBonus) or 0)
    if visible or approx >= F.MinDamage then
        if not F.RageSilentAim then Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position) end
        if F.RageDebug then
            print(string.format("Shot %s's %s | Damage ~%d | Ratio %.2f | DistLoss %.2f", plr.Name, part.Name, approx, ratio, distLoss))
        end
        local noscope = F.NoscopeIcon
        if wp:GetAttribute("Scoped") and G.Variables then
            noscope = F.NoscopeIcon or (not G.Variables.scoped)
        end
        task.spawn(R.FakeShoot, wp, isKnife)
        task.spawn(R.Fire, wp, part, ratio, wallbang, bullets, noscope, F.BackstabIcon)
        return true
    end
    return false
end

function R.AutoWall(wp, origin, part, ignore)
    local parts, dir = {}, (part.Position - origin).Unit
    local range = wp:GetAttribute("Range") or 8000
    local ray = dir * (range/8 or 1000)
    local pen = wp:GetAttribute("Penetration") or 0
    local penLoss = pen > 0 and pen * 0.02 or 0
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = ignore
    params.IgnoreWater = true
    local filtered, res = {}, workspace:Raycast(origin, ray, params)
    local lost, totalLoss = 0, 0
    local hitCount = 0
    repeat
        hitCount = hitCount + 1
        if hitCount > 4 then break end
        local hit, pos
        if res then hit, pos = res.Instance, res.Position else hit, pos = nil, origin + ray end
        local info = {Hit=hit, Position=pos, Normal=res and res.Normal or Vector3.new(0,1,0)}
        if lost > 0 then info.Wallbang = true end
        if info.Hit then table.insert(parts, info) end
        if penLoss == 0 then break end
        if hit then
            local human = hit.Parent:FindFirstChild("Humanoid")
            lost = lost + 1
            if human or hit.Parent:GetAttribute("Streak") then
                table.insert(filtered, hit.Parent)
            else
                local backRay = RaycastParams.new()
                backRay.FilterType = Enum.RaycastFilterType.Include
                backRay.FilterDescendantsInstances = {hit}
                local back = workspace:Raycast(pos + dir*10, -dir*20, backRay)
                local thickness = back and (back.Position - pos).Magnitude or 1
                local m = hit:GetAttribute("PeneValue") or 1
                local mat = hit.Material
                if mat == Enum.Material.DiamondPlate then m = 3
                elseif mat == Enum.Material.CorrodedMetal or mat == Enum.Material.Metal then m = 2
                elseif mat == Enum.Material.Concrete or mat == Enum.Material.Brick then m = 2
                elseif hit.Name == "Grate" or mat == Enum.Material.Wood or mat == Enum.Material.WoodPlanks then m = 0.5
                elseif mat == Enum.Material.Fabric or mat == Enum.Material.Sand or mat == Enum.Material.Grass or mat == Enum.Material.LeafyGrass or mat == Enum.Material.Ground then m = 0.1
                elseif hit.Transparency == 1 or not hit.CanCollide or hit.Name == "Glass" or hit.Name == "Cardboard" then m = 0
                end
                totalLoss = totalLoss + thickness * m
                table.insert(filtered, hit)
            end
        end
        params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = filtered
        params.IgnoreWater = true
        res = workspace:Raycast(origin, ray, params)
        if not res or totalLoss >= pen then break end
    until false
    return parts
end

function R.Init(wp, targets, isKnife)
    if not workspace:FindFirstChild("Map") then return end
    if RS:GetAttribute("RoundOver") or RS:GetAttribute("Preparation") or RS:GetAttribute("GameOver") then return end
    local fireRate = wp:GetAttribute("FireRate") or 0.1
    local scopedRate = wp:GetAttribute("ScopedFireRate") or fireRate
    local rate = LP.Character:GetAttribute("Aiming") and scopedRate or fireRate
    if F.RapidFire then rate = 0.01 end
    local reloadTime = wp:GetAttribute("ReloadTime") or 0
    local now = tick()
    if now - R.LastShot < rate or now - R.LastReload < reloadTime then return end
    local bullets = wp:GetAttribute("Bullets") or 1
    local origin = LP.Character.Head.Position
    if F.FakeDuck and F.AntiAim and LP.Character.HumanoidRootPart then
        origin = LP.Character.HumanoidRootPart.Position + Vector3.new(0,3,0)
    end
    local shot = false
    for _, plr in ipairs(targets) do
        if not plr or not G.IsAlive(plr) then continue end
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        local ignore = {}
        if G.Variables and G.Variables.Params then
            for _, v in ipairs(G.Variables.Params.FilterDescendantsInstances) do table.insert(ignore, v) end
        else
            ignore = {workspace.Destroyable, workspace.Debris, workspace.Map.Clips}
        end
        params.FilterDescendantsInstances = ignore
        params.IgnoreWater = true
        params:AddToFilter(LP.Character); params:AddToFilter(Camera)
        if isKnife then
            if not F.Knifebot then return end
            local dir = (plr.Character.HumanoidRootPart.Position - origin).Unit * F.KnifebotRadius
            if not F.KnifebotWallCheck then params:AddToFilter(workspace.Map) else
                if table.find(params.FilterDescendantsInstances, workspace.Map) then
                    for i, v in ipairs(params.FilterDescendantsInstances) do
                        if v == workspace.Map then table.remove(params.FilterDescendantsInstances, i) break end
                    end
                end
            end
            local res = workspace:Raycast(origin, dir, params)
            if res and res.Instance and res.Instance:IsDescendantOf(plr.Character) then
                task.spawn(R.FakeShoot, wp, isKnife)
                task.spawn(R.Fire, wp, plr.Character.HumanoidRootPart, 1, false, bullets, F.NoscopeIcon, F.BackstabIcon)
                shot = true; break
            end
        else
            local hitboxes = R.GetHitboxes(plr, F.RageHitscan or {"Head"})
            if #hitboxes == 0 then continue end
            for _, part in ipairs(plr.Character:GetChildren()) do
                if not table.find(hitboxes, part) then params:AddToFilter(part) end
            end
            for _, part in ipairs(hitboxes) do
                if F.RageFov then
                    local mp = UIS:GetMouseLocation()
                    local vp = Camera.ViewportSize
                    local radius = (vp.X * ((F.RageFovValue/2) / Camera.FieldOfView)) / 2
                    local sp, on = Camera:WorldToViewportPoint(part.Position)
                    if not on or (Vector2.new(sp.X, sp.Y) - mp).Magnitude > radius then continue end
                end
                local dir = part.Position - origin
                local res = workspace:Raycast(origin, dir, params)
                if res and res.Instance == part then
                    if R.ShootTarget(wp, isKnife, origin, plr, part, true, 1, false) then shot = true; break end
                end
                if F.AutoWall then
                    local wallParts = R.AutoWall(wp, origin, part, ignore)
                    local hit, hitRatio, hitWallbang = false, 1, false
                    for _, w in ipairs(wallParts) do
                        if w.Hit and w.Hit.Parent == plr.Character then
                            hit = true
                            hitRatio = F.ForceDamage and 1 or (w.Ratio or 1)
                            hitWallbang = w.Wallbang or false
                            break
                        end
                    end
                    if hit and R.ShootTarget(wp, isKnife, origin, plr, part, false, hitRatio, hitWallbang) then shot = true; break end
                end
            end
        end
        if shot then R.LastShot = now; break end
    end
end

function R.Start()
    if not F.Ragebot or not G.IsAlive(LP) then return end
    if not G.EquippedWeapon or G.EquippedWeapon == "C4" then return end
    if not G.EquippedWeaponFolder then return end
    if G.EquippedWeaponFolder:GetAttribute("WeaponType") == "Throwable" and not F.AllowThrowables then return end
    local targets = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p==LP or not G.IsAlive(p) then continue end
        if not G.IsDM() and p:GetAttribute("Team") == LP:GetAttribute("Team") then continue end
        if p.Character:FindFirstChildWhichIsA("ForceField") then continue end
        table.insert(targets, p)
    end
    if #targets > 0 then R.Init(G.EquippedWeaponFolder, targets, G.EquippedWeaponFolder:GetAttribute("WeaponType") == "Melee") end
end

RunService.Stepped:Connect(function() task.spawn(R.Start) end)

-- ============ ESP IMPL ============
local EspStore = {}
local function newEsp(plr)
    if EspStore[plr] then return end
    EspStore[plr] = {Box=Drawing.new("Square"), Name=Drawing.new("Text"), Weapon=Drawing.new("Text"),
        Dist=Drawing.new("Text"), HB=Drawing.new("Square"), HBBg=Drawing.new("Square"), HPNum=Drawing.new("Text")}
    for _, d in pairs(EspStore[plr]) do d.Visible = false; d.ZIndex = 2 end
end
local function remEsp(plr)
    if EspStore[plr] then for _, d in pairs(EspStore[plr]) do d:Remove() end EspStore[plr] = nil end
end

local ChamsStore = {}
local function updateChams(plr)
    if not F.EspChams or not G.IsAlive(plr) then
        if ChamsStore[plr] then for _, h in pairs(ChamsStore[plr]) do h:Destroy() end ChamsStore[plr] = nil end
                return
    end
    ChamsStore[plr] = ChamsStore[plr] or {}
    for _, p in ipairs(plr.Character:GetChildren()) do
        if p:IsA("BasePart") and not ChamsStore[plr][p.Name] then
            local h = Instance.new("Highlight", p)
            h.FillColor = F.EspChamsInvis; h.OutlineColor = F.EspChamsVis
            h.FillTransparency = 0.5; h.OutlineTransparency = 0
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            ChamsStore[plr][p.Name] = h
        elseif ChamsStore[plr][p.Name] then
            ChamsStore[plr][p.Name].FillColor = F.EspChamsInvis
            ChamsStore[plr][p.Name].OutlineColor = F.EspChamsVis
        end
    end
end

RunService.RenderStepped:Connect(function()
    if not F.Esp then
        for _, e in pairs(EspStore) do for _, d in pairs(e) do d.Visible = false end end
        for _, c in pairs(ChamsStore) do for _, h in pairs(c) do h:Destroy() end end
        ChamsStore = {}
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LP then continue end
        if not G.IsAlive(plr) then
            if EspStore[plr] then for _, d in pairs(EspStore[plr]) do d.Visible = false end end
            continue
        end
        if not EspStore[plr] then newEsp(plr) end
        local e = EspStore[plr]
        local head = plr.Character:FindFirstChild("Head")
        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
        local hum = plr.Character:FindFirstChild("Humanoid")
        if not (head and hrp and hum) then
            for _, d in pairs(e) do d.Visible = false end
            continue
        end
        local hp, ho = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
        local rp, ro = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0))
        if not ho or not ro then
            for _, d in pairs(e) do d.Visible = false end
            continue
        end
        local h, w = math.abs(hp.Y - rp.Y), math.abs(hp.Y - rp.Y)/2
        if F.EspBox then
            e.Box.Size = Vector2.new(w, h); e.Box.Position = Vector2.new(hp.X - w/2, hp.Y)
            e.Box.Color = F.EspBoxColor; e.Box.Thickness = 1; e.Box.Filled = false; e.Box.Visible = true
        else e.Box.Visible = false end
        if F.EspName then
            e.Name.Text = plr.Name; e.Name.Size = F.EspTextSize; e.Name.Center = true; e.Name.Outline = true
            e.Name.Color = F.EspNameColor; e.Name.Position = Vector2.new(hp.X, hp.Y - 15); e.Name.Visible = true
        else e.Name.Visible = false end
        if F.EspWeapon then
            local ww = plr.Character:GetAttribute("WhatGun")
            if ww then
                e.Weapon.Text = ww; e.Weapon.Size = F.EspTextSize - 1; e.Weapon.Center = true; e.Weapon.Outline = true
                e.Weapon.Color = F.EspWeaponColor; e.Weapon.Position = Vector2.new(hp.X, hp.Y + h + 2); e.Weapon.Visible = true
            else e.Weapon.Visible = false end
        else e.Weapon.Visible = false end
        if F.EspDistance then
            local d = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
            e.Dist.Text = d .. "m"; e.Dist.Size = F.EspTextSize - 1; e.Dist.Center = true; e.Dist.Outline = true
            e.Dist.Color = F.EspDistanceColor; e.Dist.Position = Vector2.new(hp.X, hp.Y + h + 16); e.Dist.Visible = true
        else e.Dist.Visible = false end
        if F.EspHealthBar then
            local pct = hum.Health / hum.MaxHealth
            e.HBBg.Size = Vector2.new(4, h); e.HBBg.Position = Vector2.new(hp.X - w/2 - 6, hp.Y)
            e.HBBg.Color = Color3.new(0,0,0); e.HBBg.Filled = true; e.HBBg.Visible = true
            e.HB.Size = Vector2.new(3, (h-1) * pct); e.HB.Position = Vector2.new(hp.X - w/2 - 5.5, hp.Y + (h-1)*(1-pct)+0.5)
            e.HB.Color = F.EspHealthFull:Lerp(F.EspHealthDying, 1 - pct); e.HB.Filled = true; e.HB.Visible = true
        else e.HBBg.Visible = false; e.HB.Visible = false end
        if F.EspHealthNumber then
            e.HPNum.Text = tostring(math.floor(hum.Health))
            e.HPNum.Size = F.EspTextSize - 1; e.HPNum.Center = true; e.HPNum.Outline = true
            e.HPNum.Color = F.EspHealthNumberColor
            e.HPNum.Position = Vector2.new(hp.X, hp.Y + h + 30); e.HPNum.Visible = true
        else e.HPNum.Visible = false end
        updateChams(plr)
    end
end)

for _, p in ipairs(Players:GetPlayers()) do if p ~= LP then newEsp(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LP then newEsp(p) end end)
Players.PlayerRemoving:Connect(function(p) remEsp(p) end)

-- ============ THROWABLE ESP ============
local ThrowStore = {}
local function throwEspInit(obj)
    if not F.ThrowableEsp then return end
    if not obj:GetAttribute("Weapon") then return end
    if not obj:FindFirstChildOfClass("MeshPart") then return end
    if obj:GetAttribute("Team") == LP:GetAttribute("Team") then return end
    if ThrowStore[obj] then return end
    ThrowStore[obj] = {Name=Drawing.new("Text")}
    ThrowStore[obj].Name.Font = 2; ThrowStore[obj].Name.Position = Vector2.new(0,0)
    ThrowStore[obj].Name.Visible = false; ThrowStore[obj].Name.Text = obj:GetAttribute("Weapon")
    ThrowStore[obj].Name.Size = 13; ThrowStore[obj].Name.Color = Color3.new(1,1,1)
    ThrowStore[obj].Name.Center = true; ThrowStore[obj].Name.Outline = true
    ThrowStore[obj].Loop = RunService.PreRender:Connect(function()
        if not obj or not obj.Parent then throwEspRemove(obj); return end
        local mesh = obj:GetAttribute("Weapon") == "Jump Pad" and obj:FindFirstChildOfClass("MeshPart"):FindFirstChildOfClass("MeshPart") or obj:FindFirstChildOfClass("MeshPart")
        if not mesh then return end
        if F.ThrowableChams then
            if not mesh:FindFirstChild("yaico999") then
                local hl = Instance.new("Highlight", mesh)
                hl.Name = "yaico999"; hl.FillColor = F.ThrowableChamsFill
                hl.OutlineColor = F.ThrowableChamsOutline
            else
                mesh.yaico999.FillColor = F.ThrowableChamsFill
                mesh.yaico999.OutlineColor = F.ThrowableChamsOutline
            end
        else
            if mesh:FindFirstChild("yaico999") then mesh.yaico999:Destroy() end
        end
        if F.ThrowableName then
            local dist = (obj.Position - Camera.CFrame.Position).Magnitude
            if dist <= 400 then
                local sp, on = Camera:WorldToViewportPoint(obj.Position)
                if on then
                    ThrowStore[obj].Name.Position = Vector2.new(sp.X, sp.Y - 20)
                    ThrowStore[obj].Name.Visible = true
                    ThrowStore[obj].Name.Text = obj:GetAttribute("Weapon")
                    ThrowStore[obj].Name.Color = F.ThrowableNameColor
                else ThrowStore[obj].Name.Visible = false end
            else ThrowStore[obj].Name.Visible = false end
        else ThrowStore[obj].Name.Visible = false end
    end)
end
function throwEspRemove(obj)
    if ThrowStore[obj] then
        if ThrowStore[obj].Loop then ThrowStore[obj].Loop:Disconnect() end
        if ThrowStore[obj].Name then ThrowStore[obj].Name:Remove() end
        if obj and obj.Parent then
            local mesh = obj:FindFirstChildOfClass("MeshPart")
            if mesh and mesh:FindFirstChild("yaico999") then mesh.yaico999:Destroy() end
        end
        ThrowStore[obj] = nil
    end
end
for _, obj in ipairs(workspace.Debris:GetChildren()) do throwEspInit(obj) end
for _, obj in ipairs(workspace.Destroyable:GetChildren()) do throwEspInit(obj) end
workspace.Debris.ChildAdded:Connect(function(o) task.wait(0.1); throwEspInit(o) end)
workspace.Destroyable.ChildAdded:Connect(function(o) task.wait(0.1); throwEspInit(o) end)
workspace.Debris.ChildRemoved:Connect(throwEspRemove)
workspace.Destroyable.ChildRemoved:Connect(throwEspRemove)

-- ============ LEGIT AIM ============
RunService.RenderStepped:Connect(function()
    local vp = Camera.ViewportSize
    local radius = (vp.X * ((F.LegitFovValue/2) / Camera.FieldOfView)) / 2
    LegitFovCircle.Radius = radius
    LegitFovCircle.Visible = F.LegitFov and F.LegitFovVisible
    LegitFovCircle.Color = F.LegitFovColor
    LegitFovCircle.NumSides = F.LegitFovSides
    LegitFovCircle.Position = Vector2.new(math.floor(vp.X/2), math.floor(vp.Y/2))
    RageFovCircle.Radius = (vp.X * ((F.RageFovValue/2) / Camera.FieldOfView)) / 2
    RageFovCircle.Visible = F.RageFov and F.RageFovVisible
    RageFovCircle.Color = F.RageFovColor
    RageFovCircle.NumSides = F.RageFovSides
    RageFovCircle.Position = Vector2.new(math.floor(vp.X/2), math.floor(vp.Y/2))

    if not G.IsAlive(LP) then return end
    if F.SilentAim then
        LegitTarget = getLegitTarget(F.LegitFov, radius)
        if LegitTarget then LegitHitbox = LegitTarget.Character:FindFirstChild(Hitboxes[F.LegitHitscan]) end
    end
    if F.Aimbot then
        local active = (F.AimbotActivate == "Mouse 1" and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1))
            or (F.AimbotActivate == "Mouse 2" and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2))
        if active then
            local target = getLegitTarget(F.LegitFov, radius)
            if target then
                local hb = target.Character:FindFirstChild(Hitboxes[F.LegitHitscan])
                if hb then
                    local speed = F.AimbotSpeed
                    if F.AimbotType == "Mouse Movement" and C.Mousemoverel then
                        speed = speed / 9
                        local sp = Camera:WorldToViewportPoint(hb.Position)
                        local dx = (sp.X - (vp.X/2)) * speed / 20.5
                        local dy = (sp.Y - (vp.Y/2)) * speed / 20.5
                        pcall(mousemoverel, dx, dy)
                    elseif F.AimbotType == "Lerp" then
                        local goal = CFrame.new(Camera.CFrame.Position, hb.Position)
                        local angle = math.abs(math.deg(math.acos(Camera.CFrame.LookVector:Dot(goal.LookVector))))
                        speed = (speed / math.max(angle, 1)) / 100
                        Camera.CFrame = Camera.CFrame:Lerp(goal, speed)
                    else
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, hb.Position)
                    end
                end
            end
        end
    end
end)

-- ============ TRIGGERBOT ============
local trigDebounce = false
RunService.Heartbeat:Connect(function()
    if not F.Triggerbot or not G.IsAlive(LP) or trigDebounce then return end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local ignore = {}
    if G.Variables and G.Variables.Params then
        for _, v in ipairs(G.Variables.Params.FilterDescendantsInstances) do table.insert(ignore, v) end
    else ignore = {workspace.Destroyable, workspace.Debris, workspace.Map.Clips} end
    params.FilterDescendantsInstances = ignore
    params.IgnoreWater = true
    params:AddToFilter(LP.Character); params:AddToFilter(Camera)
    local res = workspace:Raycast(Camera.CFrame.Position, Camera.CFrame.LookVector * 365, params)
    if res and res.Instance and res.Instance:IsA("BasePart") then
        local plr = Players:GetPlayerFromCharacter(res.Instance.Parent)
        if plr and G.IsAlive(plr) and (G.IsDM() or plr:GetAttribute("Team") ~= LP:GetAttribute("Team"))
            and not plr.Character:FindFirstChildWhichIsA("ForceField") then
            trigDebounce = true
            if F.TriggerbotDelay > 0 then task.wait(F.TriggerbotDelay / 1000) end
            if C.FullGetsenv and G.BaseWeapon then
                pcall(function() G.BaseWeapon.firebullet() end)
            elseif mouse1press and mouse1release then
                mouse1press(); task.wait(); mouse1release()
            end
            trigDebounce = false
        end
    end
end)

-- ============ ANTI-AIM ============
local spinAngle = 0
local function stripYaw(cf)
    local _, yaw = cf:ToOrientation()
    return CFrame.new(cf.Position) * CFrame.Angles(0, yaw, 0)
end
RunService.Heartbeat:Connect(function()
    if not G.IsAlive(LP) then return end
    if F.AntiAim then
        LP.Character.Humanoid.AutoRotate = false
        local baseYaw = -math.atan2(Camera.CFrame.LookVector.Z, Camera.CFrame.LookVector.X) + math.rad(-90)
        spinAngle = (spinAngle + F.AntiAimSpinSpeed) % 360
        local yaw = baseYaw + math.rad(F.AntiAimCustomYaw)
        if F.AntiAimYaw == "Spin" then yaw = yaw + math.rad(spinAngle)
        elseif F.AntiAimYaw == "Random" then yaw = yaw + math.rad(math.random(0,360)) end
        local cf = CFrame.new(LP.Character.HumanoidRootPart.Position) * CFrame.Angles(0, yaw, 0)
        LP.Character.HumanoidRootPart.CFrame = stripYaw(cf)
        local pitch = F.AntiAimPitch == "Custom" and (F.AntiAimCustomPitch/100) or math.random(-1,1)
        if G.Network then pcall(function() G.Network.FireServer("0R5lsPxqfSH3", pitch, true) end) end
    else
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.AutoRotate = true end
    end
    if F.FakeDuck and G.Ambassador then G.Ambassador.Fire("WPlay", "CrouchIdle", nil, 0) end
end)

-- ============ MOVEMENT ============
RunService.Stepped:Connect(function()
    if not G.IsAlive(LP) then return end
    if F.Noclip then
        for _, p in ipairs(LP.Character:GetChildren()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
        end
    else
        if LP.Character.HumanoidRootPart then LP.Character.HumanoidRootPart.CanCollide = true end
    end
end)

RunService.Heartbeat:Connect(function()
    if not G.IsAlive(LP) then return end
    local hum = LP.Character:FindFirstChild("Humanoid")
    if F.BypassSpeed and G.Variables then
        if G.Variables.crouch or G.Variables.fullycrouched then G.Variables.jumping = true else G.Variables.jumping = false end
    end
    if F.AutoJump and UIS:IsKeyDown(Enum.KeyCode.Space) and hum.FloorMaterial ~= Enum.Material.Air then hum.Jump = true end
    if F.SpeedHack then
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
        if dir.Magnitude > 0 then
            dir = dir.Unit * (F.SpeedHackSpeed/10) * 1.5
            dir = Vector3.new(dir.X, 0, dir.Z)
            LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (dir/100 * 2)
        end
    end
    if F.Airstuck then LP.Character.HumanoidRootPart.Anchored = true else LP.Character.HumanoidRootPart.Anchored = false end
end)

-- ============ GUN MODS ============
local OrigWeapon = {}
for _, w in ipairs(RS.Weapons:GetChildren()) do
    if w:IsA("Folder") then
        OrigWeapon[w.Name] = {}
        for _, a in ipairs({"RecoilX","RecoilY","Auto","ScopedFireRate","FireRate","Penetration","Range","Ammo","StoredAmmo","Spread","CrouchSpread","FireSpread","LadderSpread","LandSpread","MoveSpread","StandSpread","JumpSpread","RunSpread"}) do
            OrigWeapon[w.Name][a] = w:GetAttribute(a)
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not (F.NoRecoil or F.NoSpread or F.FullAuto or F.RapidFireGun or F.ConvertAmmo or F.InfiniteAmmo) then return end
    for _, w in ipairs(RS.Weapons:GetChildren()) do
        if not w:IsA("Folder") then continue end
        local o = OrigWeapon[w.Name]
        if not o then continue end
        if F.NoRecoil then w:SetAttribute("RecoilX",0); w:SetAttribute("RecoilY",0)
        else w:SetAttribute("RecoilX", o.RecoilX); w:SetAttribute("RecoilY", o.RecoilY) end
        if F.NoSpread then
            for _, a in ipairs({"Spread","CrouchSpread","FireSpread","LadderSpread","LandSpread","MoveSpread","StandSpread","JumpSpread","RunSpread"}) do w:SetAttribute(a,0) end
        else
            for _, a in ipairs({"Spread","CrouchSpread","FireSpread","LadderSpread","LandSpread","MoveSpread","StandSpread","JumpSpread","RunSpread"}) do w:SetAttribute(a, o[a]) end
        end
        if F.FullAuto then w:SetAttribute("Auto", true) else w:SetAttribute("Auto", o.Auto) end
        if F.RapidFireGun then w:SetAttribute("FireRate",0.01); w:SetAttribute("ScopedFireRate",0.01)
        else w:SetAttribute("FireRate", o.FireRate); w:SetAttribute("ScopedFireRate", o.ScopedFireRate) end
        if F.ConvertAmmo then w:SetAttribute("Ammo",9e9); w:SetAttribute("StoredAmmo",9e9)
        else w:SetAttribute("Ammo", o.Ammo); w:SetAttribute("StoredAmmo", o.StoredAmmo) end
        if F.InfiniteAmmo then w:SetAttribute("UseAmmo",0) else if w:GetAttribute("UseAmmo") ~= nil then w:SetAttribute("UseAmmo", nil) end end
    end
end)

-- ============ LIGHTING / WORLD ============
RunService.Heartbeat:Connect(function()
    if F.Ambient then Lighting.Ambient = F.AmbientColor; Lighting.OutdoorAmbient = F.OutdoorAmbientColor end
    if F.TimeChanger then Lighting.ClockTime = F.TimeValue end
    if F.SkyboxChanger and F.SkyboxType ~= "--" and Skyboxes[F.SkyboxType] then
        local sb = Lighting:FindFirstChild("Skyboxzz") or Instance.new("Sky", Lighting)
        sb.Name = "Skyboxzz"
        local d = Skyboxes[F.SkyboxType]
        sb.SkyboxBk = d.SkyboxBk; sb.SkyboxDn = d.SkyboxDn; sb.SkyboxFt = d.SkyboxFt
        sb.SkyboxLf = d.SkyboxLf; sb.SkyboxRt = d.SkyboxRt; sb.SkyboxUp = d.SkyboxUp
    end
end)

-- ============ SOUNDS ============
RunService.Heartbeat:Connect(function()
    if F.CustomHitSound and Sounds[F.HitSoundName] and RS.Sounds then
        RS.Sounds.HitSound.Value = Sounds[F.HitSoundName]
        RS.Sounds.HitSound.Volume.Value = F.HitSoundVolume
    elseif RS.Sounds then
        RS.Sounds.HitSound.Value = Sounds["Default Hit Sound"]
        RS.Sounds.HitSound.Volume.Value = 1.5
    end
    if F.CustomKillSound and Sounds[F.KillSoundName] and RS.Sounds then
        RS.Sounds.KillSound.Value = Sounds[F.KillSoundName]
        RS.Sounds.KillSound.Volume.Value = F.KillSoundVolume
    elseif RS.Sounds then
        RS.Sounds.KillSound.Value = Sounds["Default Kill Sound"]
        RS.Sounds.KillSound.Volume.Value = 1.5
    end
end)

-- ============ THIRD PERSON ============
RunService.Heartbeat:Connect(function()
    if not G.IsAlive(LP) then
        pcall(function() LP.CameraMode = Enum.CameraMode.Classic; LP.CameraMaxZoomDistance = 18; LP.CameraMinZoomDistance = 3 end)
        return
    end
    if F.ThirdPerson then
        pcall(function()
            LP.CameraMode = Enum.CameraMode.Classic
            LP.CameraMaxZoomDistance = F.ThirdPersonDistance
            LP.CameraMinZoomDistance = F.ThirdPersonDistance
        end)
    else
        pcall(function()
            LP.CameraMode = Enum.CameraMode.LockFirstPerson
            LP.CameraMaxZoomDistance = 0.5
            LP.CameraMinZoomDistance = 0.5
        end)
    end
end)

-- ============ VIEWMODEL ============
RunService.RenderStepped:Connect(function()
    if not G.IsAlive(LP) then return end
    local arms = Camera:FindFirstChild("Arms")
    if not arms then return end
    if F.ViewmodelOffset and not F.ThirdPerson then
        arms:SetAttribute("COffset", CFrame.new(F.ViewmodelX/300, F.ViewmodelY/300, F.ViewmodelZ/300))
    elseif not F.ThirdPerson then
        arms:SetAttribute("COffset", CFrame.new(0,0,0))
    end
    if F.NoJumpBob then arms:SetAttribute("Scale", 0) end
    if not (F.WeaponChams or F.TextureChanger) then return end
    if not G.EquippedWeaponFolder then return end
    local vw = G.EquippedWeaponFolder:FindFirstChild("Viewmodel")
    if not vw then return end
    for _, ar in ipairs(arms:GetChildren()) do
        if not vw:FindFirstChild(ar.Name) then continue end
        for _, obj in ipairs(ar:GetDescendants()) do
            if obj:IsA("MeshPart") and obj.Transparency == 1 then continue end
                        if F.WeaponChams then
                if obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
                    pcall(function()
                        obj.Color = F.WeaponChamsColor
                        obj.Material = Enum.Material.ForceField
                        obj.Transparency = 0
                    end)
                end
            end
            if F.TextureChanger and obj:IsA("MeshPart") then
                obj.TextureID = WeaponTextures[F.WeaponTexture] or ""
            end
        end
    end
end)

-- ============ KILL ALL ============
RunService.Heartbeat:Connect(function()
    if not F.KillAll or not G.IsAlive(LP) or not G.EquippedWeaponFolder then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p==LP or not G.IsAlive(p) then continue end
        if p.Character:FindFirstChildWhichIsA("ForceField") then continue end
        local head = p.Character:FindFirstChild("Head")
        if not head then continue end
        for _=1, math.max(1, math.floor(F.KillAllHPS)) do
            G.FireEvent:FireServer({
                Normal=Vector3.zero, Position=head.Position+Vector3.one, Hit=p.Character,
                cCF=Camera.CFrame, hS=head.Size.Magnitude, hP=head.Position,
                PartName="Head", Wallbang=true,
            }, G.EquippedWeaponFolder, nil, true, Camera.CFrame, head.Position, nil, nil)
        end
    end
end)

-- ============ PRIORITY KILL ============
RunService.Heartbeat:Connect(function()
    if not F.PriorityKill or not G.IsAlive(LP) or not G.EquippedWeaponFolder then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p==LP or not G.IsAlive(p) then continue end
        if p.Character:FindFirstChildWhichIsA("ForceField") then continue end
        local head = p.Character:FindFirstChild("Head")
        if not head then continue end
        for _=1, math.max(1, math.floor(F.PriorityHPS)) do
            G.FireEvent:FireServer({
                Normal=Vector3.zero, Position=head.Position+Vector3.one, Hit=p.Character,
                cCF=Camera.CFrame, hS=head.Size.Magnitude, hP=head.Position,
                PartName="Head", Wallbang=true,
            }, G.EquippedWeaponFolder, nil, true, Camera.CFrame, head.Position, nil, nil)
        end
    end
end)

-- ============ ANTI-SPECTATE ============
RunService.Heartbeat:Connect(function()
    if not F.AntiSpectate or not G.IsAlive(LP) then return end
    local freeze = F.AntiSpectateType == "Freeze"
    local pos = freeze and Vector3.new(9e9,9e9,9e9) or Camera.CFrame.Position
    local dir = (Camera.CFrame * CFrame.new(0,0,-1)).Position - pos
    local buf = buffer.create(36)
    buffer.writef32(buf, 0, pos.X); buffer.writef32(buf, 4, pos.Y); buffer.writef32(buf, 8, pos.Z)
    buffer.writeu8(buf, 12, (dir.X+1)*0.5*255//1); buffer.writeu8(buf, 13, (dir.Y+1)*0.5*255//1); buffer.writeu8(buf, 14, (dir.Z+1)*0.5*255//1)
    buffer.writeu8(buf, 15, bit32.bor(0,0,0,8))
    buffer.writef32(buf, 16, 0); buffer.writef32(buf, 20, freeze and 70 or 0); buffer.writef32(buf, 24, 0); buffer.writef32(buf, 28, 0); buffer.writef32(buf, 32, 0)
    pcall(function() RS.UpdateSpectate:FireServer(buf) end)
end)

-- ============ AUTO JOIN TEAM ============
task.spawn(function()
    while task.wait(1) do
        if F.AutoJoinTeam then
            pcall(function() RS.RE_Deploy:FireServer(F.JoinTeam == "Operators") end)
        end
    end
end)

-- ============ CHAT SPAM ============
local lastChat = 0
RunService.Heartbeat:Connect(function()
    if not F.ChatSpam or not G.Network or tick() - lastChat < 3 then return end
    local msg = string.rep("\n", 15) .. "neyrone on top " .. tostring(math.random(1,5))
    if F.ChatSpamType == "Advertise" then msg = string.rep("\n",15) .. "tg - neyrone_tech " .. math.random(1,5)
    elseif F.ChatSpamType == "Japanese" then msg = string.rep("的是不\n",16) .. math.random(1,5)
    elseif F.ChatSpamType == "Custom" then msg = F.ChatSpamCustom end
    pcall(function() G.Network.FireServer("Chat", msg, false) end)
    lastChat = tick()
end)

-- ============ LASER MINES ============
local lastLaser = 0
RunService.Heartbeat:Connect(function()
    if not (F.AutoActivateLaserMines or F.RemoveLaser) or not G.IsAlive(LP) then return end
    local mines = game:GetService("QueryDescendants")(workspace.Destroyable, "[$Weapon] >> TouchTransmitter")
    if #mines < 1 then return end
    for _, mine in ipairs(mines) do
        if not mine.Parent or not mine.Parent.Parent then continue end
        if mine.Parent.Parent:GetAttribute("Weapon") ~= "Laser Mine" then continue end
        local owner = mine.Parent.Parent:GetAttribute("Owner")
        if owner ~= LP.Name and mine.Parent.Parent:GetAttribute("Team") == LP:GetAttribute("Team") then continue end
        if not F.AllowYoursLaserMines and owner == LP.Name then continue end
        if F.RemoveLaser and not mine:FindFirstChild("yaica005") then
            local bv = Instance.new("BoolValue", mine.Parent); bv.Name = "yaica005"; mine:Destroy()
        end
        if F.AutoActivateLaserMines and not mine:FindFirstChild("yaica005") then
            if F.LaserMineType == "Touch" then
                pcall(function() firetouchinterest(LP.Character.HumanoidRootPart, mine.Parent, 0) end)
            else
                local wp = G.EquippedWeaponFolder
                if not wp or wp:GetAttribute("WeaponType") == "Throwable" then wp = RS.Weapons.Knife end
                local rate = wp:GetAttribute("FireRate") or 0.5
                if tick() - lastLaser < rate then return end
                G.FireEvent:FireServer({
                    Normal=-Vector3.one, Position=mine.Parent.Parent:GetPivot().Position,
                    Hit=mine.Parent.Parent, hS=mine.Parent.Parent.Size and mine.Parent.Parent.Size.Magnitude,
                    Wallbang=true, Endnormal=Vector3.one,
                }, G.EquippedWeaponFolder, nil, true, nil, nil, nil, nil)
                lastLaser = tick()
            end
        end
    end
end)

-- ============ BULLET TRACERS + HIT IMPACTS ============
local function makePart(pos)
    local p = Instance.new("Part")
    p.Name = "Tracer"; p.Size = Vector3.new(0.2,0.2,0.2); p.Position = pos
    p.Transparency = 1; p.CanCollide = false; p.Anchored = true; p.Parent = workspace.Debris
    return p
end
local function createTracer(endPos, startCol, endCol, life, texName)
    if not LP.Character:FindFirstChild("Gun") or not LP.Character.Gun:FindFirstChild("Flash") then return end
    if not Camera:FindFirstChild("Arms") or not Camera.Arms:FindFirstChild("Flash") then return end
    local startPos = (F.ThirdPerson and F.ThirdPersonDistance) and LP.Character.Gun.Flash.WorldPosition or Camera.Arms.Flash.CFrame.Position
    local p1, p2 = makePart(startPos), makePart(endPos)
    local beam = Instance.new("Beam")
    beam.Texture = TracerTex[texName] or TracerTex.Line
    local a1, a2 = Instance.new("Attachment", p1), Instance.new("Attachment", p2)
    beam.Attachment0 = a1; beam.Attachment1 = a2
    beam.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, startCol), ColorSequenceKeypoint.new(1, endCol)})
    beam.Width0 = 0.2; beam.Width1 = 0.2; beam.FaceCamera = true
    beam.Transparency = NumberSequence.new(0); beam.Parent = workspace.Debris
    task.spawn(function()
        task.wait(life)
        for i=1,10 do beam.Transparency = NumberSequence.new(i/10); task.wait(0.05) end
        beam:Destroy(); a1:Destroy(); a2:Destroy()
    end)
end
local function createImpact(pos, col, life)
    if not G.EquippedWeaponFolder or G.EquippedWeaponFolder:GetAttribute("WeaponType") == "Melee" then return end
    local p = Instance.new("Part")
    p.Transparency = 1; p.Anchored = true; p.CanCollide = false
    p.Size = Vector3.new(0.3,0.3,0.3); p.Position = pos
    local sel = Instance.new("SelectionBox", p)
    sel.LineThickness = 0; sel.SurfaceTransparency = 0.5
    sel.Color3 = col; sel.SurfaceColor3 = col; sel.Adornee = p
    p.Parent = workspace.Debris
    task.spawn(function() task.wait(life); sel:Destroy(); p:Destroy() end)
end

-- ============ HOOKS ============
if C.Hookmm and C.Hookf then
    if G.Appearance and G.Appearance.MapGunSkin then
        local orig = G.Appearance.MapGunSkin
        G.Appearance.MapGunSkin = newcclosure(function(self, name, ...)
            local arms = Camera:FindFirstChild("Arms")
            if arms and G.IsAlive(LP) and self == arms and type(name) == "string" then
                local parts = name:split("_")
                if parts[1] == "Knife" and F.KnifeEnabled and SkinsData.Knives.CurrentType then
                    local rep = SkinsData.Knives.Replacements[SkinsData.Knives.CurrentType]
                    if rep then name = rep end
                elseif SkinsData.Weapons.Replacements[parts[1]] then
                    name = SkinsData.Weapons.Replacements[parts[1]]
                end
            end
            return orig(self, name, ...)
        end)
    end

    local namecall
    namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "Raycast" and self == workspace then
            if F.SilentAim and LegitTarget and LegitHitbox and F.SilentHitChance >= math.random(1,100) then
                args[2] = (LegitHitbox.Position - args[1]).Unit * args[2].Magnitude
                return namecall(self, unpack(args))
            end
        elseif method == "PivotTo" and self.Parent == Camera and self.Name == "Arms" then
            if F.NoArmsSway and not F.ThirdPerson then args[1] = Camera.CFrame; return namecall(self, unpack(args)) end
            if F.ViewmodelOffset then
                args[1] = args[1] * CFrame.new(F.ViewmodelX/300, F.ViewmodelY/300, F.ViewmodelZ/300)
                return namecall(self, unpack(args))
            end
        elseif method == "FireServer" then
            if self == G.FireEvent and args[1] and args[1].Position then
                if F.BulletTracers then
                    task.spawn(createTracer, args[1].Position, F.BulletTracersStart, F.BulletTracersEnd, F.BulletTracersLifetime, F.BulletTracersTexture)
                end
                if F.HitImpacts then
                    task.spawn(createImpact, args[1].Position, F.HitImpactsColor, F.HitImpactsLifetime)
                end
            elseif self.Name == "Throwable" and F.TeleportThrowables then
                local target = getLegitTarget(false, math.huge)
                if target and target.Character and target.Character.Head then
                    args[2] = target.Character.Head.CFrame
                    args[3] = -100
                    return namecall(self, unpack(args))
                end
            end
        end
        return namecall(self, ...)
    end))

    local idx
    idx = hookmetamethod(game, "__index", function(self, key)
        if not checkcaller() and key == "Velocity" and self.Parent == LP.Character and F.NoArmsBob and G.IsAlive(LP) then
            return Vector3.zero
        end
        return idx(self, key)
    end)
end

-- ============ BOMB STATUS ============
local bombBarBg = Drawing.new("Square"); bombBarBg.Filled = true; bombBarBg.Color = Color3.new(0,0,0); bombBarBg.Visible = false
local bombBar = Drawing.new("Square"); bombBar.Filled = true; bombBar.Visible = false
local bombText = Drawing.new("Text"); bombText.Visible = false; bombText.Center = true; bombText.Outline = true; bombText.Size = 13
local bombTitle = Drawing.new("Text"); bombTitle.Visible = false; bombTitle.Center = true; bombTitle.Outline = true; bombTitle.Size = 13; bombTitle.Text = "Bomb Status"
local bombTimer = {T=40, Info="Site: - | Timer: 40/40"}
workspace.Debris.ChildAdded:Connect(function(obj)
    if obj.Name ~= "PlantedC4" then return end
    task.spawn(function()
        local site = RS:GetAttribute("PlantedAt") and (RS:GetAttribute("PlantedAt") == "BombB" and "B" or "A") or "A"
        if F.BombChams then
            local h = Instance.new("Highlight", obj)
            h.FillColor = F.BombChamsFill; h.OutlineColor = F.BombChamsOutline
            h.FillTransparency = 0.5; h.OutlineTransparency = 0.5
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; h.Adornee = obj
        end
        local vp = Camera.ViewportSize
        bombTitle.Position = Vector2.new(vp.X/2, 160)
        bombTitle.Visible = true
        bombText.Position = Vector2.new(vp.X/2, 185)
        bombText.Visible = true
        repeat
            task.wait(1)
            bombTimer.T -= 1
            bombTimer.Info = string.format("Site: %s | Timer: %d/40", site, bombTimer.T)
        until bombTimer.T <= 0 or RS:GetAttribute("RoundOver") or RS:GetAttribute("Preparation")
        bombTimer.T = 40; bombTimer.Info = "Site: - | Timer: 40/40"
        bombTitle.Visible = false; bombText.Visible = false
    end)
end)
RunService.RenderStepped:Connect(function()
    if not F.BombStatus then bombBarBg.Visible = false; bombBar.Visible = false; bombText.Visible = false; return end
    local vp = Camera.ViewportSize
    if bombTitle.Visible then
        bombTitle.Position = Vector2.new(vp.X/2, 160)
        bombText.Position = Vector2.new(vp.X/2, 185)
        bombText.Text = bombTimer.Info
        bombBarBg.Size = Vector2.new(502, 5); bombBarBg.Position = Vector2.new(vp.X/2 - 251, 172)
        bombBarBg.Visible = true
        bombBar.Size = Vector2.new((bombTimer.T/40) * 500, 3); bombBar.Position = Vector2.new(vp.X/2 - 250, 173)
        bombBar.Color = F.BombStatusColor; bombBar.Visible = true
    end
end)

-- ============ APPLY SKINS ============
local function applyKnife()
    if not G.IsAlive(LP) or not F.KnifeEnabled then return end
    if not G.EquippedWeapon or not table.find(SkinsData.Knives.List, G.EquippedWeapon) then return end
    LP:SetAttribute("KnifeType", SkinsData.Knives.CurrentType)
    local skin = SkinsData.Knives.Settings[SkinsData.Knives.CurrentType]
    local name = skin and skin.Enabled and skin.Skin or "Stock"
    local full = SkinsData.Knives.CurrentType .. "_" .. name
    LP:SetAttribute("KnifeSkin", full)
    local arms = Camera:FindFirstChild("Arms")
    if arms and G.Appearance and G.Appearance.MapGunSkin then
        SkinsData.Knives.Replacements[SkinsData.Knives.CurrentType] = full
        G.Appearance.MapGunSkin(arms, full, false, 0, false, LP, G.EquippedWeaponFolder, nil)
    end
end
local function applyGloves()
    if not G.IsAlive(LP) or not F.GlovesEnabled then return end
    local t = SkinsData.Gloves.CurrentType
    local skin = SkinsData.Gloves.Settings[t]
    local name = skin and skin.Enabled and skin.Skin or "Stock"
    LP:SetAttribute("CTGloves", t.."_"..name)
    LP:SetAttribute("TGloves", t.."_"..name)
    LP.Character:SetAttribute("CTGloves", t.."_"..name)
    LP.Character:SetAttribute("TGloves", t.."_"..name)
end
RunService.Heartbeat:Connect(function() task.spawn(applyKnife); task.spawn(applyGloves) end)

-- ============ APPLY CURRENT WEAPON SKIN (via Appearance hook) ============
if C.Require and G.Appearance and G.Appearance.MapGunSkin then
    -- weapon skin list builder
    local function GetWeaponSkins()
        local out = {}
        if not RS:FindFirstChild("Skins") then return out end
        for _, folder in ipairs(RS.Skins:GetChildren()) do
            if folder:IsA("Folder")
                and not table.find(SkinsData.Knives.List, folder.Name)
                and not table.find(SkinsData.Gloves.List, folder.Name) then
                local skins = {}
                for _, s in ipairs(folder:GetChildren()) do
                    if s:IsA("Folder") then table.insert(skins, s.Name) end
                end
                if #skins > 0 then out[folder.Name] = skins end
            end
        end
        return out
    end

    local allSkins = GetWeaponSkins()
    for weaponName, skins in pairs(allSkins) do
        SkinsData.Weapons.Settings[weaponName] = {Enabled=false, Skin=skins[1]}
    end

    -- Build skin toggles dynamically in Skins tab (append to existing Skins tab)
    -- (skip if you already built them, otherwise this adds them)

    local function applyCurrentWeaponSkin()
        if not G.IsAlive(LP) or not G.EquippedWeapon or G.EquippedWeapon == "C4" then return end
        if not G.EquippedWeaponFolder then return end
        if G.EquippedWeaponFolder:GetAttribute("WeaponType") == "Throwable" then return end
        local set = SkinsData.Weapons.Settings[G.EquippedWeapon]
        if not set or not set.Enabled then return end
        local arms = Camera:FindFirstChild("Arms")
        if not arms then return end
        local full = G.EquippedWeapon .. "_" .. set.Skin
        SkinsData.Weapons.Replacements[G.EquippedWeapon] = full
        LP.Character:SetAttribute("WhatSkin", full)
        G.Appearance.MapGunSkin(arms, full, false, 0, false, LP, G.EquippedWeaponFolder, nil)
    end
    RunService.Heartbeat:Connect(function() task.spawn(applyCurrentWeaponSkin) end)
end

-- ============ SCRIPT LOADED NOTIFICATION ============
local notifGui = Instance.new("ScreenGui")
notifGui.Name = "DefusalNotif"
notifGui.ResetOnSpawn = false
notifGui.Parent = LP:WaitForChild("PlayerGui")

local notif = Instance.new("Frame")
notif.Size = UDim2.new(0, 320, 0, 60)
notif.Position = UDim2.new(1, -340, 0, 20)
notif.BackgroundColor3 = Color3.fromRGB(15,0,0)
notif.BorderSizePixel = 0
notif.Parent = notifGui
Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
local nStroke = Instance.new("UIStroke", notif)
nStroke.Color = Color3.fromRGB(180,20,20); nStroke.Thickness = 1.5
local nGrad = Instance.new("UIGradient", notif)
nGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60,0,0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20,0,0)),
})
nGrad.Rotation = 45

local nTitle = Instance.new("TextLabel", notif)
nTitle.Size = UDim2.new(1,-20,0,24); nTitle.Position = UDim2.new(0,10,0,5)
nTitle.BackgroundTransparency = 1
nTitle.Text = "DEFUSAL | RED BLACK"
nTitle.TextColor3 = Color3.fromRGB(255,80,80)
nTitle.Font = Enum.Font.GothamBold; nTitle.TextSize = 14
nTitle.TextXAlignment = Enum.TextXAlignment.Left

local nMsg = Instance.new("TextLabel", notif)
nMsg.Size = UDim2.new(1,-20,0,26); nMsg.Position = UDim2.new(0,10,0,28)
nMsg.BackgroundTransparency = 1
nMsg.Text = "Loaded in " .. string.format("%.4f", os.clock()) .. "s | RightShift to open"
nMsg.TextColor3 = Color3.new(1,1,1)
nMsg.Font = Enum.Font.Gotham; nMsg.TextSize = 11
nMsg.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
    task.wait(5)
    Tween:Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(1, 20, 0, 20)}):Play()
    task.wait(0.6)
    notif:Destroy()
    notifGui:Destroy()
end)

print("[Defusal] Loaded in " .. string.format("%.4f", os.clock()) .. "s")
print("[Defusal] Press RightShift to toggle menu")
print("[Defusal] Features: Legit | Rage | Visuals | Misc | Skins | Players | Settings")
  
